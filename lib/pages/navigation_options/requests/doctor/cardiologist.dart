class Cardiologist {
  const Cardiologist({
    required this.imgPath,
    required this.name,
    required this.education,
    required this.specialization,
    required this.experience,
    required this.categID,
    required this.docID,
  });
  final String imgPath, name, education, specialization;
  final int experience, docID, categID;
}
