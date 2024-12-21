import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calculate_price_state.dart';

class CalculatePriceCubit extends Cubit<CalculatePriceState> {
  CalculatePriceCubit() : super(CalculatePriceInitial());
}
