import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sleer/blocs/auth_bloc/auth_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/screens/components/avatar/cpn_avatar_holder.dart';
import 'package:sleer/screens/components/background_label.dart';
import 'package:sleer/services/util_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CpnAvatarHolderState> avatarHolderKey =
        GlobalKey<CpnAvatarHolderState>();

    final User auth =
        (context.read<AuthBloc>().state as AuthLoggedinState).auth;
    ////////////////////////////////
    Future<void> pickImage(ImageSource source) async {
      final pickedFile = await UtilService.pickImage(source: source);
      if (pickedFile != null) {
        avatarHolderKey.currentState?.updateImage(pickedFile.path);
      } else {
        debugPrint('No image selected.');
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
                                          leading:
                                              const Icon(Icons.photo_library),
                                          title:
                                              const Text('Choose from Gallery'),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await pickImage(
                                                ImageSource.gallery);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Take a Photo'),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await pickImage(ImageSource.camera);
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
                        const Positioned(
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
                    opacity: 1,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        showBarModalBottomSheet(
                          context: context,
                          // expand: true,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: SizedBox(
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
                          Text("${auth.friends.length}/20 friends"),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const BackgroundLabel(
                    opacity: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_person_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Friends"),
                      ],
                    ),
                  ),
                  BackgroundLabel(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(AuthLogoutEvent());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Logout"),
                          SizedBox(width: 20),
                          Icon(Icons.logout_outlined),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
