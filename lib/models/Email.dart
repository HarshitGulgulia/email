import 'package:email_client/Database/database_emails_helper.dart';
import 'package:flutter/material.dart';

///Email data received is stored in this class
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
      };


}

// List<Email> dummyEmails = List.generate(
//   demo_data.length,
//       (index) => Email(
//     name: demo_data[index]['name'],
//     image: demo_data[index]['image'],
//     subject: demo_data[index]['subject'],
//     isAttachmentAvailable: demo_data[index]['isAttachmentAvailable'],
//     isChecked: demo_data[index]['isChecked'],
//     tagColor: demo_data[index]['tagColor'],
//     time: demo_data[index]['time'],
//     body: emailDemoText,
//   ),
// );
//
// List demo_data = [
//   {
//     "name": "Apple",
//     "image": "assets/images/user_1.png",
//     "subject": "iPhone 12 is here",
//     "isAttachmentAvailable": false,
//     "isChecked": true,
//     "tagColor": null,
//     "time": "Now",
//     "body": emailDemoText
//   },
//   {
//     "name": "Elvia Atkins",
//     "image": "assets/images/user_2.png",
//     "subject": "Inspiration for our new home",
//     "isAttachmentAvailable": true,
//     "isChecked": false,
//     "tagColor": null,
//     "time": "15:32",
//     "body": emailDemoText
//   },
//   {
//     "name": "Marvin Kiehn",
//     "image": "assets/images/user_3.png",
//     "subject": "Business-focused empowering the world",
//     "isAttachmentAvailable": true,
//     "isChecked": false,
//     "tagColor": null,
//     "time": "14:27",
//     "body": emailDemoText
//   },
//   {
//     "name": "Domenic Bosco",
//     "image": "assets/images/user_4.png",
//     "subject": "The fastest way to Design",
//     "isAttachmentAvailable": false,
//     "isChecked": true,
//     "tagColor": Color(0xFF23CF91),
//     "time": "10:43",
//     "body": emailDemoText
//   },
//   {
//     "name": "Elenor Bauch",
//     "image": "assets/images/user_5.png",
//     "subject": "New job opportunities",
//     "isAttachmentAvailable": false,
//     "isChecked": false,
//     "tagColor": Color(0xFF3A6FF7),
//     "time": "9:58",
//     "body": emailDemoText
//   }
// ];
//
// String emailDemoText =
//     "Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed";
