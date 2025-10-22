import '../models/condition.dart';

final List<Condition> ayurConditions = [
  Condition(
    id: "ayur_cough_01",
    nameHindi: "कास - श्वास (कफ प्रधान)",
    dominantDosha: "कफ",
    symptoms: ["खांसी", "बलगम", "भारीपन छाती में"],
    visualMarkers: ["जीभ: सफेद मोटी परत", "चेहरा: ठंडा रंग"],
    remedies: [
      Remedy(name: "तुलसी-इमली काढ़ा", form: "काढ़ा", doseReference: "100ml सुबह-शाम (संदर्भ)"),
      Remedy(name: "मरिच चूर्ण", form: "चूर्ण", doseReference: "2 ग्राम शहद के साथ दिन में 2 बार")
    ],
    doctorVerified: false,
  ),
  Condition(
    id: "ayur_acidity_01",
    nameHindi: "अम्लपित्त (पित्त प्रधान)",
    dominantDosha: "पित्त",
    symptoms: ["सीने में जलन", "खट्टी डकार"],
    visualMarkers: ["जीभ: लाल तथा चिकनी परत", "चेहरा: लालपन"],
    remedies: [
      Remedy(name: "अविपत्तिकर चूर्ण", form: "चूर्ण", doseReference: "3 ग्राम भोजन के बाद (संदर्भ)"),
      Remedy(name: "कुल्थी का काढ़ा", form: "काढ़ा", doseReference: "50-100 ml रात को (संदर्भ)")
    ],
    doctorVerified: false,
  ),
];
