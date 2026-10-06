import 'package:get_it/get_it.dart';

import 'controller/booking_lookup_bloc.dart';
import 'controller/my_bookings_bloc.dart';
import 'controller/ticket_bloc.dart';
import 'controller/up_next_cubit.dart';
import 'model/tickets_repository.dart';

void registerTickets(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => TicketsRepository(getIt(), getIt()))
    ..registerFactory(() => MyBookingsBloc(getIt()))
    ..registerFactory(() => GuestBookingsBloc(getIt()))
    ..registerFactory(() => BookingLookupBloc(getIt()))
    ..registerFactory(() => TicketBloc(getIt(), tracker: getIt()))
    ..registerFactory(() => UpNextCubit(getIt()));
}
