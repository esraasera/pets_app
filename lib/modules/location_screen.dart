import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_pets/layout/cubit/cubit.dart';
import 'package:your_pets/layout/cubit/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:your_pets/styles/colors.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.get(context);
    appCubit.initializeMap();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) { },
      builder: (BuildContext context, AppStates state) {
        if (state is LocationLoading) {
          return Scaffold(
            body: Stack(
              children: [
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: defaultColor,
                        ),
                        const SizedBox(
                            width: 10
                        ),
                        const Text(
                            "Getting vet clinics..."
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }else if (state is LocationLoaded) {
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  markers: state.markers.toSet(),
                  mapType: MapType.normal,
                  initialCameraPosition: state.cameraPosition,
                ),
              ],
            ),
          );
        }else if (state is LocationError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text("No data available."),
          ),
        );
      },
    );
  }
}