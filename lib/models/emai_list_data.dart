import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:email_client/models/Email.dart';

class EmailListData extends ChangeNotifier{
  static List<Email> _currentEmailList;
  static List<Email> _emailInboxList;
  static List<Email> _emailSentList;
  static List<Email> _emailDraftList;
  static List<Email> _emailBinList;

  UnmodifiableListView get EmailList {
    return UnmodifiableListView(_currentEmailList);
  }

  static UnmodifiableListView get EmailListInbox {
    return UnmodifiableListView(_emailInboxList);
  }

  UnmodifiableListView get EmailListSent {
    return UnmodifiableListView(_emailSentList);
  }

  UnmodifiableListView get EmailListDraft {
    return UnmodifiableListView(_emailDraftList);
  }

  UnmodifiableListView get EmailListBin {
    return UnmodifiableListView(_emailBinList);
  }

  static setEmailInboxList(List<Email> emailInboxList){
    _emailInboxList=emailInboxList;
  }

  static setEmailDraftList(List<Email> emailDraftList){
    _emailDraftList=emailDraftList;
  }

  static setEmailSentList(List<Email> emailSentList){
    _emailSentList=emailSentList;
  }

  static setEmailBinList(List<Email> emailBinList){
    _emailBinList=emailBinList;
  }

  static setCurrentEmailList(List<Email> currentEmailList){
    _currentEmailList=currentEmailList;
  }

  static setNullEmailInboxList(){
    _emailInboxList=[];
  }

  static setNullEmailDraftList(){
    _emailDraftList=[];
  }

  static setNullEmailSentList(){
    _emailSentList=[];
  }

  static setNullEmailBinList(){
    _emailBinList=[];
  }

  static setNullCurrentEmailList(){
    _currentEmailList=[];
  }
  
  void addEmail(Email email){
    _currentEmailList.add(email);
    notifyListeners();
  }

  void updateCurrentListToInboxList(){
    _currentEmailList=_emailInboxList;
    notifyListeners();
  }

  void updateCurrentListToSentList(){
    _currentEmailList=_emailSentList;
    notifyListeners();
  }

  void updateCurrentListToDraftList(){
    _currentEmailList=_emailDraftList;
    notifyListeners();
  }

  void updateCurrentListToBinList(){
    _currentEmailList=_emailBinList;
    notifyListeners();
  }

}