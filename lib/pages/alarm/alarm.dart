import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/components/validateCode.dart';
import '../../rest/requests.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final codeController = TextEditingController();
  bool panicIsOn = false;
  double _progress = 0.0;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_progress >= 1.0) {
        timer.cancel();
      } else {
        setState(() {
          _progress += 1 / 60;
        });
      }
    });
  }

  Future<void> cancelAlarm() async {
    _timer.cancel();
    setState(() {
      _progress = 0;
    });
    await Requests.cancelAlarm();
  }

  Future<void> activatePanic() async {
    if(panicIsOn) {
      setState(() {panicIsOn = false;});
    }
    else {
      setState(() {panicIsOn = true;});
    }
    await Requests.activatePanic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Alarm'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              const SizedBox(height: 80),

              //Turn Panic on
              ElevatedButton.icon(
                  onPressed: () {
                    panicIsOn? null :
                  CodeAlert.validateCode(context, codeController, activatePanic);
                    },
                  icon: const Icon(Icons.notification_important, size: 40),
                  label: panicIsOn? const Text('Panic is on!') : const Text('Panic Button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: panicIsOn? Colors.red.shade50 : Colors.red,
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

              const SizedBox(height: 40),

              if(_progress <= 1.0)
                //Cancel
                ElevatedButton.icon(
                    onPressed: () {
                      CodeAlert.validateCode(context, codeController, cancelAlarm);
                      },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel alarm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
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

              if(_progress == 0 || panicIsOn)
                const Text(
                  'Alarm is off',
                  style: TextStyle(fontSize: 24.0),
                )
              else if(_progress >= 1.0)
                const Text(
                  'Alarm is on',
                  style: TextStyle(fontSize: 24.0),
                )
              else
                const Text(
                  'Turning alarm on...',
                  style: TextStyle(fontSize: 24.0),
                ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}