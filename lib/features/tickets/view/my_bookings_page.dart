import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/format/locale_format.dart';
import '../../../core/model/booking_summary.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../controller/my_bookings_bloc.dart';
import '../model/tickets_failure.dart';
import 'booking_status_chip.dart';
import 'offline_note.dart';

/// Shows a cancel outcome once. Shared by the list and the detail screen.
class MyBookingsEffectListener extends StatelessWidget {
  const MyBookingsEffectListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBookingsBloc, MyBookingsState>(
      listenWhen: (previous, current) =>
          current is MyBookingsReady &&
          current.effect != null &&
          (previous is! MyBookingsReady || previous.effect != current.effect || previous.message != current.message),
      listener: (context, state) {
        final s = state as MyBookingsReady;
        final message = s.message ?? '';
        final text = switch (s.effect!) {
          MyBookingsEffect.cancelled => 'tickets.cancelled'.tr(context: context),
          MyBookingsEffect.error => message.isEmpty ? 'shell.offline'.tr(context: context) : message,
        };
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(text)));
      },
      child: child,
    );
  }
}

/// The account's bookings, or — with a [GuestBookingsBloc] above it — the bookings
/// a guest made or found on this phone, with **Find my booking** and sign-in.
class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key, this.onSignIn});

  /// Guests only: opens sign-in for the account's bookings.
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    final guest = context.read<MyBookingsBloc>().guest;
    return Scaffold(
      appBar: AppBar(title: Text('tickets.title'.tr(context: context))),
      body: MyBookingsEffectListener(
        child: BlocBuilder<MyBookingsBloc, MyBookingsState>(
          builder: (context, state) => switch (state) {
            MyBookingsInitial() || MyBookingsLoading() => const Skeleton(
                key: Key('bookings.skeleton'),
                child: Padding(
                  padding: EdgeInsets.all(Space.x2),
                  child: Column(children: [SkeletonListTile(), SkeletonListTile(), SkeletonListTile()]),
                ),
              ),
            MyBookingsReady(:final bookings, :final offline) => Column(
                children: [
                  if (offline) const OfflineNote(),
                  if (guest) _GuestHeader(onSignIn: onSignIn),
                  Expanded(child: _BookingList(bookings: bookings, guest: guest)),
                ],
              ),
            MyBookingsFailure(:final failure) => ErrorView(
                message: switch (failure) {
                  TicketsNetwork() => 'shell.offline'.tr(context: context),
                  TicketsNotFound() => 'tickets.notFound'.tr(context: context),
                  _ => failure.message,
                },
                onRetry: () => context.read<MyBookingsBloc>().add(const LoadRequested()),
              ),
          },
        ),
      ),
    );
  }
}

/// Guests: find a booking by reference + phone, or sign in for the account's list.
class _GuestHeader extends StatelessWidget {
  const _GuestHeader({this.onSignIn});

  final VoidCallback? onSignIn;

  Future<void> _find(BuildContext context) async {
    final bloc = context.read<MyBookingsBloc>();
    final navigator = Navigator.of(context);
    final found = await navigator.pushNamed<BookingSummary>(AppRoutes.bookingLookup);
    if (found == null) return;
    bloc.add(BookingFound(found));
    await navigator.pushNamed(AppRoutes.bookingDetail, arguments: (bloc, found.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.x2, Space.x2, Space.x2, 0),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              key: const Key('tickets.find'),
              icon: const Icon(Icons.search),
              label: Text('tickets.find'.tr(context: context)),
              onPressed: () => _find(context),
            ),
          ),
          if (onSignIn != null) ...[
            const SizedBox(width: Space.x1),
            TextButton(
              key: const Key('tickets.signIn'),
              onPressed: onSignIn,
              child: Text('tickets.signIn'.tr(context: context)),
            ),
          ],
        ],
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({required this.bookings, required this.guest});

  final List<BookingSummary> bookings;
  final bool guest;

  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<MyBookingsBloc>()..add(const RefreshRequested());
    return bloc.stream.firstWhere((s) => s is! MyBookingsReady || !s.refreshing);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: bookings.isEmpty
          // Scrollable so pull to refresh still works on an empty list.
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: Space.x6),
                EmptyView(messageKey: guest ? 'tickets.guestEmpty' : 'tickets.empty'),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Space.x2),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: Space.x1),
              itemBuilder: (context, i) => guest
                  // Only takes it off this phone; the booking itself is unchanged.
                  ? Dismissible(
                      key: Key('forget.${bookings[i].bookingId}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: Space.x3),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Text('tickets.forget'.tr(context: context)),
                      ),
                      onDismissed: (_) => context.read<MyBookingsBloc>().add(ForgetRequested(bookings[i].bookingId)),
                      child: _BookingCard(booking: bookings[i]),
                    )
                  : _BookingCard(booking: bookings[i]),
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final BookingSummary booking;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      key: Key('booking.${booking.bookingId}'),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          AppRoutes.bookingDetail,
          arguments: (context.read<MyBookingsBloc>(), booking.bookingId),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.x2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(booking.movieTitle, style: textTheme.titleMedium)),
                  BookingStatusChip(status: booking.status, refund: booking.refund),
                ],
              ),
              const SizedBox(height: Space.x0_5),
              Text(showLine(context, booking)),
              const SizedBox(height: Space.x0_5),
              Row(
                children: [
                  Expanded(child: Text(booking.seatCodes.join(', '))),
                  Text(context.money(booking.totalAmount), style: textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
