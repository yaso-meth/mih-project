import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';

class MzansiDirectoryProvider extends ChangeNotifier {
  int toolIndex;
  Position? userPosition;
  String userLocation;
  bool personalSearch;
  List<BookmarkedBusiness> bookmarkedBusinesses = [];
  List<Business>? favouriteBusinessesList;
  Map<String, Future<String>>? favBusImagesUrl;
  List<Business> searchedBusinesses = [];
  Map<String, Future<String>>? busSearchImagesUrl;
  Business? selectedBusiness;
  List<AppUser> searchedUsers = [];
  Map<String, Future<String>>? userSearchImagesUrl;
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

  void reset() {
    toolIndex = 0;
    userPosition = null;
    userLocation = "Unknown Location";
    personalSearch = true;
    bookmarkedBusinesses = [];
    searchedBusinesses = [];
    selectedBusiness = null;
    searchedUsers = [];
    selectedUser = null;
    searchTerm = "";
    businessTypeFilter = "";
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setUserPosition(Position? position) {
    userPosition = position;
    if (position == null) {
      userLocation = "Unknown Location";
    } else {
      userLocation = "${position.latitude}, ${position.longitude}";
    }
    notifyListeners();
  }

  void setPersonalSearch(bool personal) {
    personalSearch = personal;
    notifyListeners();
  }

  void setBookmarkedeBusinesses(
      {required List<BookmarkedBusiness> businesses}) {
    bookmarkedBusinesses = businesses;
    notifyListeners();
  }

  void setFavouriteBusinesses({
    required List<Business> businesses,
    required Map<String, Future<String>> businessesImagesUrl,
  }) {
    favouriteBusinessesList = businesses;
    favBusImagesUrl = businessesImagesUrl;
    notifyListeners();
  }

  void setSearchedBusinesses({
    required List<Business> searchedBusinesses,
    required Map<String, Future<String>> businessesImagesUrl,
  }) {
    this.searchedBusinesses = searchedBusinesses;
    busSearchImagesUrl = businessesImagesUrl;
    notifyListeners();
  }

  void setSelectedBusiness({required Business business}) {
    selectedBusiness = business;
    notifyListeners();
  }

  void setSearchedUsers({
    required List<AppUser> searchedUsers,
    required Map<String, Future<String>> userImagesUrl,
  }) {
    this.searchedUsers = searchedUsers;
    this.userSearchImagesUrl = userImagesUrl;
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
