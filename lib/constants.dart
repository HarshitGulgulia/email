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

class Command{
  static String _Bin='Bin';

  static ImapClient _CLIENT;

  static get Bin => _Bin;

  static setTrash(){
    _Bin = 'Trash';
  }

  static setBin(){
    _Bin = 'Bin';
  }

  static get Client => _CLIENT;

  static setClient(ImapClient client){
    _CLIENT = client;
  }

}