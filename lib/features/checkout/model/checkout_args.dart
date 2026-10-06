import '../../seats/model/seat_map.dart';
import '../controller/booking_flow_cubit.dart';

/// Checkout route argument inside a booking flow: the hold, and the flow cubit
/// the seat map created, so every step reads the same progress and capsule.
class CheckoutArgs {
  const CheckoutArgs({required this.hold, this.flow});

  final Hold hold;
  final BookingFlowCubit? flow;
}
