import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/ui/search/components/location_card.dart';

class LocationDiscoverView extends StatelessWidget {
  const LocationDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            LocationCard(
              title: 'New York',
              image: AssetImage('assets/newyork.png'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJOwg_06VPwokRYv534QaPC8g',
                primaryText: 'New York',
                secondaryText: 'New York, USA',
                fullText: 'New York City, New York, USA',
              ),
            ),
            SizedBox(height: 20),
            LocationCard(
              title: 'Richmond',
              image: AssetImage('assets/richmond.png'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJ7cmZVwkRsYkRxTxC4m0-2L8',
                primaryText: 'Richmond',
                secondaryText: 'Virginia, USA',
                fullText: 'Richmond, Virginia, USA',
              ),
            ),
            SizedBox(height: 20),
            LocationCard(
              title: 'Washington DC',
              image: AssetImage('assets/washingtondc.png'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJW-T2Wt7Gt4kRmKFUAsCO4tY',
                primaryText: 'Washington DC',
                secondaryText: 'USA',
                fullText: 'Washington DC, USA',
              ),
            ),
            SizedBox(height: 20),
            LocationCard(
              title: 'Atlanta',
              image: AssetImage('assets/atlanta.jpg'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJjQmTaV0E9YgRC2MLmS_e_mY',
                primaryText: 'Atlanta',
                secondaryText: 'Georgia, USA',
                fullText: 'Atlanta, Georgia, USA',
              ),
            ),
            SizedBox(height: 20),
            LocationCard(
              title: 'Barcelona',
              image: AssetImage('assets/barcelona.png'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJ5TCOcRaYpBIRCmZHTz37sEQ',
                primaryText: 'Barcelona',
                secondaryText: 'España',
                fullText: 'Barcelona, España',
              ),
            ),
            SizedBox(height: 20),
            LocationCard(
              title: 'Los Angeles',
              image: AssetImage('assets/losangeles.png'),
              prediction: AutocompletePrediction(
                placeId: 'ChIJE9on3F3HwoAR9AhGJW_fL-I',
                primaryText: 'Los Angeles',
                secondaryText: 'California, USA',
                fullText: 'Los Angeles, California, USA',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
