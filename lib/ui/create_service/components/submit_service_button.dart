import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/create_service/create_service_cubit.dart';

class SubmitServiceButton extends StatelessWidget {
  const SubmitServiceButton({
    required this.onCreated,
    super.key,
  });

  final void Function(Service) onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              await context.read<CreateServiceCubit>().create(onCreated);
            } catch (e) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: const Text('create'),
        );
      },
    );
  }
}
