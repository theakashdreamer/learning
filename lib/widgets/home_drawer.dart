import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/newtwork/network_api_services.dart';
import '../data/storage/hive_storage.dart';
import '../loginModules/data/dataSources/dataBaseHelper.dart';
import '../loginModules/entity/UserDetails.dart';
import '../reports/payment/screen/payment_details_screen.dart';
import '../reports/rides/bloc/ride_history_bloc.dart';
import '../reports/rides/bloc/ride_history_event.dart';
import '../reports/rides/repositories/ride_repository.dart';
import '../reports/rides/screen/ride_history_screen.dart';
import '../routes/routesname.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  UserDetails? userDetails;
  bool isLoading = true;
  final  _apiService = NetworkApiService();
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final details = await DataBaseHelper.getUserDetailsDetails();
    if (mounted) {
      setState(() {
        userDetails = details;
        isLoading = false;
      });
    }
  }
  void clearSqliteDataAndSharePreferences(BuildContext context) async {
    await HiveStorage.init();
    await HiveStorage.clearAllExceptURL();
    await DataBaseHelper.deleteTraineeUserDetails();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          EnhancedProfileHeader(
            userDetails: userDetails,
            onLogoutPressed: () {
              clearSqliteDataAndSharePreferences(context);
              print('Logout pressed');
            },
            onProfilePressed: () {
              print('Profile pressed');
            },
          ),
        buildAction("My Rides", Icons.history, () {
          Navigator.pop(context); // close drawer

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => RideHistoryBloc(
                  rideRepository: MockRideRepository(),
                )..add(LoadRideHistory()), // 👈 called BEFORE screen builds
                child: const RideHistoryScreen(),
              ),
            ),
          );
        }),
        buildAction("Promotions", Icons.card_membership, () {}),
          buildAction("My Favourites", Icons.star_border, () {}),
          buildAction("My payment", Icons.payment, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentDetailsScreen(paymentId: '1'),
              ),
            );
          }),
          buildAction("Notification", Icons.notifications_none, () {}),
          buildAction("Support", Icons.chat_bubble_outline, () {}),
        ],
      ),
    );
  }

  Widget buildAction(String title, IconData iconData, VoidCallback onPressed) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        title,
        style: TextStyle(color: Colors.black45),
      ),
      leading: Icon(
        iconData,
        color: Colors.black,
      ),
    );
  }
}
class EnhancedProfileHeader extends StatefulWidget {
  final UserDetails? userDetails;
  final VoidCallback onLogoutPressed;
  final VoidCallback? onProfilePressed;

  const EnhancedProfileHeader({
    super.key,
    this.userDetails,
    required this.onLogoutPressed,
    this.onProfilePressed,
  });

  @override
  State<EnhancedProfileHeader> createState() => _EnhancedProfileHeaderState();
}

class _EnhancedProfileHeaderState extends State<EnhancedProfileHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLogoutHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLogoutHover(bool isHovered) {
    setState(() {
      _isLogoutHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey[900]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Section
            Expanded(
              child: GestureDetector(
                onTap: widget.onProfilePressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Avatar with Animation
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.2),
                              theme.colorScheme.secondary.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            width: 56,
                            height: 56,
                            color: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Avatar Icon
                                Icon(
                                  Icons.person,
                                  color: theme.colorScheme.primary,
                                  size: 36,
                                ),

                                // Online Status Indicator
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16.0),

                    // User Details
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Name
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.userDetails?.TaineeName ?? "Guest User",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.verified,
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ],
                          ),

                          const SizedBox(height: 4.0),

                          // Mobile Number with Icon
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white.withOpacity(0.6),
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.userDetails?.MobileNo ?? "Not provided",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4.0),

                          // User Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: theme.colorScheme.primary,
                                  size: 10,
                                ),
                                const SizedBox(width: 1),
                                Text(
                                  'Premium Member',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),

            // Logout Button with Enhanced Effects
            MouseRegion(
              onEnter: (_) => _onLogoutHover(true),
              onExit: (_) => _onLogoutHover(false),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _isLogoutHovered
                        ? LinearGradient(
                      colors: [
                        Colors.red[800]!,
                        Colors.red[600]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    border: Border.all(
                      color: _isLogoutHovered
                          ? Colors.red.withOpacity(0.5)
                          : Colors.red.withOpacity(0.8),
                      width: _isLogoutHovered ? 2 : 1.5,
                    ),
                    boxShadow: _isLogoutHovered
                        ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Add haptic feedback
                      HapticFeedback.mediumImpact();

                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(fontSize: 14),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                              ),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onLogoutPressed();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isLogoutHovered
                            ? Icons.logout_rounded
                            : Icons.logout_outlined,
                        key: ValueKey<bool>(_isLogoutHovered),
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    tooltip: 'Logout from account',
                    padding: const EdgeInsets.all(12),
                    splashColor: Colors.red.withOpacity(0.3),
                    splashRadius: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

