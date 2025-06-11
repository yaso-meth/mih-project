class Medicine {
  final String name;
  final String unit;
  final String form;

  const Medicine(
    this.name,
    this.unit,
    this.form,
  );

  factory Medicine.fromJson(dynamic json) {
    return Medicine(
      json['name'],
      json['unit'],
      json['dosage form'],
    );
  }
}
