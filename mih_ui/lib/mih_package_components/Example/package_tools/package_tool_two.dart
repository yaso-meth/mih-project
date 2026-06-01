import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class PackageToolTwo extends StatefulWidget {
  const PackageToolTwo({super.key});

  @override
  State<PackageToolTwo> createState() => _PackageToolTwoState();
}

class _PackageToolTwoState extends State<PackageToolTwo> {
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      scrollbarOn: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "World",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MihColors.secondary(),
            ),
          ),
          const SizedBox(height: 10),
          RatingBar(
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            onRatingChanged: (value) => debugPrint('$value'),
            initialRating: 3,
            maxRating: 5,
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black,
            width: 200,
            height: 200,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: IconButton.filled(
              onPressed: () {},
              icon: Icon(
                MihIcons.mihLogo,
                color: MihColors.primary(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
