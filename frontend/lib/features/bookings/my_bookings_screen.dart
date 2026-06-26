part of '../app_flows/app_flow_screens.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<AppState>().bookings;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'My Bookings'),
      body: bookings.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 40),
                _emptyState(
                  Icons.event_busy_outlined,
                  'No bookings yet',
                  'Your appointment requests will appear here. Book a consultation to get started.',
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.push('/booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Book Consultation'),
                ),
              ],
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final booking in bookings)
                  _bookingCard(context, booking),
              ],
            ),
    );
  }
}

Widget _bookingCard(BuildContext context, Booking booking) {
  return InkWell(
    onTap: () => context.push('/booking-detail/${booking.id}'),
    borderRadius: BorderRadius.circular(14),
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.clinicName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _titleStyle(),
                ),
              ),
              _statusBadge(booking.status),
            ],
          ),
          const SizedBox(height: 8),
          _miniRow(Icons.spa_outlined, booking.treatmentName),
          if (booking.doctorName != null)
            _miniRow(Icons.person_outline, booking.doctorName!),
          _miniRow(
              Icons.calendar_today_outlined, '${booking.date} - ${booking.time}'),
          _miniRow(Icons.phone_outlined, booking.phone),
          const Divider(height: 20),
          Row(
            children: [
              if (booking.status == BookingStatus.pending)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmCancel(context, booking.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD4465D),
                      side: const BorderSide(color: Color(0xFFE7B6C0)),
                    ),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Cancel'),
                  ),
                ),
              if (booking.status == BookingStatus.pending)
                const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/booking-detail/${booking.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMint,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View Detail'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _miniRow(IconData icon, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textDark, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

void _confirmCancel(BuildContext context, String bookingId) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Cancel request?'),
      content: const Text(
          'This will cancel your pending appointment request. You can book again anytime.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Keep'),
        ),
        TextButton(
          onPressed: () {
            dialogContext.read<AppState>().cancelByCustomer(bookingId);
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Appointment request cancelled.')),
            );
          },
          child: const Text('Cancel request',
              style: TextStyle(color: Color(0xFFD4465D))),
        ),
      ],
    ),
  );
}
