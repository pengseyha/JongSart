import '../../core/utils/screen_imports.dart';

class ClinicStaffScreen extends StatelessWidget {
  const ClinicStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pending = state.bookingsByStatus(BookingStatus.pending);
    final rescheduled = state.bookingsByStatus(BookingStatus.rescheduled);
    final pendingQueue = [...pending, ...rescheduled];
    final confirmed = state.bookingsByStatus(BookingStatus.confirmed);
    final completed = state.bookingsByStatus(BookingStatus.completed);
    final cancelled = state.bookingsByStatus(BookingStatus.cancelled);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Clinic Staff Dashboard',
            style: TextStyle(
              color: Color(0xFF007D68),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            if (state.isStaff)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: () => _confirmStaffLogout(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFD4465D),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Log out',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(49),
            child: Column(
              children: [
                Divider(height: 1, color: AppColors.borderGrey),
                TabBar(
                  isScrollable: true,
                  labelColor: AppColors.primaryMint,
                  unselectedLabelColor: AppColors.textGrey,
                  indicatorColor: AppColors.primaryMint,
                  labelStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Confirmed'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Cancelled'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMintLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.primaryMint),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Admin view. Confirm customer request, reply in chat, and mark visits completed.',
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statCard('Pending', pendingQueue.length,
                          const Color(0xFFB7791F)),
                      const SizedBox(width: 10),
                      _statCard(
                          'Confirmed', confirmed.length, AppColors.primaryMint),
                      const SizedBox(width: 10),
                      _statCard('Completed', completed.length,
                          const Color(0xFF15803D)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _staffTab(
                    context,
                    pendingQueue,
                    Icons.pending_actions_outlined,
                    'No pending requests',
                    'Customer appointment requests will appear here first.',
                  ),
                  _staffTab(
                    context,
                    confirmed,
                    Icons.event_available_outlined,
                    'No confirmed booking',
                    'Confirmed appointments will be ready to complete',
                  ),
                  _staffTab(
                    context,
                    completed,
                    Icons.task_alt_outlined,
                    'No completed visits',
                    'Completed bookings will stay here for review tracking.',
                  ),
                  _staffTab(
                    context,
                    cancelled,
                    Icons.event_busy_outlined,
                    'No cancelled bookings',
                    'Cancelled requests will appear here.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statCard(String label, int count, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _confirmStaffLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Log out?'),
      content: const Text('Return to the login screen.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Log out'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;
  await context.read<AppState>().logout();
  if (!context.mounted) return;
  context.go('/login');
}

Widget _staffTab(
  BuildContext context,
  List<Booking> bookings,
  IconData emptyIcon,
  String emptyTitle,
  String emptyBody,
) {
  if (bookings.isEmpty) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        emptyState(emptyIcon, emptyTitle, emptyBody),
      ],
    );
  }

  return ListView(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
    children: [
      for (final booking in bookings) _staffBookingCard(context, booking),
    ],
  );
}

Widget _staffBookingCard(BuildContext context, Booking booking) {
  return Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(15),
    decoration: panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                  booking.patientName.isEmpty ? 'Guest' : booking.patientName,
                  style: titleStyle()),
            ),
            statusBadge(booking.status),
          ],
        ),
        const SizedBox(height: 6),
        miniRow(Icons.spa_outlined, booking.treatmentName),
        miniRow(
            Icons.calendar_today_outlined, '${booking.date} - ${booking.time}'),
        miniRow(Icons.phone_outlined, booking.phone),
        const Divider(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _staffActions(context, booking),
        ),
      ],
    ),
  );
}

List<Widget> _staffActions(BuildContext context, Booking booking) {
  final state = context.read<AppState>();
  final actions = <Widget>[];

  void notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  switch (booking.status) {
    case BookingStatus.pending:
    case BookingStatus.rescheduled:
      actions.add(_staffChip('Confirm', Icons.check, () {
        state.staffConfirm(booking.id);
        notify('Booking confirmed.');
      }));
      actions.add(_staffChip('Reschedule', Icons.schedule, () {
        _showRescheduleDialog(context, booking);
      }));
      actions.add(_staffChip('Reply Chat', Icons.chat_bubble_outline,
          () => context.push('/chat')));
      actions.add(_staffChip('Cancel', Icons.close, () {
        state.staffCancel(booking.id);
        notify('Booking cancelled.');
      }, danger: true));
      break;
    case BookingStatus.confirmed:
      actions.add(_staffChip('Mark Completed', Icons.task_alt, () {
        state.staffComplete(booking.id);
        notify('Booking marked as completed.');
      }));
      actions.add(_staffChip('Reschedule', Icons.schedule, () {
        _showRescheduleDialog(context, booking);
      }));
      actions.add(_staffChip('Reply Chat', Icons.chat_bubble_outline,
          () => context.push('/chat')));
      actions.add(_staffChip('Cancel', Icons.close, () {
        state.staffCancel(booking.id);
        notify('Booking cancelled');
      }, danger: true));
      break;
    case BookingStatus.completed:
    case BookingStatus.cancelled:
      actions.add(_staffChip('Reply Chat', Icons.chat_bubble_outline,
          () => context.push('/chat')));
      break;
  }
  return actions;
}

Widget _staffChip(String label, IconData icon, VoidCallback onTap,
    {bool danger = false}) {
  final color = danger ? const Color(0xFFD4465D) : AppColors.primaryMint;
  return OutlinedButton.icon(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      visualDensity: VisualDensity.compact,
    ),
    icon: Icon(icon, size: 14),
    label: Text(label, style: const TextStyle(fontSize: 12)),
  );
}

void _showRescheduleDialog(BuildContext context, Booking booking) {
  const dates = ['Mon 30', 'Tue 1', 'Wed 2', 'Thu 3', 'Fri 4'];
  const times = ['09:10 AM', '10:40 AM', '12:40 PM', '02:10 PM', '03:40 PM'];
  String date = booking.date;
  String time = booking.time;

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Reschedule'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Date', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: dates
                      .map((d) => timeChip(d, d == date,
                          onTap: () => setDialogState(() => date = d)))
                      .toList(),
                ),
                const SizedBox(height: 11),
                const Text('Times', style: TextStyle(fontSize: 11)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: times
                      .map((t) => timeChip(t, t == time,
                          onTap: () => setDialogState(() => time = t)))
                      .toList(),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancels'),
          ),
          ElevatedButton(
            onPressed: () {
              dialogContext
                  .read<AppState>()
                  .staffReschedule(booking.id, date, time);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking Reschedul.')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
