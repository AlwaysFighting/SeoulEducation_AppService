import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../../../const/colors.dart';

class KakaoMapView extends StatefulWidget {
  final double deptLat;
  final double deptLng;

  const KakaoMapView({
    Key? key,
    required this.deptLat,
    required this.deptLng,
  }) : super(key: key);

  @override
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 358,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(
          color: mainColor,
          width: 1,
        ),
      ),
      child: KakaoMap(
        currentLevel: 5,
        onMapCreated: ((controller) async {
          mapController = controller;
          markers.add(
            Marker(
              markerId: UniqueKey().toString(),
              latLng: await mapController.getCenter(),
              draggable: true,

            ),
          );
          setState(() {});
        }),
        markers: markers.toList(),
        minLevel: 0,
        maxLevel: 8,
        zoomControl: true,
        center: LatLng(widget.deptLat, widget.deptLng),
      ),
    );
  }
}
