import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/condition.dart';
import 'data/ayur_conditions.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AyurHealth+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _symptomsController = TextEditingController();
  File? _image;
  bool _loading = false;
  List<DiagnosisResult> _diagnosisResult = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _onDiagnose() {
    setState(() {
      _loading = true;
      _diagnosisResult = [];
    });

    final symptoms = _symptomsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();

    List<DiagnosisResult> matches = [];
    for (var condition in ayurConditions) {
      final matchedSymptoms = condition.symptoms.where((s) => symptoms.contains(s)).toList();
      if (matchedSymptoms.isNotEmpty) {
        final score = matchedSymptoms.length / max(1, condition.symptoms.length);
        matches.add(DiagnosisResult(
          condition: condition,
          score: score,
          matchedSymptoms: matchedSymptoms,
        ));
      }
    }

    matches.sort((a, b) => b.score.compareTo(a.score));
    
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _diagnosisResult = matches.take(3).toList();
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AyurHealth+'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'AyurHealth+',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'लक्षण लिखें (उदा: खांसी, बुखार)',
                hintText: 'लक्षणों को कॉमा से अलग करें',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('जीभ/चेहरे का स्कैन लें'),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _onDiagnose,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('आयुर्वेदिक पहचान करें'),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_diagnosisResult.isNotEmpty)
              ..._diagnosisResult.map((result) => _buildResultCard(result)).toList(),
            
            const SizedBox(height: 24),
            const Text(
              'यह जानकारी केवल आयुर्वेदिक संदर्भ हेतु है — औषधि/डोज़ लेने से पहले योग्य आयुर्वेदाचार्य/डॉक्टर से परामर्श अवश्य करें।',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(DiagnosisResult result) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.condition.nameHindi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('दोष: ${result.condition.dominantDosha} | मिलान स्कोर: ${(result.score * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 12),
            const Text('प्रस्तावित औषधियाँ:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...result.condition.remedies.map((remedy) => Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- ${remedy.name} (${remedy.form})'),
                  Text(remedy.doseReference, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            )),
            if (!result.condition.doctorVerified)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'डोज़ देखने के लिए डॉक्टर सत्यापन आवश्यक',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
