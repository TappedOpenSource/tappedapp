import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/create_service/create_service_cubit.dart';

class EditServiceButton extends StatelessWidget {
  const EditServiceButton({
    required this.onEdited,
    required this.service,
    super.key,
  });

  final void Function(Service) onEdited;
  final Service service;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateServiceCubit, CreateServiceState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          onPressed: () {
            try {
              context.read<CreateServiceCubit>().edit(
                    service,
                    onEdited,
                  );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                ),
              );
            }
          },
          child: const Text('Edit'),
        );
      },
    );
  }
}
