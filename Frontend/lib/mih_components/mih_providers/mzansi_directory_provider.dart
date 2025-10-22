import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';

class MzansiDirectoryProvider extends ChangeNotifier {
  int toolIndex;
  Position? userPosition;
  String userLocation;
  bool personalSearch;
  List<BookmarkedBusiness> bookmarkedBusinesses = [];
  Map<String, Business?> businessDetailsMap = {};
  List<Business>? searchedBusinesses;
  Business? selectedBusiness;
  List<AppUser>? searchedUsers;
  AppUser? selectedUser;
  String searchTerm;
  String businessTypeFilter;

  MzansiDirectoryProvider({
    this.toolIndex = 0,
    this.personalSearch = true,
    this.userLocation = "Unknown Location",
    this.searchTerm = "",
    this.businessTypeFilter = "",
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setUserPosition(Position? position) {
    userPosition = position;
    userLocation = "${position?.latitude}, ${position?.longitude}";
    notifyListeners();
  }

  void setPersonalSearch(bool personal) {
    personalSearch = personal;
    notifyListeners();
  }

  void setFavouriteBusinesses({required List<BookmarkedBusiness> businesses}) {
    bookmarkedBusinesses = businesses;
    notifyListeners();
  }

  void setBusinessDetailsMap({required Map<String, Business?> detailsMap}) {
    businessDetailsMap = detailsMap;
    notifyListeners();
  }

  void setSearchedBusinesses({required List<Business> searchedBusinesses}) {
    this.searchedBusinesses = searchedBusinesses;
    notifyListeners();
  }

  void setSelectedBusiness({required Business business}) {
    selectedBusiness = business;
    notifyListeners();
  }

  void setSearchedUsers({required List<AppUser> searchedUsers}) {
    this.searchedUsers = searchedUsers;
    notifyListeners();
  }

  void setSelectedUser({required AppUser user}) {
    selectedUser = user;
    notifyListeners();
  }

  void setSearchTerm({required String searchTerm}) {
    this.searchTerm = searchTerm;
    notifyListeners();
  }

  void setBusinessTypeFilter({required String businessTypeFilter}) {
    this.businessTypeFilter = businessTypeFilter;
    notifyListeners();
  }
}
