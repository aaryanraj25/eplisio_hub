import 'package:eplisio_hub/features/orders/data/model/orders_model.dart';
import 'package:eplisio_hub/features/orders/data/repo/orders_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController with GetTickerProviderStateMixin {
  final OrderRepository _repository;

  OrderController(this._repository);

  // Orders lists for each tab
  final RxList<Order> prospectiveOrders = <Order>[].obs;
  final RxList<Order> completedOrders = <Order>[].obs;
  final RxList<Order> pendingOrders = <Order>[].obs;
  final RxList<Order> rejectedOrders = <Order>[].obs;

  // Loading states for each tab
  final RxBool isLoadingProspective = false.obs;
  final RxBool isLoadingCompleted = false.obs;
  final RxBool isLoadingPending = false.obs;
  final RxBool isLoadingRejected = false.obs;

  // Pagination variables for each tab
  final RxInt prospectivePage = 1.obs;
  final RxInt completedPage = 1.obs;
  final RxInt pendingPage = 1.obs;
  final RxInt rejectedPage = 1.obs;

  // Has more data flags for each tab
  final RxBool hasMoreProspective = true.obs;
  final RxBool hasMoreCompleted = true.obs;
  final RxBool hasMorePending = true.obs;
  final RxBool hasMoreRejected = true.obs;

  // Search query for each tab
  final RxString prospectiveSearch = ''.obs;
  final RxString completedSearch = ''.obs;
  final RxString pendingSearch = ''.obs;
  final RxString rejectedSearch = ''.obs;

  final RxString loadingOrderId = ''.obs;
  final RxBool isUpdatingStatus = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabChange);
    fetchAllOrders();
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      // Refresh data when tab changes
      switch (tabController.index) {
        case 0:
          if (prospectiveOrders.isEmpty) fetchProspectiveOrders();
          break;
        case 1:
          if (completedOrders.isEmpty) fetchCompletedOrders();
          break;
        case 2:
          if (pendingOrders.isEmpty) fetchPendingOrders();
          break;
        case 3:
          if (rejectedOrders.isEmpty) fetchRejectedOrders();
          break;
      }
    }
  }

  Future<void> fetchAllOrders() async {
    await Future.wait([
      fetchProspectiveOrders(),
      fetchCompletedOrders(),
      fetchPendingOrders(),
      fetchRejectedOrders(),
    ]);
  }

  Future<void> fetchCompletedOrders({bool refresh = false}) async {
    if (refresh) {
      completedPage.value = 1;
      hasMoreCompleted.value = true;
    }

    if (!hasMoreCompleted.value && !refresh) return;

    try {
      isLoadingCompleted.value = true;
      final response = await _repository.getOrders(
        'completed',
        page: completedPage.value,
      );

      if (refresh) {
        completedOrders.clear();
      }

      // Update hasMore based on current page and total pages
      hasMoreCompleted.value = response.page < response.pages;

      if (response.orders.isEmpty) {
        hasMoreCompleted.value = false;
      } else {
        completedOrders.addAll(response.orders);
        completedPage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch completed orders',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingCompleted.value = false;
    }
  }

  // Update other fetch methods similarly
  Future<void> fetchProspectiveOrders({bool refresh = false}) async {
    if (refresh) {
      prospectivePage.value = 1;
      hasMoreProspective.value = true;
    }

    if (!hasMoreProspective.value && !refresh) return;

    try {
      isLoadingProspective.value = true;
      final response = await _repository.getOrders(
        'prospective',
        page: prospectivePage.value,
      );

      if (refresh) {
        prospectiveOrders.clear();
      }

      hasMoreProspective.value = response.page < response.pages;

      if (response.orders.isEmpty) {
        hasMoreProspective.value = false;
      } else {
        prospectiveOrders.addAll(response.orders);
        prospectivePage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch prospective orders',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingProspective.value = false;
    }
  }

  Future<void> fetchPendingOrders({bool refresh = false}) async {
    if (refresh) {
      pendingPage.value = 1;
      hasMorePending.value = true;
    }

    if (!hasMorePending.value && !refresh) return;

    try {
      isLoadingPending.value = true;

      // Add query parameters for pagination and status
      final response = await _repository.getOrders(
        'pending',
        page: pendingPage.value,
        limit: 10, // You can adjust this value as needed
      );

      if (refresh) {
        pendingOrders.clear();
      }

      // Check if response data exists and has the expected structure
      if (response.orders.isNotEmpty) {
        pendingOrders.addAll(response.orders);
        pendingPage.value++;

        // Update hasMore based on total pages
        hasMorePending.value = pendingPage.value <= response.pages;
      } else {
        hasMorePending.value = false;
      }
    } catch (e) {
      hasMorePending.value = false;
      Get.snackbar(
        'Error',
        'Failed to fetch pending orders: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingPending.value = false;
    }
  }

  Future<void> fetchRejectedOrders({bool refresh = false}) async {
    if (refresh) {
      rejectedPage.value = 1;
      hasMoreRejected.value = true;
    }

    if (!hasMoreRejected.value && !refresh) return;

    try {
      isLoadingRejected.value = true;
      final response = await _repository.getOrders(
        'rejected',
        page: rejectedPage.value,
      );

      if (refresh) {
        rejectedOrders.clear();
      }

      hasMoreRejected.value = response.page < response.pages;

      if (response.orders.isEmpty) {
        hasMoreRejected.value = false;
      } else {
        rejectedOrders.addAll(response.orders);
        rejectedPage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch rejected orders',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRejected.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      loadingOrderId.value = orderId;
      isUpdatingStatus.value = true;

      await _repository.updateOrderStatus(orderId, status);

      // Refresh current tab data
      switch (tabController.index) {
        case 0:
          await fetchProspectiveOrders(refresh: true);
          break;
        case 1:
          await fetchCompletedOrders(refresh: true);
          break;
        case 2:
          await fetchPendingOrders(refresh: true);
          break;
        case 3:
          await fetchRejectedOrders(refresh: true);
          break;
      }

      Get.snackbar(
        'Success',
        'Order status updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update order status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loadingOrderId.value = '';
      isUpdatingStatus.value = false;
    }
  }

  Future<void> acceptOrder(String orderId) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Accept'),
        content: const Text('Are you sure you want to accept this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (result == true) {
      await updateOrderStatus(orderId, 'accepted');
    }
  }

  Future<void> rejectOrder(String orderId) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Reject'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (result == true) {
      await updateOrderStatus(orderId, 'rejected');
    }
  }

  // Search methods for each tab
  void searchProspectiveOrders(String query) {
    prospectiveSearch.value = query;
    fetchProspectiveOrders(refresh: true);
  }

  void searchCompletedOrders(String query) {
    completedSearch.value = query;
    fetchCompletedOrders(refresh: true);
  }

  void searchPendingOrders(String query) {
    pendingSearch.value = query;
    fetchPendingOrders(refresh: true);
  }

  void searchRejectedOrders(String query) {
    rejectedSearch.value = query;
    fetchRejectedOrders(refresh: true);
  }

  // Load more methods for infinite scrolling
  Future<void> loadMoreProspective() async {
    if (!isLoadingProspective.value && hasMoreProspective.value) {
      await fetchProspectiveOrders();
    }
  }

  Future<void> loadMoreCompleted() async {
    if (!isLoadingCompleted.value && hasMoreCompleted.value) {
      await fetchCompletedOrders();
    }
  }

  Future<void> loadMorePending() async {
    if (!isLoadingPending.value && hasMorePending.value) {
      await fetchPendingOrders();
    }
  }

  Future<void> loadMoreRejected() async {
    if (!isLoadingRejected.value && hasMoreRejected.value) {
      await fetchRejectedOrders();
    }
  }

  // Refresh methods for pull-to-refresh
  Future<void> refreshProspective() async {
    await fetchProspectiveOrders(refresh: true);
  }

  Future<void> refreshCompleted() async {
    await fetchCompletedOrders(refresh: true);
  }

  Future<void> refreshPending() async {
    await fetchPendingOrders(refresh: true);
  }

  Future<void> refreshRejected() async {
    await fetchRejectedOrders(refresh: true);
  }
}
