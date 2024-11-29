import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialNetworkIcon {
  Widget resolveIconForNetWorkId(String id) {
    switch (id) {
      case "Facebook":
        return const Icon(
          FontAwesomeIcons.facebook,
          color: Colors.blue,
        );
      case "YouTube":
        return const Icon(
          FontAwesomeIcons.youtube,
          color: Colors.red,
        );
      case "Instagram":
        return const Icon(
          FontAwesomeIcons.instagram,
          color: Color.fromARGB(218, 255, 170, 0),
        );
      case "WhatsApp":
        return const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.green,
        );
      case "TikTok":
        return const Icon(
          FontAwesomeIcons.tiktok,
          color: Colors.black,
        );
      case "Snapchat":
        return const Icon(
          FontAwesomeIcons.snapchat,
          color: Colors.yellow,
        );
      case "Telegram":
        return const Icon(
          FontAwesomeIcons.telegram,
          color: Colors.blue,
        );
      case "Pinterest":
        return const Icon(
          FontAwesomeIcons.pinterest,
          color: Colors.red,
        );
      case "X":
        return const Icon(
          FontAwesomeIcons.x,
          color: Colors.black,
        );

      case "LinkedIn":
        return const Icon(
          FontAwesomeIcons.linkedinIn,
          color: Colors.black,
        );

      case "WeChat":
        return const Icon(
          Icons.wechat_outlined,
          color: Colors.green,
        );

      // case "WeChat":
      //   return const Icon(
      //     FontAwesomeIcons.weCh,
      //     color: Colors.green,
      //   );
      default:
        return const Icon(Icons.link);
    }
  }
}
