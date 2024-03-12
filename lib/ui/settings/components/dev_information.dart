import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/safety_mode_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevInformation extends StatefulWidget {
  const DevInformation({super.key});

  @override
  State<DevInformation> createState() => _DevInformationState();
}

class _DevInformationState extends State<DevInformation> {
  String _appName = '';
  String _version = '';
  String _buildNumber = '';
  int _tapCount = 0;

  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SafetyModeCubit, bool>(
      builder: (context, isSafe) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _tapCount++;
            });

            if (_tapCount == 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: !isSafe
                      ? Colors.green
                      : Colors.red,
                  content: Text(
                    !isSafe
                        ? 'Safety Mode is ON'
                        : 'Safety Mode is OFF',
                  ),
                ),
              );
              context.read<SafetyModeCubit>().toggleSafetyMode();
              _tapCount = 0;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon_1024.png',
                scale: 15,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _appName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Version $_version+$_buildNumber',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Copyright © Tapped ${DateTime.now().year}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
