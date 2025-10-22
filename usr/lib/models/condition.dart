class Remedy {
  final String name;
  final String form;
  final String doseReference;

  Remedy({
    required this.name,
    required this.form,
    required this.doseReference,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      name: json['name'],
      form: json['form'],
      doseReference: json['dose_reference'],
    );
  }
}

class Condition {
  final String id;
  final String nameHindi;
  final String dominantDosha;
  final List<String> symptoms;
  final List<String> visualMarkers;
  final List<Remedy> remedies;
  final bool doctorVerified;

  Condition({
    required this.id,
    required this.nameHindi,
    required this.dominantDosha,
    required this.symptoms,
    required this.visualMarkers,
    required this.remedies,
    required this.doctorVerified,
  });
}

// This will be used for the diagnosis result
class DiagnosisResult {
  final Condition condition;
  final double score;
  final List<String> matchedSymptoms;

  DiagnosisResult({
    required this.condition,
    required this.score,
    required this.matchedSymptoms,
  });
}
