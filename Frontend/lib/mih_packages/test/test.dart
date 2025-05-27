import 'package:flutter/material.dart';

import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';

class MIHTest extends StatefulWidget {
  const MIHTest({super.key});

  @override
  State<MIHTest> createState() => _MIHTestState();
}

class _MIHTestState extends State<MIHTest> {
  // late YoutubePlayerController videoController;
  // String videoLink = "https://www.youtube.com/watch?v=P2bM9eosJ_A";
  // @override
  // void initState() {
  //   videoController = YoutubePlayerController(
  //     initialVideoId: "P2bM9eosJ_A",
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: MIHAction(
        icon: const Icon(Icons.arrow_back),
        iconSize: 35,
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            arguments: true,
            (route) => false,
          );
        },
      ),
      header: const MIHHeader(
        headerAlignment: MainAxisAlignment.center,
        headerItems: [
          Text(
            "Test",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
      secondaryActionButton: null,
      body: const MIHBody(
        borderOn: false,
        bodyItems: [
          // YoutubePlayer(
          //   controller: videoController,
          // ),
        ],
      ),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
