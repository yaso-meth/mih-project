class ICD10Code {
  final String icd10;
  final String description;

  const ICD10Code({
    required this.icd10,
    required this.description,
  });

  factory ICD10Code.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "icd10": String icd10,
        'description': String description,
      } =>
        ICD10Code(
          icd10: icd10,
          description: description,
        ),
      _ => throw const FormatException('Failed to load icd10 code object.'),
    };
  }
}
