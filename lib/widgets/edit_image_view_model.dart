import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_editor/models/text_info_model.dart';
import 'package:image_editor/permission/permission_class.dart';
import 'package:image_editor/widgets/default_buttons.dart';
import 'package:image_editor/screen/edit_image_screen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  List<TextInfo> text = [];
  final repaintKey = GlobalKey();

  Color pickedColor = Colors.black;
  int currentIndex = 0;
  void addNewText() {
    setState(() {
      text.add(TextInfo(
          text: textEditingController.text,
          fontWeight: FontWeight.normal,
          left: 0,
          textAlign: TextAlign.left,
          fontStyle: FontStyle.normal,
          top: 0,
          color: Colors.black,
          fontSize: 20));
      debugPrint('Print is $text');
    });
  }

  currentText(context, index) {
    try {
      setState(() {
        currentIndex = index;
        debugPrint('Current index $currentIndex');
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Selected For Styling'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showColorDialogScreen() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickedColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => text[currentIndex].color = pickedColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  changeColor(Color color) {
    try {
      setState(() {
        text[currentIndex].color = color;
        pickedColor = text[currentIndex].color;

        debugPrint('Text Selected is ${text[currentIndex]}');
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void increaseFontSize() {
    setState(() {
      text[currentIndex].fontSize += 2.0;
    });
  }

  void changeToBold(FontWeight boldValue) {
    text[currentIndex].fontWeight = boldValue;
  }

  void decreaseFontSize() {
    setState(() {
      if (text[currentIndex].fontSize >= 16) {
        text[currentIndex].fontSize -= 2;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cannot Decrease Size Now limit is 16 fontSize '),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void italicText() {
    setState(() {
      if (text[currentIndex].fontStyle == FontStyle.italic) {
        text[currentIndex].fontStyle = FontStyle.normal;
      } else {
        text[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  void removeText() {
    setState(() {
      text.removeAt(currentIndex);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text Deleted'),
        backgroundColor: Colors.red,
      ));
    });
  }

  void caputreImage() async {
    await requestPermission();
    // convert the render object to repaint boundary
    final boundry =
        repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //convert it to  image
    final image = await boundry.toImage();
    //convert image to png format
    final bytedata = await image.toByteData(format: ImageByteFormat.png);
    //convert the image to bytes raw form
    if (bytedata != null) {
      final Uint8List pngbtes = bytedata.buffer.asUint8List();
      final gallery = await ImageGallerySaver.saveImage(pngbtes);
      debugPrint('ImageData $gallery');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image Saved To Gallery'),backgroundColor: Colors.green,));
    }
  }

  void addNewLineToText() {
    setState(() {
      if (text[currentIndex].text.contains('\n')) {
        text[currentIndex].text = text[currentIndex].text.replaceAll('\n', ' ');
      } else {
        text[currentIndex].text = text[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  void aligTextToLeft() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.left;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text Align At Left'),
        backgroundColor: Colors.red,
      ));
    });
  }

  void aligTextToRight() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.right;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text Align At Right'),
        backgroundColor: Colors.red,
      ));
    });
  }

  void aligTextToCenter() {
    setState(() {
      text[currentIndex].textAlign = TextAlign.center;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Text Align At Center'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  final textEditingController = TextEditingController();
  // final creatorText = TextEditingController();

  addNewDialog(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              DefaultButtons(
                onPressed: () {
                  addNewText();
                  Navigator.pop(context);
                },
                colors: Colors.blue,
                textColor: Colors.white,
                child: const Text('Add'),
              ),
              DefaultButtons(
                onPressed: () {
                  Navigator.pop(context);
                },
                colors: Colors.red,
                textColor: Colors.white,
                child: const Text('Cancel'),
              ),
            ],
            content: TextFormField(
              controller: textEditingController,
              maxLines: 4,
              decoration: const InputDecoration(
                filled: true,
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            backgroundColor: Colors.white,
          );
        });
  }
}
