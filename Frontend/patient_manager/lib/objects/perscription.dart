class Perscription {
  final String name;
  final String unit;
  final String form;
  final String fullForm;
  final String quantity;
  final String dosage;
  final String times;
  final String days;
  final String repeats;

  const Perscription({
    required this.name,
    required this.unit,
    required this.form,
    required this.fullForm,
    required this.quantity,
    required this.dosage,
    required this.times,
    required this.days,
    required this.repeats,
  });

  factory Perscription.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "name": String name,
        'unit': String unit,
        'form': String form,
        'fullForm': String fullForm,
        'quantity': String quantity,
        'dosage': String dosage,
        'times': String times,
        'days': String days,
        'repeats': String repeats,
      } =>
        Perscription(
          name: name,
          unit: unit,
          form: form,
          fullForm: fullForm,
          quantity: quantity,
          dosage: dosage,
          times: times,
          days: days,
          repeats: repeats,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      'unit': unit,
      'form': form,
      'fullForm': fullForm,
      'quantity': quantity,
      'dosage': dosage,
      'times': times,
      'days': days,
      'repeats': repeats,
    };
  }
}
