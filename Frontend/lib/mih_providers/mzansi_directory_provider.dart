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
  Map<String, ImageProvider<Object>?>? favBusImages;
  List<Business>? searchedBusinesses;
  Map<String, ImageProvider<Object>?>? busSearchImages;
  Business? selectedBusiness;
  List<AppUser>? searchedUsers;
  Map<String, ImageProvider<Object>?>? userSearchImages;
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
    searchedBusinesses = null;
    selectedBusiness = null;
    searchedUsers = null;
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
    required Map<String, ImageProvider<Object>?> businessesImages,
  }) {
    favouriteBusinessesList = businesses;
    favBusImages = businessesImages;
    notifyListeners();
  }

  void setSearchedBusinesses({
    required List<Business> searchedBusinesses,
    required Map<String, ImageProvider<Object>?> businessesImages,
  }) {
    this.searchedBusinesses = searchedBusinesses;
    busSearchImages = businessesImages;
    notifyListeners();
  }

  void setSelectedBusiness({required Business business}) {
    selectedBusiness = business;
    notifyListeners();
  }

  void setSearchedUsers({
    required List<AppUser> searchedUsers,
    required Map<String, ImageProvider<Object>?> userImages,
  }) {
    this.searchedUsers = searchedUsers;
    this.userSearchImages = userImages;
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
