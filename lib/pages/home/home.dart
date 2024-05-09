import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/services/auth_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final codeController = TextEditingController();
  bool isOn = false;
  List<String> cameras = ['Camera 1'];
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Home'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: [
                const Text(
                    'Domain Name',
                    style: TextStyle(
                      fontSize: 40,
                      fontStyle: FontStyle.italic
                    ),
                  ),

                const SizedBox(height: 30),

                //Turn System on/off
                ElevatedButton.icon(
                    onPressed: () {_showCodeInputDialog(context);},
                    icon: isOn? const Icon(Icons.cancel) : const Icon(Icons.power_settings_new, size: 40),
                    label: isOn? const Text('Turn off') : const Text('Turn on'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOn? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(300, 80),
                      //side: const BorderSide(color: Colors.black, width: 2),
                      shape: const RoundedRectangleBorder(),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),

                const SizedBox(height: 30),

                //Add camera
                ElevatedButton.icon(
                  onPressed: cameras.length >= 5 ? null : _addCamera,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
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
                    color: Colors.greenAccent
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
                                      onPressed: () {
                                        // Implement take picture functionality
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
                )
              ],
          ),
        ),
      )
    );
  }

  bool _codeIsCorrect() {
    return codeController.text == '1234';
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
  void _showCodeInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Code'),
          content: MyNumberField(
            labelText: 'Code',
            controller: codeController,
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if(_codeIsCorrect()) {
                  if(isOn) {
                    setState(() {isOn = false;});
                  }
                  else {setState(() {isOn = true;});
                  }
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect code. Please try again.'),
                  ));
                }
                codeController.text = '';
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}