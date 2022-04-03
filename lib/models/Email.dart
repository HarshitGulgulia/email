import 'package:flutter/material.dart';

class Email {
  final String image, name, subject, body, time, from_email;
  final bool isAttachmentAvailable, isChecked;
  final Color tagColor;

  Email({
    this.time,
    this.isChecked,
    this.image,
    this.name,
    this.subject,
    this.body,
    this.isAttachmentAvailable,
    this.tagColor,
    this.from_email
  });

}