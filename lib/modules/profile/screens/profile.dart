// profileSetting.dart
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/modules/profile/providers/profileProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// Import the provider file

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildProfileHeader(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildPersonalInfoSection(),
                      const SizedBox(height: 24),
                      _buildVehicleInfoSection(),
                      const SizedBox(height: 24),
                      _buildPaymentInfoSection(),
                      const SizedBox(height: 24),
                      _buildSettingsSection(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: 220,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [
      //       Colors.white,
      //       Colors.blue.shade600,
      //     ],
      //   ),
      // ),
      child: Stack(
        children: [
         const Positioned(
            top: 20,
            left: 20,
            child: Text(
              'Profile',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Selector<ProfileProvider, String>(
                    selector: (_, provider) =>
                        provider.driverData['profileImage'],
                    builder: (context, profileImage, _) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:  AppColors.primary,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            profileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Selector<ProfileProvider, String>(
                    selector: (_, provider) => provider.driverData['name'],
                    builder: (context, name, _) {
                      return Text(
                        name,
                        style: const TextStyle(
                          color:  AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Selector<ProfileProvider, Map<String, dynamic>>(
                    selector: (_, provider) => {
                      'rating': provider.driverData['rating'],
                      'totalTrips': provider.driverData['totalTrips'],
                    },
                    builder: (context, data, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data['rating']} • ${data['totalTrips']} trips',
                            style: const TextStyle(
                              color:  AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppColors.primary,
              ),
              onPressed: () {
                // Edit profile action using provider
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color:  AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Information', Icons.person),
        Selector<ProfileProvider, Map<String, dynamic>>(
          selector: (_, provider) => {
            'email': provider.driverData['email'],
            'phone': provider.driverData['phone'],
            'memberSince': provider.driverData['memberSince'],
          },
          builder: (context, data, _) {
            return _buildInfoCard([
              _buildInfoRow('Email', data['email'], Icons.email),
              _buildInfoRow('Phone', data['phone'], Icons.phone),
              _buildInfoRow(
                  'Member Since', data['memberSince'], Icons.calendar_today),
            ]);
          },
        ),
      ],
    );
  }

  Widget _buildVehicleInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Vehicle Information', Icons.motorcycle),
        Selector<ProfileProvider, Map<String, dynamic>>(
          selector: (_, provider) => provider.driverData['vehicle'],
          builder: (context, vehicleData, _) {
            return _buildInfoCard([
              _buildInfoRow('Model', vehicleData['model'], Icons.car_rental),
              _buildInfoRow('Year', vehicleData['year'], Icons.date_range),
              _buildInfoRow('Color', vehicleData['color'], Icons.color_lens),
              _buildInfoRow(
                  'License Plate', vehicleData['licensePlate'], Icons.badge),
            ]);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Payment Information', Icons.payment),
        Selector<ProfileProvider, Map<String, dynamic>>(
          selector: (_, provider) => provider.driverData['bankAccount'],
          builder: (context, bankData, _) {
            return _buildInfoCard([
              _buildInfoRow('Bank Account', bankData['accountNumber'],
                  Icons.account_balance),
              _buildInfoRow('Bank Name', bankData['bankName'],
                  Icons.account_balance_wallet),
            ]);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Settings', Icons.settings),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                _buildAvailableForWorkToggle(),
                _buildAutoAcceptOrdersToggle(),
                _buildNotificationsToggle(),
                _buildLocationToggle(),
                _buildDarkModeToggle(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableForWorkToggle() {
    return Selector<ProfileProvider, bool>(
      selector: (_, provider) => provider.availableForWork,
      builder: (context, value, _) {
        return _buildSettingsToggle(
          'Available for Work',
          'Show as available to receive orders',
          value,
          (newValue) {
            Provider.of<ProfileProvider>(context, listen: false)
                .toggleAvailableForWork(newValue);
          },
          Colors.green,
        );
      },
    );
  }

  Widget _buildAutoAcceptOrdersToggle() {
    return Selector<ProfileProvider, bool>(
      selector: (_, provider) => provider.autoAcceptOrders,
      builder: (context, value, _) {
        return _buildSettingsToggle(
          'Auto-Accept Orders',
          'Automatically accept incoming orders',
          value,
          (newValue) {
            Provider.of<ProfileProvider>(context, listen: false)
                .toggleAutoAcceptOrders(newValue);
          },
          Colors.orange,
        );
      },
    );
  }

  Widget _buildNotificationsToggle() {
    return Selector<ProfileProvider, bool>(
      selector: (_, provider) => provider.notificationsEnabled,
      builder: (context, value, _) {
        return _buildSettingsToggle(
          'Push Notifications',
          'Receive notifications about new orders',
          value,
          (newValue) {
            Provider.of<ProfileProvider>(context, listen: false)
                .toggleNotifications(newValue);
          },
          Colors.blue,
        );
      },
    );
  }

  Widget _buildLocationToggle() {
    return Selector<ProfileProvider, bool>(
      selector: (_, provider) => provider.locationEnabled,
      builder: (context, value, _) {
        return _buildSettingsToggle(
          'Location Services',
          'Allow app to access your location',
          value,
          (newValue) {
            Provider.of<ProfileProvider>(context, listen: false)
                .toggleLocation(newValue);
          },
          Colors.purple,
        );
      },
    );
  }

  Widget _buildDarkModeToggle() {
    return Selector<ProfileProvider, bool>(
      selector: (_, provider) => provider.darkModeEnabled,
      builder: (context, value, _) {
        return _buildSettingsToggle(
          'Dark Mode',
          'Switch to dark theme',
          value,
          (newValue) {
            Provider.of<ProfileProvider>(context, listen: false)
                .toggleDarkMode(newValue);
          },
          Colors.blueGrey,
        );
      },
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.circle,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: CupertinoSwitch(
        value: value,
        activeColor: iconColor,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Use provider for logout
          final success =
              await Provider.of<ProfileProvider>(context, listen: false)
                  .logout();
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
            // Navigate to login screen or perform other actions
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
