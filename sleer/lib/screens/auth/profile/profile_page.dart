import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sleer/screens/components/avatar/cpn_avatar_holder.dart';
import 'package:sleer/screens/components/background_label.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CpnAvatarHolderState> avatarHolderKey =
        GlobalKey<CpnAvatarHolderState>();

    Future<void> _pickImage(BuildContext context, ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        debugPrint("success" + pickedFile.path);
        avatarHolderKey.currentState?.updateImage(pickedFile.path);
      } else {
        debugPrint("false");
        print('No image selected.');
      }
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Positioned(
                          child: CpnAvatarHolder(
                            key: avatarHolderKey,
                            onTap: () {
                              showMaterialModalBottomSheet(
                                expand: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text('Choose from Gallery'),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await _pickImage(
                                                context, ImageSource.gallery);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Take a Photo'),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await _pickImage(
                                                context, ImageSource.camera);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            size: 150,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.photo_camera_back_sharp,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BackgroundLabel(
                    opacity: 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Friends"),
                      ],
                    ),
                  ),
                  BackgroundLabel(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        showBarModalBottomSheet(
                          context: context,
                          // expand: true,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 2 / 3,
                                child: Column(
                                  children: [
                                    // Nội dung của bottom sheet
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Text("0/20 friends"),
                          Spacer(),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
