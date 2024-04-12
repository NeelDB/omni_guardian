import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blueAccent.withOpacity(0.1)
            ),
            child: Icon(icon, color: Colors.black)),
        title: Text(
            title,
            style: TextStyle(color: textColor ?? Colors.black)),
        trailing: endIcon? Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1)
            ),
            child: const Icon(
                Icons.keyboard_arrow_right_sharp, size: 18, color: Colors.grey
            )
        ) : null
    );
  }
}