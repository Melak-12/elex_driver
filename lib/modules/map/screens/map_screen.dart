import 'package:elex_driver/modules/map/screens/slide_to_complete.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/core/keys/mapbox_token.dart';
import 'package:elex_driver/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapProvider? mapProvider;

  @override
  void initState() {
    super.initState();
    mapProvider = Provider.of<MapProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(mapboxToken);

    // Calculate midpoint
    double midLng = (mapProvider!.pickupPoint.coordinates.lng +
            mapProvider!.destinationPoint.coordinates.lng) /
        2;
    double midLat = (mapProvider!.pickupPoint.coordinates.lat +
            mapProvider!.destinationPoint.coordinates.lat) /
        2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ongoing order",
          style: AppTextStyles.headline2,
        ),
        leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
              size: 17,
            )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Map Widget
            Selector<MapProvider, MapboxMap?>(
              selector: (_, mapProvider) => mapProvider.mapboxMap,
              builder: (_, mapboxMap, child) {
                if (mapboxMap == null) {
                  // return const Center(child: CircularProgressIndicator());
                }

                return MapWidget(
                  key: const ValueKey("mapWidget"),
                  onMapCreated: mapProvider?.onMapCreated,
                  cameraOptions: CameraOptions(
                    center: Point(coordinates: Position(midLng, midLat)),
                    zoom: 11.0,
                  ),
                );
              },
            ),

            // Delivery Info Container
            Positioned(
              top: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF663399),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on,
                              size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Arada, Addis Ababa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Customer waiting for delivery',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer,
                                  size: 16, color: Color(0xFF663399)),
                              const SizedBox(width: 4),
                              const Text(
                                '2:00:34',
                                style: TextStyle(
                                  color: Color(0xFF663399),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Fee',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      size: 18, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text(
                                    '250.00 ETB',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Arrival',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 18, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text(
                                    '15 minutes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Slide to Complete Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SlideToCompleteButton(
                onCompleted: () => context.push('/layout'),
                text: 'Slide to Complete Delivery',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
