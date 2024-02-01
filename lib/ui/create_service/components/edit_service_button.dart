import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/create_service/create_service_cubit.dart';

class EditServiceButton extends StatelessWidget {
  const EditServiceButton({
    required this.onEdited,
    required this.service,
    this.label = 'Save',
    super.key,
  });

  final String label;
  final void Function(Service) onEdited;
  final Service service;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
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
          borderRadius: BorderRadius.circular(15),
          child: Text(
            label,

            style: TextStyle(
              color: onSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
