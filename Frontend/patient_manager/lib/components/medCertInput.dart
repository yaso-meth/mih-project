import 'package:flutter/material.dart';
import 'package:patient_manager/components/inputsAndButtons/mihDateInput.dart';

class Medcertinput extends StatefulWidget {
  final startDateController;
  final endDateTextController;
  final retDateTextController;
  const Medcertinput({
    super.key,
    required this.startDateController,
    required this.endDateTextController,
    required this.retDateTextController,
  });

  @override
  State<Medcertinput> createState() => _MedcertinputState();
}

class _MedcertinputState extends State<Medcertinput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        children: [
          const SizedBox(height: 50.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.startDateController,
              LableText: "From",
              required: true,
            ),
          ),
          const SizedBox(height: 25.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.endDateTextController,
              LableText: "Up to Including",
              required: true,
            ),
          ),
          const SizedBox(height: 25.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.retDateTextController,
              LableText: "Return",
              required: true,
            ),
          ),
        ],
      ),
    );
  }
}
