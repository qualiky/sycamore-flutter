import 'package:com_sandeepgtm_sycamore_mobile/views/login_screen.dart';
import 'package:com_sandeepgtm_sycamore_mobile/views/signup_screen.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {

  late SquareButtonElements elements;

  SquareButton({super.key, required this.elements});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => elements.route
              )
          ),
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: elements.backgroundColor,
            maximumSize: Size(80, 80),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                elements.icon,
                color: elements.iconColor,
                semanticLabel: elements.label,
              ),
              const SizedBox(height: 5,),
              Text(elements.label)
            ],
          ),
        )
    );;
  }
}

class SquareButtonElements {

  late Color backgroundColor;
  late Color iconColor;
  late IconData icon;
  late String label;
  late Widget route;

  SquareButtonElements({required this.backgroundColor, required this.iconColor, required this.icon, required this.label, required this.route});
}
