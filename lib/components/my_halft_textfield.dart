import 'package:flutter/cupertino.dart';

/*class MyRow extends StatelessWidget {

  final Widget leftWidget;
  final Widget rightWidget;

  const MyRow({
    super.key,
    required this.leftWidget,
    required this.rightWidget
})

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Left Widget
        MyHalfTextfield(
            isLeft: true, inputField: leftWidget
        ),
        //Right Widget
        MyHalfTextfield(
            isLeft: false, inputField: rightWidget
        )
      ],
    );
  }
}*/


class MyHalfTextfield extends StatelessWidget {

  final bool isLeft; //If it is positioned on the left side isLeft = true
  final Widget inputField;

  const MyHalfTextfield({
    super.key,
    required this.isLeft,
    required this.inputField
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child:
      Padding(
        padding: isLeft?  const EdgeInsets.only(right: 5.0) : const EdgeInsets.only(left: 5.0),
        child: inputField
      )
    );
  }
}