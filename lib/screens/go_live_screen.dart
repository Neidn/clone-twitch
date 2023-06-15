import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '/utils/colors.dart';
import '/utils/utils.dart';

import '/resources/firestore_methods.dart';

import '/widgets/custom_button.dart';
import '/widgets/custom_text_field.dart';

import '/screens/broadcast_screen.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  late final TextEditingController _titleController;
  Uint8List? image;

  @override
  void initState() {
    _titleController = TextEditingController();
    image = null;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    image = null;
    super.dispose();
  }

  void goLiveStream(BuildContext context) {
    FirestoreMethods()
        .startLiveStream(
      context: context,
      title: _titleController.text.trim(),
      image: image,
    )
        .then((String channelId) {
      if (channelId.isEmpty) {
        return;
      }

      showSnackBar(context, 'Live stream started successfully!');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BroadcastScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Select Thumbnail
                GestureDetector(
                  onTap: () {
                    pickImage().then((Uint8List? pickedImage) {
                      if (pickedImage == null) {
                        return;
                      }
                      setState(() {
                        image = pickedImage;
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: image != null
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: buttonColor,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: buttonColor.withOpacity(.05),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                    color: buttonColor,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select Your Thumbnail',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                // Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomTextField(
                        controller: _titleController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Go Live Button
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButton(
                text: 'Go Live',
                onPressed: () => goLiveStream(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
