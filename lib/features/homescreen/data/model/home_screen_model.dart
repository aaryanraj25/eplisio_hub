class OrganizationStatsModel {
  final double totalSales;
  final int totalVisits;
  final int totalMeetings;

  OrganizationStatsModel({
    required this.totalSales,
    required this.totalVisits,
    required this.totalMeetings,
  });

  factory OrganizationStatsModel.fromJson(Map<String, dynamic> json) {
    return OrganizationStatsModel(
      totalSales: (json['totalSales'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      totalMeetings: json['totalMeetings'] ?? 0,
    );
  }
}

class EmployeePerformanceModel {
  final String employeeId;
  final String name;
  final double salesAmount;
  final int clientsCount;
  final int hospitalVisits;

  EmployeePerformanceModel({
    required this.employeeId,
    required this.name,
    required this.salesAmount,
    required this.clientsCount,
    required this.hospitalVisits,
  });

  factory EmployeePerformanceModel.fromJson(Map<String, dynamic> json) {
    return EmployeePerformanceModel(
      employeeId: json['employeeId'] ?? '',
      name: json['name'] ?? '',
      salesAmount: (json['salesAmount'] ?? 0).toDouble(),
      clientsCount: json['clientsCount'] ?? 0,
      hospitalVisits: json['hospitalVisits'] ?? 0,
    );
  }
}

class TopEmployeeModel {
  final String employeeId;
  final String name;
  final double salesAmount;

  TopEmployeeModel({
    required this.employeeId,
    required this.name,
    required this.salesAmount,
  });

  factory TopEmployeeModel.fromJson(Map<String, dynamic> json) {
    return TopEmployeeModel(
      employeeId: json['employeeId'] ?? '',
      name: json['name'] ?? '',
      salesAmount: (json['salesAmount'] ?? 0).toDouble(),
    );
  }
}

class TopProductModel {
  final String productId;
  final String name;
  final int quantity;
  final double sales;

  TopProductModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.sales,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      sales: (json['sales'] ?? 0).toDouble(),
    );
  }
}

class SalesTrendModel {
  final List<YearlySales> yearlySales;
  final List<MonthlySales> monthlySales;

  SalesTrendModel({
    required this.yearlySales,
    required this.monthlySales,
  });

  factory SalesTrendModel.fromJson(Map<String, dynamic> json) {
    return SalesTrendModel(
      yearlySales: (json['yearlySales'] as List?)
              ?.map((e) => YearlySales.fromJson(e))
              .toList() ??
          [],
      monthlySales: (json['monthlySales'] as List?)
              ?.map((e) => MonthlySales.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class YearlySales {
  final int year;
  final double amount;

  YearlySales({
    required this.year,
    required this.amount,
  });

  factory YearlySales.fromJson(Map<String, dynamic> json) {
    return YearlySales(
      year: json['year'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class MonthlySales {
  final String month;
  final int year;
  final double amount;

  MonthlySales({
    required this.month,
    required this.year,
    required this.amount,
  });

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      month: json['month'] ?? '',
      year: json['year'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}