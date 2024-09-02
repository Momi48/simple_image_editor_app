import 'package:flutter/material.dart';
import 'package:image_editor/models/text_info_model.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;
  const ImageText({super.key, required this.textInfo});

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
     textAlign: textInfo.textAlign,
      style: TextStyle(
        color: textInfo.color,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        fontSize: textInfo.fontSize,
        
      ),
    );
  }
}
