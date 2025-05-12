import 'package:eplisio_hub/features/employee/data/model/employee_model.dart';
import 'package:intl/intl.dart';

class EmployeeDetailModel {
  final EmployeeModel employee;
  final List<OrderModel> orders;
  final List<SaleModel> sales;
  final List<AttendanceModel> attendance;
  final List<ClientModel> clients;

  EmployeeDetailModel({
    required this.employee,
    required this.orders,
    required this.sales,
    required this.attendance,
    required this.clients,
  });

  factory EmployeeDetailModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailModel(
      employee: EmployeeModel.fromJson(json['employee']),
      orders:
          (json['orders'] as List).map((e) => OrderModel.fromJson(e)).toList(),
      sales: (json['sales'] as List).map((e) => SaleModel.fromJson(e)).toList(),
      attendance: (json['attendance'] as List)
          .map((e) => AttendanceModel.fromJson(e))
          .toList(),
      clients: (json['clients'] as List)
          .map((e) => ClientModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderModel {
  final String id;
  final String? clinicHospitalName;
  final String? clinicHospitalAddress;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String? paymentStatus;
  final String? deliveredStatus;
  final DateTime? orderDate;
  final String employeeId;
  final String organizationId;
  final DateTime createdAt;
  final String status;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    this.clinicHospitalName,
    this.clinicHospitalAddress,
    required this.items,
    required this.totalAmount,
    this.paymentStatus,
    this.deliveredStatus,
    this.orderDate,
    required this.employeeId,
    required this.organizationId,
    required this.createdAt,
    required this.status,
    this.completedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      clinicHospitalName: json['clinic_hospital_name'],
      clinicHospitalAddress: json['clinic_hospital_address'],
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'],
      deliveredStatus: json['delivered_status'],
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : null,
      employeeId: json['employee_id'],
      organizationId: json['organization_id'],
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }
}

class OrderItemModel {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double totalAmount;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalAmount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? json['total'] ?? 0).toDouble(),
    );
  }
}

class SaleModel {
  final String id;
  final String orderId;
  final String organizationId;
  final String employeeId;
  final double totalAmount;
  final DateTime date;
  final List<OrderItemModel> items;

  SaleModel({
    required this.id,
    required this.orderId,
    required this.organizationId,
    required this.employeeId,
    required this.totalAmount,
    required this.date,
    required this.items,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['_id'],
      orderId: json['order_id'],
      organizationId: json['organization_id'],
      employeeId: json['employee_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}

class AttendanceModel {
  final String id;
  final String employeeId;
  final DateTime clockInTime;
  final DateTime date;
  final bool workFromHome;
  final String organizationId;
  final DateTime? clockOutTime;
  final double? totalHours;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.clockInTime,
    required this.date,
    required this.workFromHome,
    required this.organizationId,
    this.clockOutTime,
    this.totalHours,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'],
      employeeId: json['employee_id'],
      clockInTime: DateTime.parse(json['clock_in_time']),
      date: DateTime.parse(json['date']),
      workFromHome: json['work_from_home'],
      organizationId: json['organization_id'],
      clockOutTime: json['clock_out_time'] != null
          ? DateTime.parse(json['clock_out_time'])
          : null,
      totalHours: json['total_hours'] != null
          ? (json['total_hours'] as num).toDouble()
          : null,
    );
  }

  static final _istOffset = const Duration(hours: 5, minutes: 30);

  String get formattedClockIn =>
      DateFormat('hh:mm a').format(clockInTime.toUtc().add(_istOffset));

  String get formattedClockOut => clockOutTime != null
      ? DateFormat('hh:mm a').format(clockOutTime!.toUtc().add(_istOffset))
      : 'Not clocked out';

  String get formattedDate =>
      DateFormat('MMM dd, yyyy').format(date.toUtc().add(_istOffset));
}

class ClientModel {
  final String id;
  final String name;
  final String contactNumber;
  final String email;
  final String clinicId;
  final String designation;
  final String employeeId;
  final String organizationId;
  final DateTime createdAt;

  ClientModel({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.clinicId,
    required this.designation,
    required this.employeeId,
    required this.organizationId,
    required this.createdAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['_id'],
      name: json['name'],
      contactNumber: json['contact_number'],
      email: json['email'],
      clinicId: json['clinic_id'],
      designation: json['designation'],
      employeeId: json['employee_id'],
      organizationId: json['organization_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class EmployeeLocationModel {
  final String employeeName;
  final LocationModel location;
  final String googleMapsUrl;

  EmployeeLocationModel({
    required this.employeeName,
    required this.location,
    required this.googleMapsUrl,
  });

  factory EmployeeLocationModel.fromJson(Map<String, dynamic> json) {
    return EmployeeLocationModel(
      employeeName: json['employee_name'],
      location: LocationModel.fromJson(json['location']),
      googleMapsUrl: json['google_maps_url'],
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get formattedLastUpdate =>
      DateFormat('MMM dd, yyyy hh:mm a').format(updatedAt);
}

class TrackingModel {
  final String id;
  final String employeeId;
  final DateTime timestamp;
  final LocationModel location;

  TrackingModel({
    required this.id,
    required this.employeeId,
    required this.timestamp,
    required this.location,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      id: json['_id'],
      employeeId: json['employee_id'],
      timestamp: DateTime.parse(json['timestamp']),
      location: LocationModel.fromJson(json['location']),
    );
  }
}
