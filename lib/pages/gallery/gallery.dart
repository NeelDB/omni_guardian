import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/pages/gallery/modal.dart';
import 'package:omni_guardian/rest/requests.dart';
import 'package:omni_guardian/storage/storage.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<Data> images = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    String? alertJson = await Requests.getDefaultAlert();
    Map<String, dynamic> alert = jsonDecode(alertJson!);
    Uint8List bytes = base64.decode(alert['imageBytes']);
    String caption = alert['timestamp'];
    Data img = Data(image: bytes, text: caption);
    images.add(img);
    images.add(img);
    images.add(img);
    images.add(img);
    images.add(img);
    images.add(img);
    images.add(img);
    images.add(img);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Gallery'),
      body: images.isEmpty? const Center(
        child: Text(
          'No images yet',
          style: TextStyle(fontSize: 18.0),
        ),
      ) : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // You can add onTap functionality here, like showing full-size image
                    // or navigating to another page.
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: double.infinity,
                          height: 165,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            image: DecorationImage(
                              image: MemoryImage(images[index].image),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(images[index].text)
                    ],
                  )
                );
              },

        ),
    );
  }
}