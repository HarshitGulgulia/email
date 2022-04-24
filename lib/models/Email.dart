import 'package:email_client/Database/database_emails_helper.dart';
import 'package:enough_mail/mime_message.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

///Email data received is stored in this class
class Email {
  final String image, name, subject, body, time, from_email, html;
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
    this.from_email,
    this.html
  });

  Map<String, dynamic> toJson() =>
      {
        DatabaseEmailsHelper.columnName : name,
        DatabaseEmailsHelper.columnIsChecked: isChecked,
        DatabaseEmailsHelper.columnTime: time,
        DatabaseEmailsHelper.columnImage: image,
        DatabaseEmailsHelper.columnSubject: subject,
        DatabaseEmailsHelper.columnBody: body,
        DatabaseEmailsHelper.columnIsAttachmentAvailable: isAttachmentAvailable,
        DatabaseEmailsHelper.columnTagColor: tagColor.toString(),
        DatabaseEmailsHelper.columnFromEmail: from_email,
        DatabaseEmailsHelper.columnHtml: html,
      };

}


class ListGenerator{

  static List<Email> mimemessageToEmailList(List<MimeMessage> mail_message) => List.generate(
    mail_message.length,
        (index) => Email(
      name: mail_message[index].from.toString()[1] == '"'
          ? mail_message[index].from.toString().substring(
          2, mail_message[index].from.toString().lastIndexOf(QOUTE))
          : mail_message[index].from.toString().substring(
          1, mail_message[index].from.toString().indexOf(AT)),
      image: "assets/images/avatar.png",
      subject: mail_message[index].decodeSubject(),
      isAttachmentAvailable: mail_message[index].hasAttachments(),
      isChecked: !(mail_message[index].isFlagged),
      tagColor: null,
      time: mail_message[index].decodeDate().toString()[0] == '2'
          ? mail_message[index].decodeDate().toString().substring(0, 10)
          : ' ',
      body: mail_message[index].decodeTextHtmlPart() == null
          ? mail_message[index].decodeTextPlainPart() == null
          ? ' '
          : mail_message[index].decodeTextPlainPart()
          : ' ',
      from_email: mail_message[index].fromEmail,
      html: mail_message[index].decodeTextHtmlPart(),
    ),
  );

  static List<Email> databaseJsonToEmailList(List<Map<String, dynamic>> rows) => List.generate(
    rows.length,
        (index) => Email(
      name: rows[index][DatabaseEmailsHelper.columnName],
      from_email: rows[index][DatabaseEmailsHelper.columnFromEmail],
      image: rows[index][DatabaseEmailsHelper.columnImage],
      subject: rows[index][DatabaseEmailsHelper.columnSubject],
      isAttachmentAvailable:
      (rows[index][DatabaseEmailsHelper.columnIsAttachmentAvailable] == 1)
          ? true
          : false,
      isChecked: (rows[index][DatabaseEmailsHelper.columnIsChecked] == 1)
          ? true
          : false,
      tagColor: null,
      time: rows[index][DatabaseEmailsHelper.columnTime],
      body: rows[index][DatabaseEmailsHelper.columnBody],
      html: rows[index][DatabaseEmailsHelper.columnHtml],
    ),
  );

}
