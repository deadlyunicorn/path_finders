import 'package:flutter/material.dart';

abstract class TargetListingsProviderAbstract with ChangeNotifier{

  List _targetEntries = [];

  Future<void> remove( String targetName );

  void set( List targetEntries ){
    _targetEntries = targetEntries;
    notifyListeners();
  }

  void initialize( List initialEntriesFromFile){
    _targetEntries = initialEntriesFromFile;
  }

  List get targetEntries => _targetEntries;


} 