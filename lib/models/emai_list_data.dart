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

  static setCurrentEmailList(List<Email> currentEmailList){
    _currentEmailList=currentEmailList;
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