import 'package:flutter/material.dart';

class PatientDetailItem extends StatefulWidget {
  final String category;
  final String value;
  const PatientDetailItem({
    super.key,
    required this.category,
    required this.value,
  });

  @override
  State<PatientDetailItem> createState() => _PatientDetailItemState();
}

class _PatientDetailItemState extends State<PatientDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Text(
            "${widget.category}:",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                //width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
