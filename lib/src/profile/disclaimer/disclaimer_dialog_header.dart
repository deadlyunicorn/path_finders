import 'package:flutter/material.dart';

class DisclaimerDialogHeader extends StatelessWidget {
  const DisclaimerDialogHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon( 
          shadows: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
            )
          ],
          Icons.warning, 
          color: Colors.yellow,
        ),
        const SizedBox.square( dimension: 12 ),
        Text( "Disclaimer", 
          style: Theme.of(context).textTheme.headlineSmall,
          ),
        const SizedBox.square( dimension: 12 ),
        const Icon( 
          shadows: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                )
              ],
          Icons.warning, 
          color: Colors.yellow
        ),
      ],
    );
  }
}
