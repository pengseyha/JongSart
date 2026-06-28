import '../../core/utils/screen_imports.dart';

class ClinicStaffScreen extends StatelessWidget {
  const ClinicStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pending = state.bookingsByStatus(BookingStatus.pending);
    final rescheduled = state.bookingsByStatus(BookingStatus.rescheduled);
    final confirmed = state.bookingsByStatus(BookingStatus.confirmed);
    final completed = state.bookingsByStatus(BookingStatus.completed);
    final cancelled = state.bookingsByStatus(BookingStatus.cancelled);

    return Scaffold(
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
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderGrey),
        ),
      ),
      body: state.bookings.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: emptyState(
                Icons.inbox_outlined,
                'No appointment requests',
                'New requests submitted by customers will show up here for staff to manage.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
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
                          'Demo admin view. Confirm, reschedule, complete, or cancel customer requests.',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _statCard('Pending', pending.length, const Color(0xFFB7791F)),
                    const SizedBox(width: 10),
                    _statCard('Confirmed', confirmed.length,
                        AppColors.primaryMint),
                    const SizedBox(width: 10),
                    _statCard('Completed', completed.length,
                        const Color(0xFF15803D)),
                  ],
                ),
                const SizedBox(height: 16),
                _staffSection(context, 'Pending Requests', pending),
                _staffSection(context, 'Rescheduled', rescheduled),
                _staffSection(context, 'Confirmed', confirmed),
                _staffSection(context, 'Completed', completed),
                _staffSection(context, 'Cancelled', cancelled),
              ],
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
              fontSize: 22,
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
      content: const Text('You will return to the role selection screen.'),
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
  context.go('/role-selection');
}

Widget _staffSection(
    BuildContext context, String title, List<Booking> bookings) {
  if (bookings.isEmpty) return const SizedBox.shrink();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Row(
          children: [
            Expanded(child: sectionTitle('$title (${bookings.length})')),
          ],
        ),
      ),
      for (final booking in bookings) _staffBookingCard(context, booking),
      const SizedBox(height: 8),
    ],
  );
}

Widget _staffBookingCard(BuildContext context, Booking booking) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
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
      actions.add(_staffChip('Chat', Icons.chat_bubble_outline,
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
      actions.add(_staffChip('Chat', Icons.chat_bubble_outline,
          () => context.push('/chat')));
      actions.add(_staffChip('Cancel', Icons.close, () {
        state.staffCancel(booking.id);
        notify('Booking cancelled.');
      }, danger: true));
      break;
    case BookingStatus.completed:
    case BookingStatus.cancelled:
      actions.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('No actions available.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
      ));
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
    icon: Icon(icon, size: 15),
    label: Text(label, style: const TextStyle(fontSize: 12)),
  );
}

void _showRescheduleDialog(BuildContext context, Booking booking) {
  const dates = ['Mon 30', 'Tue 1', 'Wed 2', 'Thu 3', 'Fri 4'];
  const times = ['09:00 AM', '10:30 AM', '12:30 PM', '02:00 PM', '03:30 PM'];
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
                const SizedBox(height: 12),
                const Text('Time', style: TextStyle(fontSize: 12)),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              dialogContext
                  .read<AppState>()
                  .staffReschedule(booking.id, date, time);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking rescheduled.')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
