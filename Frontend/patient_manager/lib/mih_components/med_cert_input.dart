import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_date_input.dart';

class Medcertinput extends StatefulWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateTextController;
  final TextEditingController retDateTextController;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 325,
      child: Column(
        children: [
          //const SizedBox(height: 50.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.startDateController,
              lableText: "From",
              required: true,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.endDateTextController,
              lableText: "Up to Including",
              required: true,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: 700,
            child: MIHDateField(
              controller: widget.retDateTextController,
              lableText: "Return",
              required: true,
            ),
          ),
        ],
      ),
    );
  }
}
