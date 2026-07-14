import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/mzansi_directory_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';

class MzansiDirectoryProvider extends ChangeNotifier {
  final MzansiDirectoryHiveData _hiveData;

  int toolIndex;
  int personalViewIndex;
  int businessViewIndex;
  Position? userPosition;
  String userLocation;
  bool personalSearch;
  List<BookmarkedBusiness> bookmarkedBusinesses = [];
  List<Business>? favouriteBusinessesList;
  List<Business> searchedBusinesses = [];
  List<String> businessTypes = [];
  Business? selectedBusiness;
  List<AppUser> searchedUsers = [];
  AppUser? selectedUser;
  String searchTerm;
  String businessTypeFilter;

  MzansiDirectoryProvider(
    this._hiveData, {
    this.toolIndex = 0,
    this.personalViewIndex = 0,
    this.businessViewIndex = 0,
    this.personalSearch = true,
    this.userLocation = "Unknown Location",
    this.searchTerm = "",
    this.businessTypeFilter = "",
  });

  void loadCachedDirectory() {
    bookmarkedBusinesses = _hiveData.getBookmarkedBusinesses();
    favouriteBusinessesList = _hiveData.getFavouriteBusinesses();
    businessTypes = _hiveData.getBusinessTypes();
    KenLogger.success("Mzansi Directory Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(
      MzansiProfileProvider profileProvider) async {
    bool success = await _hiveData.syncDirectoryDataWithServer(profileProvider);
    loadCachedDirectory();
    return success;
  }

  Future<void> clearDirectoryCacheAndProvider() async {
    await _hiveData.clearDirectoryCache();
    reset();
  }

  void reset() {
    toolIndex = 0;
    personalViewIndex = 0;
    businessViewIndex = 0;
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

  void setPersonalViewIndex(int index) {
    personalViewIndex = index;
    notifyListeners();
  }

  void setBusinessViewIndex(int index) {
    businessViewIndex = index;
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
  }) {
    favouriteBusinessesList = businesses;
    notifyListeners();
  }

  void setSearchedBusinesses({
    required List<Business> searchedBusinesses,
  }) {
    this.searchedBusinesses = searchedBusinesses;
    notifyListeners();
  }

  void setSelectedBusiness({required Business business}) {
    selectedBusiness = business;
    notifyListeners();
  }

  void setSearchedUsers({
    required List<AppUser> searchedUsers,
  }) {
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
