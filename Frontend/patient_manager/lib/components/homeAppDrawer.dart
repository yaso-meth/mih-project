import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class HomeAppDrawer extends StatefulWidget {
  final String userEmail;

  const HomeAppDrawer({super.key, required this.userEmail});

  @override
  State<HomeAppDrawer> createState() => _HomeAppDrawerState();
}

class _HomeAppDrawerState extends State<HomeAppDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(MzanziInnovationHub.of(context)?.theme.mode);
    return Drawer(
      //backgroundColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      child: Stack(children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
              child: Text(
                widget.userEmail,
                style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor()),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  SizedBox(width: 25.0),
                  Text(
                    "Sign Out",
                    style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor()),
                  ),
                ],
              ),
              onTap: () {
                client.auth.signOut();
                Navigator.of(context).pushNamed('/');
              },
            )
          ],
        ),
        Positioned(
          top: 1,
          right: 1,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              setState(() {
                if (MzanziInnovationHub.of(context)?.theme.mode == "Dark") {
                  //darkm = !darkm;
                  MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.light);
                  //print("Dark Mode: $darkm");
                } else {
                  //darkm = !darkm;
                  MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.dark);
                  //print("Dark Mode: $darkm");
                }
                Navigator.of(context).pushNamed('/home');
              });
            },
            icon: Icon(
              Icons.light_mode,
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              size: 35,
            ),
          ),
        ),
      ]),
    );
  }
}
