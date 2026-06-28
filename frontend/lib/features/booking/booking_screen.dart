import '../../core/utils/screen_imports.dart';

class BookingScreen extends StatefulWidget {
  final String? clinicId;
  final String? treatmentId;
  final String? doctorId;

  const BookingScreen({
    super.key,
    this.clinicId,
    this.treatmentId,
    this.doctorId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _telegramController = TextEditingController();
  final _noteController = TextEditingController();

  static const _concerns = [
    'Acne & Breakouts',
    'Dark Spots',
    'Sensitive Skin',
    'Dry Skin',
    'Anti-aging',
    'Scar Treatment',
  ];
  static const _dates = ['Mon 30', 'Tue 1', 'Wed 2', 'Thu 3', 'Fri 4'];
  static const _times = [
    '09:00 AM',
    '10:30 AM',
    '12:30 PM',
    '02:00 PM',
    '03:30 PM',
  ];

  late String _concern;
  String? _clinicId;
  String? _treatmentId;
  String? _doctorId;
  String _date = 'Mon 30';
  String _time = '09:00 AM';

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _concern = state.selectedConcern;
    // Pre-fill contact details for the signed-in customer so the booking is
    // automatically tied to their account.
    if (state.isLoggedIn && state.isCustomer) {
      _nameController.text = state.userName;
      _phoneController.text = state.phone;
    }
    _clinicId = widget.clinicId ??
        (state.clinics.isNotEmpty ? state.clinics.first.id : null);
    _treatmentId = widget.treatmentId ??
        (state.treatments.isNotEmpty ? state.treatments.first.id : null);
    _doctorId = widget.doctorId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _telegramController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final state = context.read<AppState>();
    final clinic = state.clinicById(_clinicId ?? '');

    final treatment = state.treatmentById(_treatmentId ?? '');
    final doctor = state.doctorById(_doctorId ?? '');

    state.submitBookingRequest(
      patientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      telegramOrWhatsapp: _telegramController.text.trim(),
      concern: _concern,
      treatmentId: _treatmentId ?? '',
      treatmentName: treatment?.title ?? 'Consultation',
      clinicId: _clinicId ?? '',
      clinicName: clinic?.name ?? 'JongSart Clinic',
      doctorId: doctor?.id,
      doctorName: doctor?.name,
      date: _date,
      time: _time,
      note: _noteController.text.trim(),
    );
    state.addBookingChatNotice();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking request created as Pending Confirmation.'),
      ),
    );
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryMintLight,
                child: Icon(Icons.check_circle,
                    color: AppColors.primaryMint, size: 36),
              ),
              const SizedBox(height: 14),
              const Text(
                'Request sent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your appointment request has been sent. Clinic staff will contact you to confirm the schedule.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textGrey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/my-bookings');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.event_note),
                  label: const Text('View My Bookings'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/chat');
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat Clinic'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryMint, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (_clinicId == null && state.clinics.isNotEmpty) {
      _clinicId = state.clinics.first.id;
    } else if (_clinicId != null && state.clinicById(_clinicId!) == null) {
      _clinicId = state.clinics.isNotEmpty ? state.clinics.first.id : null;
    }
    if (_treatmentId == null && state.treatments.isNotEmpty) {
      _treatmentId = state.treatments.first.id;
    } else if (_treatmentId != null &&
        state.treatmentById(_treatmentId!) == null) {
      _treatmentId =
          state.treatments.isNotEmpty ? state.treatments.first.id : null;
    }
    if (_doctorId != null && state.doctorById(_doctorId!) == null) {
      _doctorId = null;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: flowAppBar(context, 'Book Consultation'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Request an appointment',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Send your details and clinic staff will contact you to confirm.',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            const SizedBox(height: 18),
            sectionTitle('Your contact details'),
            const SizedBox(height: 10),
            _textField(
              controller: _nameController,
              label: 'Full name',
              icon: Icons.person_outline,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 11),
            _textField(
              controller: _phoneController,
              label: 'Phone numbers',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.trim().length < 6)
                  ? 'Please enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 12),
            _textField(
              controller: _telegramController,
              label: 'Telegram / WhatsApp ',
              icon: Icons.send_outlined,
            ),
            const SizedBox(height: 18),
            sectionTitle('Skin concern'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _concerns
                  .map((concern) => timeChip(
                        concern,
                        _concern == concern,
                        onTap: () => setState(() => _concern = concern),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
            sectionTitle('Clinic & treatment'),
            const SizedBox(height: 10),
            _dropdown<String>(
              label: 'Clinic',
              value: _clinicId,
              items: state.clinics
                  .map((clinic) => DropdownMenuItem(
                        value: clinic.id,
                        child:
                            Text(clinic.name, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _clinicId = value),
            ),
            const SizedBox(height: 12),
            _dropdown<String>(
              label: 'Treatment',
              value: _treatmentId,
              items: state.treatments
                  .map((treatment) => DropdownMenuItem(
                        value: treatment.id,
                        child: Text(treatment.title,
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _treatmentId = value),
            ),
            const SizedBox(height: 12),
            _dropdown<String?>(
              label: 'Doctor (optional)',
              value: _doctorId,
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('No preference')),
                ...state.doctors.map((doctor) => DropdownMenuItem(
                      value: doctor.id,
                      child: Text('${doctor.name} - ${doctor.specialty}',
                          overflow: TextOverflow.ellipsis),
                    )),
              ],
              onChanged: (value) => setState(() => _doctorId = value),
            ),
            const SizedBox(height: 18),
            sectionTitle('Preferred date'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dates
                  .map((date) => timeChip(
                        date,
                        _date == date,
                        onTap: () => setState(() => _date = date),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            sectionTitle('Preferred time'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _times
                  .map((time) => timeChip(
                        time,
                        _time == time,
                        onTap: () => setState(() => _time = time),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 18),
            sectionTitle('Note (optional)'),
            const SizedBox(height: 10),
            _textField(
              controller: _noteController,
              label: 'Anything the clinic should know?',
              icon: Icons.notes_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            const Text(
              'Consult with clinic staff before treatment',
              style: TextStyle(color: AppColors.textGrey, fontSize: 11),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMint,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              'Submit Appointment Request',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
