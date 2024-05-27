import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/services/auth_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:omni_guardian/storage/storage.dart';
import '../../components/validateCode.dart';
import '../../rest/requests.dart';

final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final codeController = TextEditingController();
  bool isOn = true;
  List<String> cameras = ['Camera 1'];
  final PageController _pageController = PageController();
  Uint8List? bytes;
  String? domainName;
  bool isAdmin = false;

  Future<void> _takePicture() async {
    String? alertJson = await Requests.addAlert();
    //String? alertJson = await Requests.getDefaultAlert();
    Map<String, dynamic> alert = jsonDecode(alertJson!);
    setState(() {
      bytes = base64.decode(alert['imageBytes']);
    });
    await Storage.updateAlertStorage(alertJson);
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    Map<String, dynamic> user = await Storage.getUser();
    setState(() {
      domainName = user['domain'];
      isAdmin = user['admin'];
    });
  }

  void _addCamera() {
    if(cameras.length < 5) {
      setState(() {
        int index = cameras.length;
        cameras.add('Camera ${cameras.length + 1}');
        _pageController.animateToPage(
            index,
            duration: const Duration(microseconds: 400),
            curve: Curves.bounceInOut
        );
      });
    }
  }

  void _removeCamera(int index) {
    if (index > 0 && index < cameras.length) {
      setState(() {
        cameras.removeAt(index);
        _pageController.jumpToPage(index - 1);
      });
    }
  }

  void changeMode() {
    if(isOn) {
      setState(() {isOn = false;});
    }
    else {setState(() {isOn = true;});
    }
    Requests.changeMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Home'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: [
                const SizedBox(height: 20),

                  Text(
                    isAdmin ? "Admin - $domainName" :
                    "Guest - $domainName",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),

                const SizedBox(height: 20),

                //Turn System on/off
                ElevatedButton.icon(
                    onPressed: () {
                      CodeAlert.validateCode(context, codeController, changeMode);
                    },
                    icon: isOn? const Icon(Icons.notifications_paused, size: 40) :
                      const Icon(Icons.notifications_active),
                    label: isOn? const Text('Turn to passive') : const Text('Turn to active'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOn? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(300, 80),
                      shape: const RoundedRectangleBorder(),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),

                const SizedBox(height: 30),

                if(isAdmin)
                //Add camera
                  ElevatedButton.icon(
                      onPressed: cameras.length >= 5 || !isAdmin ? null : _addCamera,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Camera'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 40),
                        //side: const BorderSide(color: Colors.black, width: 2),
                        shape: const RoundedRectangleBorder(),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),

                Container(
                  height: 200,
                  width: 300,
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  child: Stack(
                    children: [
                      PageView.builder(
                          controller: _pageController,
                          itemCount: cameras.length,
                          itemBuilder: (container, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cameras[index],
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),

                                  if (index > 0) // Remove button for camera 2, 3, 4, and 5
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () => _removeCamera(index),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: const Text('Remove Camera'),
                                          ),
                                        ),

                                        ElevatedButton(
                                          onPressed: () {
                                            // Implement take picture functionality
                                          },
                                          child: const Text('Take Picture'),
                                        ),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _takePicture();
                                      },
                                      child: const Text('Take Picture'),
                                    ),
                                ],
                              ),
                            );
                          }
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: cameras.length,
                            effect: const WormEffect(),
                            onDotClicked: (index) {
                              _pageController.animateToPage(
                                  index,
                                  duration: const Duration(microseconds: 400),
                                  curve: Curves.easeOut
                              );
                            },

                          ),
                        ),
                      )
                    ],
                  ),
                ),

                if (bytes != null) ...[
                  const SizedBox(height: 25),
                  Image.memory(bytes!),
                  const SizedBox(height: 12),
                ],
          ]),
        ),
      )
    );
  }
}