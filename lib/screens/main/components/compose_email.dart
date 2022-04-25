import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../constants.dart';
import '../../../services/send_mail.dart';

class Compose extends StatefulWidget {
  const Compose({Key key}) : super(key: key);

  @override
  _ComposeState createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  List<String> attachments = [];
  bool isHTML = false;

  final _recipientController = TextEditingController(
    text: '',
  );

  final _subjectController = TextEditingController(text: '');

  final _bodyController = TextEditingController(
    text: 'Enter Body',
  );

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await sendMail(email.recipients[0], email.subject, email.body,
          email.attachmentPaths); //send code
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Compose',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kBgLightColor, // kBgLightColor
        elevation: 0.0,
        bottom: PreferredSize(
            child: Container(
              color: kPrimaryColor,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.attach_file),
            onPressed: _openImagePicker,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              color: Colors.black,
              onPressed: send,
              icon: const Icon(Icons.send),
            ),
          )
        ],
      ),
      body: Container(
        color: kBgLightColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recipient',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                        labelText: 'Body', border: OutlineInputBorder()),
                  ),
                ),
              ),
              CheckboxListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                title: const Text('HTML'),
                onChanged: (bool value) {
                  if (value != null) {
                    setState(() {
                      isHTML = value;
                    });
                  }
                },
                value: isHTML,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    for (var i = 0; i < attachments.length; i++)
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              attachments[i],
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () => {_removeAttachment(i)},
                          )
                        ],
                      ),
                    TextButton(
                      child: const Text(
                        'Attach file in app documents directory',
                        style: TextStyle(color: kTitleTextColor),
                      ),
                      onPressed: () => _attachFileFromAppDocumentsDirectoy(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImagePicker() async {
    final picker = ImagePicker();
    PickedFile pick = await picker.getImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  Future<void> _attachFileFromAppDocumentsDirectoy() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final filePath = appDocumentDir.path + '/file.txt';
      final file = File(filePath);
      await file.writeAsString('Text file in app directory');

      setState(() {
        attachments.add(filePath);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to create file in application directory',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      );
    }
  }
}
