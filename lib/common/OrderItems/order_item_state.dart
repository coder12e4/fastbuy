part of 'order_item_cubit.dart';

@immutable
sealed class OrderItemState {}

final class OrderItemInitial extends OrderItemState {}

final class OrderStatusChangeLoading extends OrderItemState {}

final class OrderPending extends OrderItemState {}

final class OrderItemPacked extends OrderItemState {}

final class OrderItemIDelivered extends OrderItemState {}

final class OrderItemReceived extends OrderItemState {}
