import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _currentTabIndex = 0;
  String _searchQuery = '';

  int get currentTabIndex => _currentTabIndex;
  String get searchQuery => _searchQuery;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
