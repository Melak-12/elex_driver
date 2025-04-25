import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/modules/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bodyColor,
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: const Text(
            'Profile',
            style: AppTextStyles.headline2,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Selector<ProfileProvider, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                    color: AppColors.primary,
                  ),
                );
              }
              return child!;
            },
            child: Selector<ProfileProvider, String?>(
              selector: (_, provider) => provider.error,
              builder: (context, error, child) {
                if (error != null) {
                  return Center(child: Text(error));
                }
                return child!;
              },
              child: Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  final profile = provider.profile;
                  if (profile == null) {
                    return const Center(child: Text('No profile data found'));
                  }
                  return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF663399),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary2,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${profile.totalDeliveries} Total Delivery',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  profile.name,
                                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.bodyColor),
                                ),
                                Text(
                                  profile.email,
                                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.bodyColor),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 120,
                            right: 50,
                            left: 50,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://ntrepidcorp.com/wp-content/uploads/2016/06/team-1-640x640.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vehicle Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      _buildInfoRow(
                                          'Model', profile.vehicleType),
                                      const Divider(),
                                      _buildInfoRow('Year', '2024'),
                                      const Divider(),
                                      _buildInfoRow('Number Plate',
                                          profile.vehicleNumber),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Setting',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Available For Work',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Show as available to receive orders',
                                                  style:
                                                      AppTextStyles.bodyText1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          provider.isUpdating
                                              ? const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    radius: 10,
                                                    color: Color(0xFF663399),
                                                  ),
                                                )
                                              : Switch(
                                                  focusColor: AppColors.primary,
                                                  // activeTrackColor: AppColors.primary,
                                                  inactiveTrackColor:
                                                      Colors.grey,
                                                  // thumbColor: MaterialStateProperty.all(Colors.red),
                                                  value: profile.isOnline,
                                                  onChanged: (value) {
                                                    provider
                                                        .toggleOnlineStatus();
                                                  },
                                                  activeColor:
                                                      const Color(0xFF663399),
                                                ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final isLoggingOut = context
                                                .read<ProfileProvider>()
                                                .isLoggingOut;
                                            if (!isLoggingOut) {
                                              await context
                                                  .read<ProfileProvider>()
                                                  .logout();
                                              if (mounted) {
                                                context.go('/login');
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child:
                                              Selector<ProfileProvider, bool>(
                                            selector: (_, provider) =>
                                                provider.isLoggingOut,
                                            builder:
                                                (context, isLoggingOut, child) {
                                              return isLoggingOut
                                                  ? const CupertinoActivityIndicator(
                                                      radius: 10)
                                                  : const Text(
                                                      'Log out',
                                                      style: AppTextStyles
                                                          .buttonText,
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Icon(
            label == 'Model'
                ? Icons.motorcycle
                : label == 'Year'
                    ? Icons.calendar_today
                    : Icons.confirmation_number,
            size: 25,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyText1.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.headline2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
