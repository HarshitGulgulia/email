import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:email_client/models/Email.dart';

class EmailListData extends ChangeNotifier{
  static List<Email> _currentEmailList=[];
  static List<Email> _emailInboxList=[];
  static List<Email> _emailSentList=[];
  static List<Email> _emailDraftList=[];
  static List<Email> _emailBinList=[];

  bool _inboxIsToggled = true;
  bool _sentIsToggled = false;
  bool _draftIsToggled = false;
  bool _binIsToggled = false;

  Future<bool> checkMailExist()async{
    if(_currentEmailList.isEmpty)
      return false;
    return true;
  }

  UnmodifiableListView get EmailList {
    return UnmodifiableListView(_currentEmailList);
  }

  static UnmodifiableListView get EmailListInbox {
    return UnmodifiableListView(_emailInboxList);
  }

  static UnmodifiableListView get EmailListSent {
    return UnmodifiableListView(_emailSentList);
  }

  static UnmodifiableListView get EmailListDraft {
    return UnmodifiableListView(_emailDraftList);
  }

  static UnmodifiableListView get EmailListBin {
    return UnmodifiableListView(_emailBinList);
  }

  static setEmailInboxList(List<Email> emailInboxList){
    _emailInboxList=emailInboxList;
  }

  static setEmailSentList(List<Email> emailSentList){
    _emailSentList=emailSentList;
  }

  static setEmailDraftList(List<Email> emailDraftList){
    _emailDraftList=emailDraftList;
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

  static setNullEmailSentList(){
    _emailSentList=[];
  }

  static setNullEmailDraftList(){
    _emailDraftList=[];
  }

  static setNullEmailBinList(){
    _emailBinList=[];
  }

  static setNullCurrentEmailList(){
    _currentEmailList=[];
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

  static void addToCurrentListToInboxList(Email email){
    _emailInboxList.insert(_emailInboxList.length,email);
    _currentEmailList=_emailInboxList;
  }

  void addToCurrentListToSentList(){
    _currentEmailList=_emailSentList;
    notifyListeners();
  }
  void addToCurrentListToDraftList(){
    _currentEmailList=_emailDraftList;
    notifyListeners();
  }
  void addToCurrentListToBinList(){
    _currentEmailList=_emailBinList;
    notifyListeners();
  }

  void updateInboxToggle(){
    _inboxIsToggled = true;
    _sentIsToggled = false;
    _draftIsToggled = false;
    _binIsToggled = false;
    notifyListeners();
  }

  void updateDraftToggle(){
    _inboxIsToggled = false;
    _sentIsToggled = false;
    _draftIsToggled = true;
    _binIsToggled = false;
    notifyListeners();
  }
  void updateSentToggle(){
    _inboxIsToggled = false;
    _sentIsToggled = true;
    _draftIsToggled = false;
    _binIsToggled = false;
    notifyListeners();
  }
  void updateBinToggle(){
    _inboxIsToggled = false;
    _sentIsToggled = false;
    _draftIsToggled = false;
    _binIsToggled = true;
    notifyListeners();
  }

  bool get inboxState {
    return _inboxIsToggled;
  }

  bool get sentState {
    return _sentIsToggled;
  }

  bool get draftState {
    return _draftIsToggled;
  }

  bool get binState {
    return _binIsToggled;
  }

}