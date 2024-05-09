import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';
import 'package:omni_guardian/network/wifi.dart';
import 'package:omni_guardian/pages/login/registerEmail.dart';
import 'package:omni_guardian/pages/login/registerGoogle.dart';
import 'package:omni_guardian/services/auth_service.dart';


import '../../components/my_halft_textfield.dart';
import '../../data/User.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              //logo
              Image.asset(
                'assets/images/OmniGuardian.jpg',
                height: 100,
                width: 100,
              ),

              const SizedBox(height: 20),

              //not a member? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700])
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                        'Login Now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TabBar(
                        unselectedLabelColor: Colors.grey[600],
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Email'),
                          Tab(text: 'Google'),
                        ],
                      ),
                    ),
                    // Add more widgets or content here if needed
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    //'Email' tab
                    RegisterEmail(),
                    //'Google' tab
                    RegisterGoogle(),

                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
