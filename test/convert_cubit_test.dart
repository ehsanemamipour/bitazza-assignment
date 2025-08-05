import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bitazza_assignment/features/coin/presentation/blocs/convert/convert_cubit.dart';
import 'package:bitazza_assignment/features/coin/presentation/blocs/coin/coin_bloc.dart';
import 'package:bitazza_assignment/features/coin/data/models/coin_model.dart';

// Mocks and fakes
class MockCoinBloc extends Mock implements CoinBloc {}

class FakeCoinState extends Fake implements CoinState {}

class FakeCoinEvent extends Fake implements CoinEvent {}

void main() {
  late MockCoinBloc mockBloc;
  late StreamController<CoinState> controller;
  late ConvertCubit cubit;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(FakeCoinState());
    registerFallbackValue(FakeCoinEvent());
  });

  setUp(() {
    mockBloc = MockCoinBloc();
    controller = StreamController<CoinState>();
    // Stub the bloc's stream and state
    when(() => mockBloc.stream).thenAnswer((_) => controller.stream);
    when(() => mockBloc.state).thenReturn(CoinInitial());
    cubit = ConvertCubit(mockBloc);
  });

  tearDown(() async {
    await cubit.close();
    await controller.close();
  });

  test('initial state is ConvertState.initial()', () {
    expect(cubit.state.currency, 'USD');
    expect(cubit.state.amount, 0.0);
    expect(cubit.state.converted, 0.0);
    expect(cubit.state.rates, isEmpty);
  });

  test('conversion on rates update and user interactions', () async {
    final rates = [
      const CoinModel(id: 1, name: 'TestCoin', price: 2.0, symbol: 'TST'),
      const CoinModel(id: 2, name: 'OtherCoin', price: 4.0, symbol: 'OTH'),
    ];

    // Before update: converted should be 0.0
    expect(cubit.state.converted, 0.0);

    // Simulate a CoinLoaded event from the bloc
    controller.add(CoinLoaded(rates));
    await Future.delayed(Duration.zero);

    // After rates update
    expect(cubit.state.rates, rates);
    expect(cubit.state.converted, 0.0); // amount is still 0

    // Change amount
    cubit.amountChanged('8.0');
    expect(cubit.state.amount, 8.0);
    expect(cubit.state.converted, 8.0);

    // Change currency to an existing symbol
    cubit.currencyChanged('OTH');
    expect(cubit.state.currency, 'OTH');
    expect(cubit.state.converted, 8.0 / 4.0);

    // Change currency to a non-existing symbol: fallback price=1
    cubit.currencyChanged('XYZ');
    expect(cubit.state.currency, 'XYZ');
    expect(cubit.state.converted, 8.0);
  });
}
