import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, bool>(
      builder: (context, isDark) {
        return CupertinoSlidingSegmentedControl(
          groupValue: isDark,
          // backgroundColor: Colors.grey[300]!,
          // backgroundColor: Theme.of(context).colorScheme.surface,
          // thumbColor: Colors.blue.withOpacity(0.2),
          onValueChanged: (bool? value) {
            context
                .read<AppThemeCubit>()
                .updateTheme(isDarkMode: value ?? true);
          },
          children: const {
            false: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    FontAwesomeIcons.solidSun,
                    // color: tappedAccent,
                  ),
                  Text(
                    'light',
                    style: TextStyle(
                      // color: tappedAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            true: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    FontAwesomeIcons.solidMoon,
                    // color: tappedAccent,
                  ),
                  Text(
                    'dark',
                    style: TextStyle(
                      // color: tappedAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          },
          // value: isDark,
          // onChanged: (val) {
          //   context.read<AppThemeCubit>().updateTheme(val);
          // },
        );
      },
    );
  }
}
