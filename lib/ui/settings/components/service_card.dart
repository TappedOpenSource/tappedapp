import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        ServicePage(
          service: service,
          serviceUser: const None<UserModel>(),
        ),
      ),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.work,
                  size: 50,
                  // color: Colors.blue,
                ),
                Text(
                  service.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // color: Colors.blue,
                  ),
                ),
                // Text(
                //   service.description,
                //   textAlign: TextAlign.center,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: const TextStyle(
                //     color: Colors.blue,
                //     fontSize: 10,
                //   ),
                // ),
                Text(
                  // ignore: lines_longer_than_80_chars
                  '\$${(service.rate / 100).toStringAsFixed(2)}${service.rateType == RateType.hourly ? '/hr' : ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    // color: Colors.blue,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                CupertinoButton(
                  onPressed: () => context.push(ServicePage(
                    service: service,
                    serviceUser: const None<UserModel>(),
                  ),),
                  child: const Text('More Info'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
