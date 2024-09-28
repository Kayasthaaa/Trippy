// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/get_profile/cubit/get_profile_cubit.dart';
import 'package:trippy/src/feature/screen/get_profile/cubit/get_profile_state.dart';
import 'package:trippy/src/feature/screen/get_trips/cubit/get_trips_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_cubit.dart';
import 'package:trippy/src/feature/screen/login_screen/page/login_form.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';
import 'package:trippy/src/feature/widgets/no_menu_bar.dart';
import 'package:trippy/src/feature/widgets/update_profile_filed.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  bool isBio = true;
  bool isAddress = true;
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _requestPermission();
  }

  void _fetchData() {
    final profilecubit = context.read<GetProfileCubit>();
    if (profilecubit.state.userList == null) {
      profilecubit.fetchUserList();
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      await [
        Permission.camera,
        Permission.photos,
      ].request();
    } else {
      await Permission.storage.request();
    }
  }

  void _showPermissionDeniedDialog(ImageSource source) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(source == ImageSource.camera
              ? 'Camera Permission Denied'
              : 'Gallery Permission Denied'),
          content: const Text(
              'Please grant permission to access the selected source.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog(source);
      } else {
        rethrow;
      }
    }
  }

  bool validateEmptyBio(String? value) {
    if (value?.isEmpty ?? true) {
      return false;
    }
    return true;
  }

  bool validateEmptyAddress(String? value) {
    if (value?.isEmpty ?? true) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: const kBar(),
      body: BlocBuilder<GetProfileCubit, GetProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: AppLoading());
          } else if (state.error != null) {
            return Center(child: Texts(texts: state.error!));
          } else if (state.userList != null) {
            final user =
                state.userList!.data.first; // Assuming you want the first user
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: maxWidth(context),
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showImagePickerBottomSheet();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: _image != null
                                    ? FileImage(_image!)
                                    : user.address != null
                                        ? const AssetImage('images/pink.jpg')
                                        : const AssetImage('images/pink.jpg')
                                            as ImageProvider,
                              ),
                            ),
                            Positioned(
                              bottom: -5,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePickerBottomSheet();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Texts(
                          texts: user.name,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        UpdateFileds(
                          // validator: validateEmptyBio,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          texts: 'Username',
                          hintText: user.username,
                          prefixIcon: const Icon(Icons.person),
                          readOnly: isBio,
                          controller: bioController,
                        ),
                        UpdateFileds(
                          // validator: validateEmptyBio,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          texts: 'Phone number',
                          hintText: user.contact,
                          prefixIcon: const Icon(Icons.call),
                          readOnly: isBio,
                          controller: bioController,
                        ),
                        UpdateFileds(
                          // validator: validateEmptyBio,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          texts: 'Email',
                          hintText: user.email,
                          prefixIcon: const Icon(Icons.mail),
                          readOnly: isBio,
                          controller: bioController,
                        ),
                        UpdateFileds(
                          // validator: validateEmptyAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          texts: 'Address',
                          hintText: user.address ?? 'Your Address Here',
                          prefixIcon: const Icon(Icons.location_on),
                          readOnly: isAddress,
                          controller: addressController,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isAddress = !isAddress;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        UpdateFileds(
                          // validator: validateEmptyBio,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          texts: 'Bio',
                          hintText: user.bio ?? 'Your Bio Here',
                          prefixIcon: const Icon(Icons.description),
                          readOnly: isBio,
                          controller: bioController,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isBio = !isBio;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Containers(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6)),
                          width: maxWidth(context),
                          height: 50,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('user_token');
                            await prefs.remove('user_id');

                            final profileCubit =
                                context.read<GetProfileCubit>();
                            profileCubit.emit(GetProfileState.initial());
                            await context.read<UserCubit>().logout();
                            context.read<TripCubit>().resetState();
                            Get.offAll(() => const LoginScreenPage());
                          },
                          child: const Center(
                              child: Texts(
                            texts: 'logout',
                            color: Colors.white,
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            );
          } else {
            return const Center(child: Texts(texts: 'No data available'));
          }
        },
      ),
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final cameraPermission = await Permission.camera.request();
                  if (cameraPermission.isGranted) {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  } else {
                    _showPermissionDeniedDialog(ImageSource.camera);
                  }
                },
                child: Container(
                  height: 80,
                  width: 75,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Texts(
                        texts: 'Camera',
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () async {
                  final galleryPermission = await Permission.photos.request();
                  if (galleryPermission.isGranted) {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  } else {
                    _showPermissionDeniedDialog(ImageSource.gallery);
                  }
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Texts(
                        texts: 'Gallery',
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
