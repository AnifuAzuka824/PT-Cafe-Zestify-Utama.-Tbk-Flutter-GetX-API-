import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class ZestifyLogo extends StatelessWidget {
  final double fontSize;

  const ZestifyLogo({super.key, this.fontSize = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              ZestifyColors.goldGradient.createShader(bounds),
          child: Text(
            'ZESTIFY',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          ' CAFÉ',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
