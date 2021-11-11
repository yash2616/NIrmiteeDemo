import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({Key? key, required this.icon, this.onPressed}) : super(key: key);

  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Color(0xFF4C4F5E),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white, size: 40,),
      elevation: 6,
      constraints: const BoxConstraints.tightFor(
        height: 56,
        width: 56,
      ),
      shape: const CircleBorder(),
    );
  }
}
