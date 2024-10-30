import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

// ignore: must_be_immutable
class MIHProfilePicture extends StatefulWidget {
  final ImageProvider<Object>? profilePictureFile;
  final TextEditingController proPicController;

  PlatformFile? proPic;
  final double width;
  final double radius;
  final bool editable;
  final onChange;
  MIHProfilePicture({
    super.key,
    required this.profilePictureFile,
    required this.proPicController,
    required this.proPic,
    required this.width,
    required this.radius,
    required this.editable,
    required this.onChange,
  });

  @override
  State<MIHProfilePicture> createState() => _MIHProfilePictureState();
}

class _MIHProfilePictureState extends State<MIHProfilePicture> {
  late ImageProvider<Object>? propicPreview;
  //late PlatformFile proPic;

  Widget displayEditableProPic() {
    ImageProvider logoFrame =
        MzanziInnovationHub.of(context)!.theme.altLogoFrame();
    if (widget.profilePictureFile != null) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          CircleAvatar(
            backgroundColor:
                MzanziInnovationHub.of(context)!.theme.primaryColor(),
            backgroundImage: propicPreview,
            //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
            radius: widget.radius,
          ),
          SizedBox(
            width: widget.width,
            child: Image(image: logoFrame),
          ),
          Visibility(
            visible: widget.editable,
            child: Positioned(
              bottom: 0,
              right: 0,
              child: IconButton.filled(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result == null) return;
                  final selectedFile = result.files.first;
                  setState(() {
                    widget.onChange(selectedFile);
                    widget.proPic = selectedFile;
                    //print("MIH Profile Picture: ${widget.proPic}");
                    propicPreview = MemoryImage(widget.proPic!.bytes!);
                  });

                  setState(() {
                    widget.proPicController.text = selectedFile.name;
                  });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: widget.width,
        child: Image(image: logoFrame),
      );
    }
  }

  @override
  void initState() {
    setState(() {
      propicPreview = widget.profilePictureFile;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return displayEditableProPic();
  }
}
