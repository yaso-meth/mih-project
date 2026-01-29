import 'package:flutter/material.dart';

class MihForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> formFields;
  const MihForm({
    super.key,
    required this.formKey,
    required this.formFields,
  });

  @override
  State<MihForm> createState() => _MihFormState();
}

class _MihFormState extends State<MihForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.formFields,
      ),
    );
  }
}
