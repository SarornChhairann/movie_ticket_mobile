import 'package:get_it/get_it.dart';

import 'controller/my_bookings_bloc.dart';
import 'controller/ticket_bloc.dart';
import 'model/tickets_repository.dart';

void registerTickets(GetIt getIt) {
  getIt
    ..registerLazySingleton(() => TicketsRepository(getIt()))
    ..registerFactory(() => MyBookingsBloc(getIt()))
    ..registerFactory(() => TicketBloc(getIt()));
}
