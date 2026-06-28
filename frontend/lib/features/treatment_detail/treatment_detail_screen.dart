import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_model.dart';
import '../../state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/image_mapper.dart';

class TreatmentDetailScreen extends StatefulWidget {
  final String? treatmentId;

  const TreatmentDetailScreen({super.key, this.treatmentId});

  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  bool _isFavorite = false;

  final List<_FaqData> _faqs = const [
    _FaqData(
      'Is the treatment painful?',
      'Most patients experience a slight tingling sensation. We apply a topical numbing agent to keep the session comfortable.',
    ),
    _FaqData('How many sessions are needed?', 'Most plans use 2-5 sessions.'),
    _FaqData('Any post-treatment care?',
        'Use SPF and avoid exfoliation for 72 hours.'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final selectedTreatment = widget.treatmentId == null
        ? null
        : state.treatmentById(widget.treatmentId!);
    final treatment = selectedTreatment ??
        (state.treatments.isNotEmpty ? state.treatments.first : null);
    final treatmentName = treatment?.title ?? 'Hydra Facial Care';
    final category = treatment?.category ?? 'Facial Care';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF007D68)),
        ),
        centerTitle: true,
        title: const Text(
          'JongSart',
          style: TextStyle(
            color: Color(0xFF007D68),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.notifications_none, color: Color(0xFF007D68)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _beforeAfterHero(treatment?.id ?? 'treatment_hydra'),
          const SizedBox(height: 8),
          _summaryCard(context, treatment),
          const SizedBox(height: 20),
          _sectionTitle('About the Treatment'),
          const SizedBox(height: 10),
          Text(
            '$treatmentName is a carefully planned $category skincare service. It may help with texture, dullness, congestion, or uneven tone depending on your skin profile while keeping consultation and aftercare clear.',
            style: const TextStyle(
                color: AppColors.textGrey, fontSize: 13, height: 1.55),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FAF9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF007D68)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Information in this app is for booking and consultation support only. Please consult clinic staff or a qualified doctor before treatment.',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                  child: _InfoBox(
                      title: 'May Help With',
                      body: 'Dullness, sun damage, fine lines')),
              SizedBox(width: 10),
              Expanded(
                  child:
                      _InfoBox(title: 'Downtime', body: 'Minimal (2-4 hours)')),
            ],
          ),
          const SizedBox(height: 22),
          _sectionTitle('The Journey'),
          const SizedBox(height: 14),
          const _JourneyStep('1', 'Consultation',
              'Deep skin analysis and treatment customization.'),
          const _JourneyStep('2', 'Preparation',
              'Double cleansing and numbing gel application.'),
          const _JourneyStep('3', 'Treatment',
              'Care session performed by trained clinic staff.'),
          const _JourneyStep(
              '4', 'Recovery', 'Cooling mask and SPF application.'),
          const SizedBox(height: 22),
          _sectionTitle('FAQ'),
          const SizedBox(height: 10),
          ..._faqs.map((faq) => _FaqTile(faq: faq)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _sectionTitle('Similar Treatments')),
              TextButton(
                  onPressed: () => context.go('/search'),
                  child: const Text('View All')),
            ],
          ),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _SimilarTreatment(
                    title: 'Brightening Facial Care', price: '\$40'),
                _SimilarTreatment(
                    title: 'Deep Cleansing Facial', price: '\$35'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _beforeAfterHero(String treatmentId) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Image.asset(
            treatmentImageById(treatmentId),
            height: 210,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 210,
              color: AppColors.primaryMintLight,
              child: const Icon(Icons.face_retouching_natural,
                  size: 54, color: Color(0xFF007D68)),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    const Color(0xFF5BD9C4).withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(left: 11, top: 12, child: _HeroLabel('Before')),
          const Positioned(right: 11, top: 12, child: _HeroLabel('After')),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF3FCDB5),
                child: Icon(Icons.swap_horiz, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, Treatment? treatment) {
    final state = context.watch<AppState>();
    final title = treatment?.title ?? 'Hydra Facial Care';
    final category = treatment?.category ?? 'Facial Care';
    final price = treatment?.price ?? '\$45.00';
    final treatmentId = treatment?.id;
    final isFavorite =
        treatmentId == null ? _isFavorite : state.isFavorite(treatmentId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeroLabel(category),
              const Spacer(),
              Text(price,
                  style: const TextStyle(
                      color: Color(0xFF007D68),
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, height: 1.05),
          ),
          const SizedBox(height: 6),
          const Text('JongSart Skin Clinic, BKK1, Phnom Penh',
              style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
          const Divider(height: 22),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final query = treatmentId == null
                        ? ''
                        : '?treatmentId=${Uri.encodeComponent(treatmentId)}';
                    context.push('/booking$query');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007D68),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Book Appointment'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () {
                  if (treatmentId == null) {
                    setState(() => _isFavorite = !_isFavorite);
                  } else {
                    context.read<AppState>().toggleFavorite(treatmentId);
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFF007D68),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _HeroLabel extends StatelessWidget {
  final String label;

  const _HeroLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF007D68).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String body;

  const _InfoBox({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFF007D68),
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          Text(body,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 11, height: 1.35)),
        ],
      ),
    );
  }
}

class _JourneyStep extends StatelessWidget {
  final String number;
  final String title;
  final String body;

  const _JourneyStep(this.number, this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF007D68),
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(body,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 11, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final _FaqData faq;

  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (value) => setState(() => _expanded = value),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(widget.faq.question,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: [
          Text(widget.faq.answer,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12, height: 1.45)),
        ],
      ),
    );
  }
}

class _SimilarTreatment extends StatelessWidget {
  final String title;
  final String price;

  const _SimilarTreatment({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 86,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              gradient: LinearGradient(
                  colors: [Color(0xFFBFEFE4), Color(0xFF7BC5A8)]),
            ),
            child: const Center(
                child: Icon(Icons.spa_outlined, color: Colors.white, size: 34)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 12)),
                const SizedBox(height: 8),
                Text(price,
                    style: const TextStyle(
                        color: Color(0xFF007D68),
                        fontWeight: FontWeight.w800,
                        fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqData {
  final String question;
  final String answer;

  const _FaqData(this.question, this.answer);
}
