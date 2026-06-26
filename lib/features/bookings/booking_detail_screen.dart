part of '../app_flows/app_flow_screens.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<AppState>().bookingById(bookingId);

    if (booking == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: _flowAppBar(context, 'Booking Detail'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _emptyState(
            Icons.error_outline,
            'Booking not found',
            'This booking may have been removed.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _flowAppBar(context, 'Booking Detail'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _panelDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(booking.treatmentName, style: _titleStyle()),
                    ),
                    _statusBadge(booking.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Booking ID: ${booking.id}',
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _panelDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Appointment'),
                const SizedBox(height: 10),
                _summaryRow(Icons.local_hospital_outlined, 'Clinic',
                    booking.clinicName),
                _summaryRow(
                    Icons.spa_outlined, 'Treatment', booking.treatmentName),
                if (booking.doctorName != null)
                  _summaryRow(
                      Icons.person_outline, 'Doctor', booking.doctorName!),
                _summaryRow(Icons.healing_outlined, 'Concern', booking.concern),
                _summaryRow(
                    Icons.calendar_today_outlined, 'Date', booking.date),
                _summaryRow(Icons.schedule, 'Time', booking.time),
                if (booking.note.isNotEmpty)
                  _summaryRow(Icons.notes_outlined, 'Note', booking.note),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _panelDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Patient'),
                const SizedBox(height: 10),
                _summaryRow(
                    Icons.person_outline, 'Name', booking.patientName),
                _summaryRow(Icons.phone_outlined, 'Phone', booking.phone),
                if (booking.telegramOrWhatsapp != null)
                  _summaryRow(Icons.send_outlined, 'Telegram/WhatsApp',
                      booking.telegramOrWhatsapp!),
                _summaryRow(Icons.access_time, 'Created',
                    _formatDate(booking.createdAt)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ..._actionsForStatus(context, booking),
        ],
      ),
    );
  }
}

List<Widget> _actionsForStatus(BuildContext context, Booking booking) {
  switch (booking.status) {
    case BookingStatus.pending:
    case BookingStatus.rescheduled:
      return [
        _primaryAction(
          'Chat Clinic',
          Icons.chat_bubble_outline,
          () => context.push('/chat'),
        ),
        const SizedBox(height: 10),
        _outlinedAction(
          'Cancel Request',
          Icons.close,
          () {
            context.read<AppState>().cancelByCustomer(booking.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Appointment request cancelled.')),
            );
          },
          danger: true,
        ),
      ];
    case BookingStatus.confirmed:
      return [
        _primaryAction(
          'Chat Clinic',
          Icons.chat_bubble_outline,
          () => context.push('/chat'),
        ),
        const SizedBox(height: 10),
        _outlinedAction(
          'View Map',
          Icons.map_outlined,
          () => context.push('/map'),
        ),
      ];
    case BookingStatus.completed:
      return [
        _primaryAction(
          'Leave Review',
          Icons.rate_review_outlined,
          () => _showReviewSheet(context, booking),
        ),
      ];
    case BookingStatus.cancelled:
      return [
        _primaryAction(
          'Book Again',
          Icons.refresh,
          () => context.push(
              '/booking?clinicId=${booking.clinicId}&treatmentId=${booking.treatmentId}'),
        ),
      ];
  }
}

Widget _primaryAction(String label, IconData icon, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryMint,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    ),
  );
}

Widget _outlinedAction(String label, IconData icon, VoidCallback onTap,
    {bool danger = false}) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            danger ? const Color(0xFFD4465D) : AppColors.primaryMint,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(
            color: danger ? const Color(0xFFE7B6C0) : AppColors.borderGrey),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    ),
  );
}

void _showReviewSheet(BuildContext context, Booking booking) {
  int rating = 5;
  final commentController = TextEditingController();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Leave a review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('How was your ${booking.treatmentName}?',
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 14),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () =>
                          setSheetState(() => rating = index + 1),
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: AppColors.primaryMint,
                        size: 30,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a short comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AppState>().addReview(
                            PatientReview(
                              id: 'review_${DateTime.now().millisecondsSinceEpoch}',
                              name: booking.patientName.isEmpty
                                  ? 'Guest'
                                  : booking.patientName,
                              label: booking.treatmentName,
                              body: commentController.text.trim().isEmpty
                                  ? 'Great experience.'
                                  : commentController.text.trim(),
                              rating: rating.toDouble(),
                            ),
                          );
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Thank you for your review!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit Review'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
