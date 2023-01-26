import 'dart:io';
import 'package:charusatsocial/DashBoardScreen/Events/EventsScreen.dart';
import 'package:charusatsocial/DashBoardScreen/FeedScreen/FeedScreen.dart';
import 'package:charusatsocial/DashBoardScreen/ProfileScreen/ProfileScreen.dart';
import 'package:charusatsocial/DashBoardScreen/RewardScreen/RewardScreen.dart';
import 'package:charusatsocial/DashBoardScreen/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const kdialogtext = TextStyle(color: Colors.black, fontFamily: 'reggae', fontSize: 17, fontWeight: FontWeight.w500);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  Widget currentscreen = const FeedScreen();

  final PageStorageBucket bucket = PageStorageBucket();

  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late File file;
  bool isUploading = false;
  final DateTime timestamp = DateTime.now();

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      this.file = file as File;
    });
  }


  selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Center(
              child: Text(
                "Create Post",
                style: kdialogtext,
              )),
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            SimpleDialogOption(
                onPressed: handleTakePhoto,
                child: const Text(
                  "Photo with Camera",
                  style: kdialogtext,
                )),
            SimpleDialogOption(
                onPressed: handleChooseFromGallery,
                child: const Text(
                  "Image from Gallery",
                  style: kdialogtext,
                )),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: kdialogtext,
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Center(
          child: Text(
            "CharusatSocial",
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
      ),
      body: Stack(
        children: [
          PageStorage(bucket: bucket, child: currentscreen),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.black,
              width: size.width,
              height: 60,
              child: Stack(
                clipBehavior: Clip.none, children: [
                Container(
                  width: size.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          size: 30,
                          color: _currentIndex == 0 ? Colors.red : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setState(() {
                            currentscreen = const FeedScreen();
                            _currentIndex = 0;
                          });
                        },
                        splashColor: Colors.white,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.event_note_outlined,
                            size: 30,
                            color: _currentIndex == 1 ? Colors.red : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              currentscreen = const EventsScreen();
                              _currentIndex = 1;
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: _currentIndex == 2 ? Colors.red : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              currentscreen = const RewardScreen();
                              _currentIndex = 2;
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.person,
                            size: 30,
                            color: _currentIndex == 3 ? Colors.red : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              currentscreen = const ProfileScreen();
                              _currentIndex = 3;
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.settings,
                            size: 30,
                            color: _currentIndex == 4 ? Colors.red : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              currentscreen = const Settings();
                              _currentIndex = 4;
                            });
                          }),
                    ],
                  ),
                ),
              ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

