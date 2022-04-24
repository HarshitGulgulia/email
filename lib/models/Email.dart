import 'package:email_client/Database/database_inbox_emails_helper.dart';
import 'package:enough_mail/mime_message.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

///Email data received is stored in this class
class Email {
  final String image, name, subject, body, time, email, html;
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
    this.email,
    this.html
  });

  Map<String, dynamic> toJson() =>
      {
        DatabaseInboxEmailsHelper.columnName : name,
        DatabaseInboxEmailsHelper.columnIsChecked: isChecked,
        DatabaseInboxEmailsHelper.columnTime: time,
        DatabaseInboxEmailsHelper.columnImage: image,
        DatabaseInboxEmailsHelper.columnSubject: subject,
        DatabaseInboxEmailsHelper.columnBody: body,
        DatabaseInboxEmailsHelper.columnIsAttachmentAvailable: isAttachmentAvailable,
        DatabaseInboxEmailsHelper.columnTagColor: tagColor.toString(),
        DatabaseInboxEmailsHelper.columnFromEmail: email,
        DatabaseInboxEmailsHelper.columnHtml: html,
      };

}


class ListGenerator{

  static List<Email> mimemessageToEmailList(List<MimeMessage> mail_message, String box) => List.generate(
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
      email: box == 'inbox' || box == 'bin' ? mail_message[index].fromEmail : box == 'draft' ? 'Draft' : mail_message[index].recipientAddresses.toString(),
      html: mail_message[index].decodeTextHtmlPart(),
    ),
  );

  static List<Email> databaseJsonToEmailList(List<Map<String, dynamic>> rows) => List.generate(
    rows.length,
        (index) => Email(
      name: rows[index][DatabaseInboxEmailsHelper.columnName],
      email: rows[index][DatabaseInboxEmailsHelper.columnFromEmail],
      image: rows[index][DatabaseInboxEmailsHelper.columnImage],
      subject: rows[index][DatabaseInboxEmailsHelper.columnSubject],
      isAttachmentAvailable:
      (rows[index][DatabaseInboxEmailsHelper.columnIsAttachmentAvailable] == 1)
          ? true
          : false,
      isChecked: (rows[index][DatabaseInboxEmailsHelper.columnIsChecked] == 1)
          ? true
          : false,
      tagColor: null,
      time: rows[index][DatabaseInboxEmailsHelper.columnTime],
      body: rows[index][DatabaseInboxEmailsHelper.columnBody],
      html: rows[index][DatabaseInboxEmailsHelper.columnHtml],
    ),
  );

}
