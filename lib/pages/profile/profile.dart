import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/pages/home/home.dart';
import 'package:omni_guardian/services/auth_service.dart';
import 'package:omni_guardian/storage/storage.dart';
import 'components/profile_menu_widgets.dart';

class Profile extends StatelessWidget {

  // sign user out method
  Future<void> signUserOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar('Profile'),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120, height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                      const Image(image: AssetImage('assets/images/defaultPicture.jpg'),
                      )
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.blue
                        ),
                        child: const Icon(
                            Icons.edit, size: 20, color: Colors.black
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),

              Text(AuthService(context).getUserEmail() ?? 'Teste'),
              
              const SizedBox(height: 15),
              
              SizedBox(
                width: 200,
                child: ElevatedButton(onPressed: (){}, child: const Text('Edit Profile'))
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // MENU
              ProfileMenuWidget(
                title: 'Settings',
                icon: Icons.settings,
                onPress: (){}
              ),

              ProfileMenuWidget(
                  title: 'Notifications',
                  icon: Icons.email,
                  onPress: (){}
              ),

              ProfileMenuWidget(
                  title: 'New Domain',
                  icon: Icons.domain_add,
                  onPress: (){}
              ),

              ProfileMenuWidget(
                  title: 'Logout',
                  icon: Icons.logout,
                  endIcon: false,
                  onPress: signUserOut,
                  textColor: Colors.red,
              )

            ],
          ),
        ),
      )
    );
  }
}