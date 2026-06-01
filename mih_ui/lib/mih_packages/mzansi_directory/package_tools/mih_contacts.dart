import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihContacts extends StatefulWidget {
  const MihContacts({super.key});

  @override
  State<MihContacts> createState() => _MihContactsState();
}

class _MihContactsState extends State<MihContacts> {
  final TextEditingController contactSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      scrollbarOn: true,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: MihSearchBar(
              controller: contactSearchController,
              hintText: "Search Contacts",
              prefixIcon: Icons.search,
              fillColor: MihColors.secondary(),
              hintColor: MihColors.primary(),
              onPrefixIconTap: () {},
              searchFocusNode: searchFocusNode,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
