import 'package:flutter/material.dart';
import 'package:schoolmanagementsystem/screens/select_city/select_mode.dart';
import '../../data/storage/hive_storage.dart';
import '../../loginModules/data/localStorage.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../../loginModules/res/imagePaths.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({super.key});

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  String? selectedCity;
  // Only Lucknow is enabled, others are disabled
  final List<Map<String, dynamic>> serviceCities = [
    {
      "name": "Lucknow",
      "enabled": true,
      "description": "Available for service",
      "icon": Icons.location_city,
    },
    {
      "name": "Kanpur",
      "enabled": false,
      "description": "Coming soon",
      "icon": Icons.location_city_outlined,
    },
    {
      "name": "Varanasi",
      "enabled": false,
      "description": "Coming soon",
      "icon": Icons.location_city_outlined,
    },
    {
      "name": "Delhi",
      "enabled": false,
      "description": "Coming soon",
      "icon": Icons.location_city_outlined,
    },
    {
      "name": "Mumbai",
      "enabled": false,
      "description": "Coming soon",
      "icon": Icons.location_city_outlined,
    },
  ];


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.08),

              // Logo + App Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePaths.appLogo, height: 120,width: 96,),
                  const SizedBox(width: 10),
                  const Text(
                    "UPCHAR\nSARTHI",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Subtitle
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Be your own ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "CONCIERGE.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),

              // Title
              const Text(
                "Select Your City",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),

              // Animated City Options
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: serviceCities.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final city = serviceCities[index];
                    final isEnabled = city["enabled"] as bool;
                    final isSelected = city["name"] == selectedCity;

                    return _buildCityCard(
                      context: context,
                      name: city["name"] as String,
                      enabled: isEnabled,
                      description: city["description"] as String,
                      icon: city["icon"] as IconData,
                      isSelected: isSelected,
                      onTap: isEnabled
                          ? () {
                        setState(() {
                          selectedCity = city["name"] as String;
                        });
                      }
                          : null,
                    );
                  },
                ),
              ),

              // Next Button
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedCity == null ? Colors.grey : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black54,
                    ),
                    onPressed: selectedCity == null ? null : () async {
                            await HiveStorage.init();
                            HiveStorage.saveBool(HiveStorage.keySelectCity, true);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Selectmode()));
                          },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildCityCard({
    required BuildContext context,
    required String name,
    required bool enabled,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : enabled
              ? Colors.white
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : enabled
                ? Colors.grey[300]!
                : Colors.grey[200]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            if (enabled && !isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.15)
                      : enabled
                      ? Colors.grey[100]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : enabled
                        ? Colors.red[700]
                        : Colors.grey[400],
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // City name and description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : enabled
                                ? Colors.black
                                : Colors.grey[400],
                          ),
                        ),
                        if (name == "Lucknow") ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Text(
                              "ACTIVE",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.green[700],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : enabled
                            ? Colors.grey[600]
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator or disabled icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                ),
                child: isSelected
                    ? Container(
                  key: const ValueKey("check"),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 18,
                  ),
                )
                    : enabled
                    ? Container(
                  key: const ValueKey("enabled"),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                )
                    : Container(
                  key: const ValueKey("disabled"),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
