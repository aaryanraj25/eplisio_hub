import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/profile/data/model/profile_model.dart';
import 'package:eplisio_hub/features/profile/presentation/controller/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.error.isNotEmpty) {
          return _buildErrorState();
        }

        final profile = controller.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data'));
        }

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [_buildAppBar(profile, context)];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(profile),
                  const SizedBox(height: 24),
                  _buildStatistics(profile.statistics),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Account Management'),
                  _buildAccountMenuItems(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Organization'),
                  _buildOrganizationMenuItems(),
                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(AdminProfileModel profile, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 30),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                profile.organization.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Main gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.9),
                    AppColors.primary,
                    AppColors.primary.withBlue(150),
                  ],
                ),
              ),
            ),
            // Decorative elements
            Positioned(
              right: -80,
              top: -20,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Subtle pattern overlay
            Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pattern.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AdminProfileModel profile) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                profile.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: controller.navigateToEditProfile,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(Statistics statistics) {
    String formatCurrency(double amount) {
      if (amount >= 10000000) {
        // 1 Crore = 10,000,000
        return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
      } else if (amount >= 100000) {
        // 1 Lakh = 100,000
        return '₹${(amount / 100000).toStringAsFixed(2)} Lakh';
      } else if (amount >= 1000) {
        // 1 K = 1,000
        return '₹${(amount / 1000).toStringAsFixed(2)} K';
      } else {
        return '₹${amount.toStringAsFixed(2)}';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            'Employees',
            statistics.totalEmployees.toString(),
            Icons.people_alt_outlined,
            Colors.blue,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Sales',
            formatCurrency(statistics.totalSales),
            Icons.currency_rupee,
            Colors.green,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            'Orders',
            statistics.totalOrders.toString(),
            Icons.shopping_cart_outlined,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildAccountMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.lock_outline,
          iconColor: Colors.blue,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: controller.navigateToChangePassword,
        ),
      ],
    );
  }

  Widget _buildOrganizationMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          iconColor: Colors.purple,
          title: 'Orders',
          subtitle: 'View and manage customer orders',
          onTap: controller.navigateToOrders,
        ),
        _buildMenuItem(
          icon: Icons.person_add_outlined,
          iconColor: Colors.green,
          title: 'Add Admin',
          subtitle: 'Create new admin accounts',
          onTap: controller.navigateToAddAdmin,
        ),
        _buildMenuItem(
          icon: Icons.local_hospital_outlined,
          iconColor: Colors.red,
          title: 'Hospitals',
          subtitle: 'Register a new hospital',
          onTap: controller.navigateToAddHospital,
        ),
        _buildMenuItem(
          icon: Icons.people_outline,
          iconColor: Colors.blue,
          title: 'Add Client',
          subtitle: 'Register a new client',
          onTap: controller.navigateToAddClient,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 54,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.loadProfile,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
