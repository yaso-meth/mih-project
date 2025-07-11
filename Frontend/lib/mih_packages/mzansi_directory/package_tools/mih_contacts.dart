import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';

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
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: MihSearchBar(
              controller: contactSearchController,
              hintText: "Search Contacts",
              prefixIcon: Icons.search,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              hintColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
