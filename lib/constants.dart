import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

/// All of our constant schemes are defined

const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kDefaultPadding = 20.0;

const DATALOADED = 'Data Loaded';
const DATALOADINGERROR = 'error';

const IMAPHOSTSERVER = 'imap.gmail.com';
const IMAPSERVERPORT = 993;
const ISIMAPSERVERSECURE = true;

const QOUTE = '"';
const AT = '@';

BuildContext CONTEXT;

class Command{
  static String _Bin='Bin';

  static MailClient _CLIENT;

  static get Bin => _Bin;

  static setTrash(){
    _Bin = 'Trash';
  }

  static setBin(){
    _Bin = 'Bin';
  }

  static get Client => _CLIENT;

  static setClient(MailClient client){
    _CLIENT = client;
  }

}

var ColorList = {
  'A': Colors.indigo,
  'B': Colors.yellow,
  'C': Colors.teal,
  'D': Colors.green,
  'E': Colors.purpleAccent,
  'F': Colors.purple,
  'G': Colors.red,
  'H': Colors.redAccent,
  'I': Colors.orangeAccent,
  'J': Colors.blue[900],
  'K': Colors.orange,
  'L': Colors.indigo,
  'M': Colors.amberAccent,
  'N': Colors.amber,
  'O': Colors.pinkAccent,
  'P': Colors.pink,
  'Q': Colors.indigoAccent,
  'R': Colors.amber[700],
  'S': Colors.blueAccent,
  'T': Colors.blue,
  'U': Colors.blueGrey,
  'V': Colors.brown,
  'W': Colors.lightBlue,
  'X': Colors.lightBlueAccent,
  'Y': Colors.green[800],
  'Z': Colors.brown[900],
};