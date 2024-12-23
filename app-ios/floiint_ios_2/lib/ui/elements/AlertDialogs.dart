import 'package:app/app_localizations.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlertDialogs {
  void showAlertNewContactAdded(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("new_contact")),
          content: Text('Se ha añadido a $message a tus contactos'),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("ok")),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogEdit(BuildContext context, String initValue, String title,
      String inputHint, Function(String) callback) {
    TextEditingController _controller = TextEditingController();
    _controller.text = initValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: inputHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                callback("");
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate("cancel")),
            ),
            TextButton(
              onPressed: () {
                callback(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate("ok")),
            ),
          ],
        );
      },
    );
  }

  void showCustomModalDialog(
      BuildContext context, String name, String urlImage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circle Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  urlImage, // Replace with your image URL
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                '¡Nuevo contacto!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                "Ahora $name forma parte de tus contatos",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Close Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  // The image
                  InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showPolishedImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Dim background for better focus
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Interactive image viewer
                    InteractiveViewer(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 50),
                          );
                        },
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  void buildLoadingModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(), // Spinner
          ),
        );
      },
    );
  }

  void showModalDialogMessage(
      BuildContext context,
      double heightSize,
      IconData icon,
      double iconSize,
      Color color,
      String message,
      TextStyle textStyle,
      String buttonText,
      [dynamic screen]) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: heightSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize, color: color),
                  Text(
                    message,
                    style: textStyle,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (screen == null) {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      } else {
                        NavigatorApp.pushAndRemoveUntil(context, screen);
                      }
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ]);
        });
  }
}
