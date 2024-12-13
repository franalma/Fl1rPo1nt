import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class FlirtPoint {
  Widget build(double width, double height, double radius, Color sexAltColor,
      Color relationshipColor) {
    return SizedBox(
        width: width, // Width of the circle
        height:
            height, // Height of the circle (same as width for a perfect circle)
        child: Stack(
          children: [
            Container(
              width: width / 2,
              decoration: BoxDecoration(
                color: sexAltColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                ),
              ),
            ),
            // Second half color
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: width / 2, // Half the total width
                decoration: BoxDecoration(
                  color: relationshipColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

Future<BitmapDescriptor> getBitmapDescriptorFromWidget(Widget widget) async {
    // Create a PictureRecorder to capture the widget rendering
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Create a RenderRepaintBoundary
    final Size logicalSize = const Size(150, 60); // Adjust size based on your widget
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final RenderView renderView = RenderView(
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: boundary,
      ),
       configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints(maxHeight: logicalSize.height, maxWidth: logicalSize.width),
        devicePixelRatio: ui.window.devicePixelRatio,
      ),
      view: WidgetsBinding.instance.window,
    );

    // Attach and layout the widget
    renderView.attach(PipelineOwner());
    renderView.layout(BoxConstraints.tight(logicalSize));

    // Paint the widget into a Canvas
    final BuildOwner buildOwner = BuildOwner();
    final RenderObjectToWidgetAdapter adapter = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: widget,
    );
    adapter.attachToRenderTree(buildOwner);

    // Capture the image as a ByteData
    await Future.delayed(const Duration(milliseconds: 50)); // Allow rendering to complete
    final ui.Image image = await pictureRecorder.endRecording().toImage(
          logicalSize.width.toInt(),
          logicalSize.height.toInt(),
        );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Convert ByteData to BitmapDescriptor
    if (byteData == null) {
      throw Exception("Unable to generate ByteData for widget rendering");
    }
    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }


  
}
