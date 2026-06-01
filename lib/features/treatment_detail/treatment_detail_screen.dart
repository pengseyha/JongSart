import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class TreatmentDetailScreen extends StatefulWidget {
  const TreatmentDetailScreen({super.key});
  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  int _currentImageIndex = 0;
  final List<String> _beforeAfter = ['BEFORE', 'AFTER'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treatment Detail')),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 250, child: PageView.builder(
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemCount: _beforeAfter.length,
            itemBuilder: (_, i) => Container(margin: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.mint.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(_beforeAfter[i], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            ),
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(2, (i) => Container(margin: const EdgeInsets.all(4), width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _currentImageIndex == i ? AppColors.mint : Colors.grey)))),
          const Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hydra-Laser', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8), Row(children: [Icon(Icons.access_time, size: 16), Text(' 45 min'), SizedBox(width: 16), Icon(Icons.attach_money), Text(' \$120')]),
            SizedBox(height: 16), Text('About the Treatment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8), Text('Multi-step rejuvenation combining laser technology with hyaluronic acid.'),
            SizedBox(height: 24), Text('FAQs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8), _FaqItem(question: 'Is it painful?', answer: 'Slight tingling. Numbing applied.'),
            _FaqItem(question: 'How many sessions?', answer: '3-6 sessions, 4 weeks apart.'),
          ])),
          const SizedBox(height: 80),
        ]),
      ),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: ElevatedButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking flow coming soon!'))),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.mint, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        child: const Text('Book Appointment', style: TextStyle(fontSize: 16)),
      ))),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question, answer;
  const _FaqItem({required this.question, required this.answer});
  @override
  State<_FaqItem> createState() => _FaqItemState();
}
class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(margin: const EdgeInsets.only(bottom: 8), child: Column(children: [
      ListTile(title: Text(widget.question), trailing: IconButton(icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more), onPressed: () => setState(() => _expanded = !_expanded))),
      if (_expanded) Padding(padding: const EdgeInsets.all(16), child: Text(widget.answer, style: const TextStyle(color: Colors.grey))),
    ]));
  }
}
