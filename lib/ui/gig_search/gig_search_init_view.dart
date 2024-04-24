import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';

class GigSearchInitView extends StatelessWidget {
  const GigSearchInitView({super.key});

  Widget _buildItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'find the right venues for your sound!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 36),
              _buildItem(
                icon: CupertinoIcons.search,
                label: 'discover ideal stages effortlessly.',
              ),
              const SizedBox(height: 24),
              _buildItem(
                icon: CupertinoIcons.star,
                label: 'connect with diverse venues.',
              ),
              const SizedBox(height: 24),
              _buildItem(
                icon: CupertinoIcons.bell,
                label: 'get notified when new gigs are available.',
              ),
              const SizedBox(height: 24),
              _buildItem(
                icon: CupertinoIcons.arrow_up,
                label: 'elevate your music career!',
              ),
              const SizedBox(height: 24),
              const Text(
                '(this is experimental)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      onPressed: () => context.push(
                        GigSearchPage(),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "let's do it",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            CupertinoIcons.arrow_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
