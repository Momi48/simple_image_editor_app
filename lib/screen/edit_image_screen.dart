import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/widgets/edit_image_view_model.dart';
import 'package:image_editor/widgets/image_to_text.dart';

class EditImageScreen extends StatefulWidget {
  final String selectedImage;
  const EditImageScreen({super.key, required this.selectedImage});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  bool toggle = false;
  FontWeight defualt = FontWeight.normal;
  FontWeight boldValue = FontWeight.bold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: RepaintBoundary(
              key: repaintKey,
              child: Stack(
                children: [
                  addedImage,
                  for (int i = 0; i < text.length; i++)
                    Positioned(
                      left: text[i].left,
                      top: text[i].top,
                      child: GestureDetector(
                        onLongPress: () {
                          removeText();
                        },
                        onTap: () {
                          currentText(context, i);
                        },
                        child: Draggable(
                          feedback: Material(
                              type: MaterialType.transparency,
                              child: ImageText(textInfo: text[i])),
                          onDragEnd: (drag) {
                            final renderBox =
                                context.findRenderObject() as RenderBox;
                            Offset offset =
                                renderBox.globalToLocal(drag.offset);
                            setState(() {});
                            text[i].top = offset.dy - 78;
                            text[i].left = offset.dx;
                          },
                          child: ImageText(textInfo: text[i]),
                        ),
                      ),
                    ),
                  // creatorText.text.isNotEmpty
                  //     ? Positioned(
                  //         left: 0,
                  //         top: 0,
                  //         child: Text(
                  //           creatorText.text,
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 20,
                  //               color: Colors.black.withOpacity(0.3)),
                  //         ),
                  //       )
                  //     : const SizedBox.shrink()
                ],
              ),
            )),
      ),
      floatingActionButton: addNewFab,
    );
  }

  AppBar get _appBar => AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              IconButton(
                onPressed: () {
                  caputreImage();
                },
                icon: const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                tooltip: 'Save Image',
              ),
              IconButton(
                onPressed: () => increaseFontSize(),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                tooltip: 'Increase font size',
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                onPressed: () => decreaseFontSize(),
                tooltip: 'Decrease font size',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_left,
                  color: Colors.black,
                ),
                onPressed: () => aligTextToLeft(),
                tooltip: 'Align left',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_center,
                  color: Colors.black,
                ),
                onPressed: () => aligTextToCenter(),
                tooltip: 'Align Center',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_right,
                  color: Colors.black,
                ),
                onPressed: () => aligTextToRight(),
                tooltip: 'Align Right',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_bold,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    toggle = !toggle;
                    if (toggle) {
                      changeToBold(boldValue);
                    } else {
                      changeToBold(defualt);
                    }
                  });
                },
                tooltip: 'Bold',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_italic,
                  color: Colors.black,
                ),
                onPressed: () => italicText(),
                tooltip: 'Italic',
              ),
              IconButton(
                icon: const Icon(
                  Icons.space_bar,
                  color: Colors.black,
                ),
                onPressed: () => addNewLineToText(),
                tooltip: 'Add New Line',
              ),
              //displaying colors

              IconButton(
                  onPressed: () => showColorDialogScreen(),
                  icon: const Icon(Icons.color_lens))
              // Tooltip(
              //   message: 'White Color',
              //   child: GestureDetector(
              //     onTap: () => changeColor(Colors.white),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.white,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Tooltip(
              //   message: 'Black Color',
              //   child: GestureDetector(
              //     onTap: () => changeColor(Colors.black),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.black,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Tooltip(
              //   message: 'Red Color',
              //   child: GestureDetector(
              //     onTap: () => changeColor(Colors.red),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.red,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Tooltip(
              //   message: 'Green Color',
              //   child: GestureDetector(
              //     onTap: () => changeColor(Colors.green),
              //     child: const CircleAvatar(
              //       backgroundColor: Colors.green,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
            ],
          ),
        ),
      );
  Widget get addNewFab => FloatingActionButton(
        onPressed: () {
          addNewDialog(context);
        },
        tooltip: 'Add New Text',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );
  Widget get addedImage => Image.file(
        File(
          widget.selectedImage,
        ),
        fit: BoxFit.cover,
        width: double.infinity,
      );
}
