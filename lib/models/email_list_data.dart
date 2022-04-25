import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:email_client/models/Email.dart';

class EmailListData extends ChangeNotifier{
  static List<Email> _currentEmailList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  static List<Email> _emailInboxList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  static List<Email> _emailSentList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  static List<Email> _emailDraftList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  static List<Email> _emailBinList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];

  bool _inboxIsToggled = true;
  bool _sentIsToggled = false;
  bool _draftIsToggled = false;
  bool _binIsToggled = false;

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
    _emailInboxList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  }

  static setNullEmailSentList(){
    _emailSentList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  }

  static setNullEmailDraftList(){
    _emailDraftList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  }

  static setNullEmailBinList(){
    _emailBinList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
  }

  static setNullCurrentEmailList(){
    _currentEmailList=[Email(time:'',isChecked: true, image: "assets/images/avatar.png", name: '', subject: ' ', body: ' ',isAttachmentAvailable: false, tagColor: null,from_email: ' ',html: ' ')];
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