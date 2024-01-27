import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';

class CreateServiceButton extends StatelessWidget {
  const CreateServiceButton({
    required this.onCreated,
    super.key,
  });

  final void Function(Service) onCreated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          CreateServicePage(
            onSubmit: onCreated,
            service: const None(),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.add,
              size: 35,
              color: Colors.grey.shade800,
            ),
            Text(
              'Add Service',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
