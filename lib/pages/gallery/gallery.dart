import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/pages/gallery/modal.dart';
import 'package:omni_guardian/rest/requests.dart';
import 'package:omni_guardian/storage/storage.dart';

import '../../data/alert.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<Data> images = [];
  String? selectedFilter = 'ALL';

  Future<void> getLastAlert() async {
    //Map<String, dynamic> alert = await Storage.getAlert();

    String? alertJson = await Requests.getDefaultAlert();
    Map<String, dynamic> alert = jsonDecode(alertJson!);

    Uint8List bytes = base64.decode(alert['imageBytes']);
    String caption = alert['timestamp'];
    Data img = Data(image: bytes, text: caption);
    setState(() {
      images.add(img);
    });
  }

  Future<void> listAlerts(String query) async {
    Map<String, dynamic> user = await Storage.getUser();
    String? alerts;
    setState(() {
      images.clear();
    });

    if(query == "ALL") {
      alerts = await Requests.getAlerts(user['email'], user['authorizationToken']);
    }
    else if(query == "POSITIVE") {
      alerts = await Requests.getPositiveAlerts(user['email'], user['authorizationToken']);
    }
    else if(query == "FALSE") {
      alerts = await Requests.getPositiveAlerts(user['email'], user['authorizationToken']);
    }
    else if(query == "LAST") {
      return await getLastAlert();
    }

    List<dynamic> alertList = jsonDecode(alerts!);
    for(dynamic alert in alertList) {
      Uint8List bytes = base64.decode(alert['imageBytes']);
      String caption = alert['timestamp'];
      debugPrint(caption);
      Data img = Data(image: bytes, text: caption);
      setState(() {
        images.add(img);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Gallery'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              hint: const Text('Select Filter'),
              decoration: const InputDecoration(
                labelText: 'See:',
                border: OutlineInputBorder(),
                filled: true,
              ),
              onChanged: (value) async {
                await listAlerts(value!);
              },
              items: ['ALL', 'POSITIVE', 'FALSE', 'LAST'].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
          ),

          images.isEmpty?
          const Expanded(
            child: Center(
              child: Text(
                'No images yet',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
              :
          const SizedBox(height: 15),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                // Calculate the width of each grid item based on the screen width
                double itemWidth = MediaQuery.of(context).size.width / 2; // Subtracting spacing

                return GestureDetector(
                  onTap: () {
                    // You can add onTap functionality here, like showing full-size image
                    // or navigating to another page.
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: itemWidth,
                        height: itemWidth * 0.75, // Aspect ratio of 4:3
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          image: DecorationImage(
                            image: MemoryImage(images[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          images[index].text,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}