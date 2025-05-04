import 'package:eplisio_hub/features/add_hospital/data/model/hospital_model.dart';
import 'package:eplisio_hub/features/add_hospital/data/repo/hospital_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HospitalController extends GetxController {
  final HospitalRepository _repository;
  
  HospitalController(this._repository);

  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxList<HospitalSearchResult> searchResults = <HospitalSearchResult>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxInt currentPage = 0.obs;
  final int limit = 10;
  final RxBool hasMoreData = true.obs;
  final RxString currentlyAddingId = ''.obs;

  // Filters
  final RxString searchQuery = ''.obs;
  final RxString selectedType = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedState = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHospitals();
  }

  Future<void> fetchHospitals({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        hospitals.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      isLoading.value = true;
      final results = await _repository.getHospitals(
        skip: currentPage.value * limit,
        limit: limit,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        type: selectedType.value.isNotEmpty ? selectedType.value : null,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
        state: selectedState.value.isNotEmpty ? selectedState.value : null,
      );

      if (results.length < limit) {
        hasMoreData.value = false;
      }

      if (refresh) {
        hospitals.value = results;
      } else {
        hospitals.addAll(results);
      }
      currentPage.value++;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch hospitals',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchHospitals(String query) async {
    if (query.length < 3) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;
      final results = await _repository.searchHospitals(query);
      searchResults.value = results;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search hospitals',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> addHospital(String placeId) async {
    try {
      currentlyAddingId.value = placeId; // Set the current hospital being added
      final hospital = await _repository.addHospital(placeId);
      hospitals.add(hospital);
      Get.back(); // Close dialog
      Get.snackbar(
        'Success',
        'Hospital added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add hospital',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      currentlyAddingId.value = ''; // Clear the current hospital being added
    }
  }

  void applyFilters({
    String? type,
    String? city,
    String? state,
    String? search,
  }) {
    selectedType.value = type ?? selectedType.value;
    selectedCity.value = city ?? selectedCity.value;
    selectedState.value = state ?? selectedState.value;
    searchQuery.value = search ?? searchQuery.value;
    fetchHospitals(refresh: true);
  }

  void clearFilters() {
    selectedType.value = '';
    selectedCity.value = '';
    selectedState.value = '';
    searchQuery.value = '';
    fetchHospitals(refresh: true);
  }
}