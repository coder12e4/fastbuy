part of 'calculate_price_cubit.dart';

@immutable
sealed class CalculatePriceState {}

final class CalculatePriceInitial extends CalculatePriceState {}

final class CalculatePriceLoding extends CalculatePriceState {}

final class CalculatePriceSuccess extends CalculatePriceState {}

final class CalculatePriceFail extends CalculatePriceState {}
