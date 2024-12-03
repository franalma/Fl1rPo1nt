const jsonHeaders = {
  'Content-Type': 'application/json', // Define el tipo de contenido como JSON
};
const HOST_API = {
  "dev_ip": "192.168.2.206",
  "dev_port": 3000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_api": "/api",
};

const HOST_AUTH = {
  "dev_ip": "192.168.2.206",
  "dev_port": 5500,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_login": "/login",
  "endpoint_register": "/register",
};

const HOST_CHAT = {
  "dev_ip": "192.168.2.206",
  "dev_port": 4000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_root": "/"
};

const HOST_MULT = {
  "dev_ip": "192.168.2.206",
  "dev_port": 7000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_up_image": "/upload/image",
  "endpoint_up_audio": "/upload/audio",
  "endpoint_sec_images": "/secure-images",
  "endpoint_sec_audios": "/secure-audios",
};

String BASE_AUTH_URL = "http://${HOST_AUTH["dev_ip"]}:${HOST_AUTH["dev_port"]}";
String BASE_API_URL = "http://${HOST_API["dev_ip"]}:${HOST_API["dev_port"]}";
String BASE_MULT_URL = "http://${HOST_MULT["dev_ip"]}:${HOST_MULT["dev_port"]}";
String BASE_CHAT_URL = "http://${HOST_CHAT["dev_ip"]}:${HOST_CHAT["dev_port"]}";

// const String _DEV_HOST = "http://$_DEV_HOST_IP:3000";
// const String _HOST = _DEV_HOST;

// const String BASE_API_URL = "$_HOST/api";
// const String BASE_AUTH_URL = "$_HOST/auth";
// const String BASE_UPLOAD_IMAGE_URL = "$_HOST/upload/image";
// const String BASE_UPLOAD_AUDIO_URL = "$_HOST/upload/audio";
// const String BASE_PROTECTED_IMAGE_URL = "$_HOST/protected-image";

// const String SERVER_API = BASE_API_URL;
// const String SERVER_AUTH = BASE_AUTH_URL;
// const String SERVER_UPLOAD_IMAGE = BASE_UPLOAD_IMAGE_URL;
// const String SERVER_UPLOAD_AUDIO = BASE_UPLOAD_AUDIO_URL;

class HostActionsItem {
  String action;
  String _url;
  String path;
  HostActionsItem(this.action, this._url, this.path);
  String build() => _url + path;
}

// final HostActionsItem Login = HostActionsItem(
//     "LOGIN", BASE_AUTH_URL, HOST_AUTH["endpoint_login"].toString());

class HostAuthActions {
  static final HostActionsItem login = HostActionsItem(
      "LOGIN", BASE_AUTH_URL, HOST_AUTH["endpoint_login"].toString());

  static final HostActionsItem register = HostActionsItem(
      "REGISTER", BASE_AUTH_URL, HOST_AUTH["endpoint_register"].toString());
}

class HostApiActions {
  static final HostActionsItem getUserQrByUserId = HostActionsItem(
      "GET_USER_QR_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getUserByDistanceFromPoint = HostActionsItem(
      "GET_USER_BY_DISTANCE_FROM_POINT",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllSocialNetworks = HostActionsItem(
      "GET_ALL_SOCIAL_NETWORKS",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getllGenders = HostActionsItem(
      "GET_ALL_GENDERSP", BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserNetworkByUserId = HostActionsItem(
      "UPDATE_USER_NETWORK_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserInterestsByUserId = HostActionsItem(
      "UPDATE_USER_INTERESTS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllSexualOrientationsRelationships =
      HostActionsItem("GET_ALL_SEXUAL_ORIENTATIONS_RELATIONSHIPS", BASE_API_URL,
          HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllUserMatchsByUserId = HostActionsItem(
      "GET_ALL_USER_MATCHS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserQrsByUserId = HostActionsItem(
      "UPDATE_USER_QRS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserSearchingRangeByUserId =
      HostActionsItem("UPDATE_USER_SEARCHING_RANGE_BY_USER_ID", BASE_API_URL,
          HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserNameByUserId = HostActionsItem(
      "UPDATE_USER_NAME_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserRadioVisibility = HostActionsItem(
      "UPDATE_USER_RADIO_VISIBILITY",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserGenderByUserId = HostActionsItem(
      "UPDATE_USER_GENDER_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserDefaultQrByUserId = HostActionsItem(
      "UPDATE_USER_DEFAULT_QR_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserImageProfileByUserId = HostActionsItem(
      "UPDATE_USER_IMAGE_PROFILE_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem putUserLocationByUserFlirt = HostActionsItem(
      "PUT_USER_LOCATION_BY_USER_FLIRT",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem putUserFlirtByUserId = HostActionsItem(
      "PUT_USER_FLIRT_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserFlirtByUserIdFlirtId = HostActionsItem(
      "UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getUserFlirts = HostActionsItem(
      "GET_USER_FLIRTS", BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem putUserContactByUserIDContactIdQrId =
      HostActionsItem("PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID",
          BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem getUserImagesByUserId = HostActionsItem(
      "GET_USER_IMAGES_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getUserAudiosByUserId = HostActionsItem(
      "GET_USER_AUDIOS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem removeUserImagesByUuserIdImageId =
      HostActionsItem("REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID", BASE_API_URL,
          HOST_API["endpoint_api"].toString());

  static final HostActionsItem removeUserAudioByUserIdAudioId = HostActionsItem(
      "REMOVE_USER_AUDIO_BY_USER_ID_AUDIO_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateBiographyByUserId = HostActionsItem(
      "UPDATE_USER_BIOGRAPHY_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateUserHobbiesByUserId = HostActionsItem(
      "UPDATE_USER_HOBBIES_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllHobbies = HostActionsItem(
      "GET_ALL_HOBBIES", BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem disableMatchByMatchIdUserId = HostActionsItem(
      "DISABLE_MATCH_BY_MATCH_ID_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getUserPublicProfileByUserId = HostActionsItem(
      "GET_USER_PUBLIC_PROFILE_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());
}

class HostMultActions {
  static final HostActionsItem uploadImageByUserId = HostActionsItem(
      "", BASE_MULT_URL, HOST_MULT["endpoint_up_image"].toString());

  static final HostActionsItem uploadAudioByUserId = HostActionsItem(
      "", BASE_MULT_URL, HOST_MULT["endpoint_up_audio"].toString());

  static final HostActionsItem getProtectedImagesUrlsByUserId = HostActionsItem(
      "GET_PROTECTED_IMAGES_URLS_BY_USER_ID",
      BASE_MULT_URL,
      HOST_MULT["endpoint_sec_images"].toString());

  //  static final HostActionsItem getProtectedImagesUrlsByUserId = HostActionsItem(
  // "GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID", BASE_MULT_URL, HOST_MULT["endpoint_sec_images"].toString());
}

class HostChatActions {
  // SOCKET_LISTEN("", "_HOST"),
  static final HostActionsItem getChatRoomMessagesByMatchId = HostActionsItem(
      "GET_CHATROOM_MESSAGES_BY_MATCH_ID",
      BASE_CHAT_URL,
      HOST_CHAT["endpoint_root"].toString());

  static final HostActionsItem deleteChatRoomFromMatchIdUserId =
      HostActionsItem("DELETE_CHATROOM_FROM_MATCH_ID_USER_ID", BASE_CHAT_URL,
          HOST_CHAT["endpoint_root"].toString());

  static final HostActionsItem putMessageToUserWithUserId = HostActionsItem(
      "PUT_MESSAGE_TO_USER_WITH_USER_ID",
      BASE_CHAT_URL,
      HOST_CHAT["endpoint_root"].toString());

  static final HostActionsItem socketListen =
      HostActionsItem("", BASE_CHAT_URL, "");
}

// enum HostActions {
  



//   GET_PROTECTED_IMAGES_URLS_BY_USER_ID(
//       "GET_PROTECTED_IMAGES_URLS_BY_USER_ID", "SERVER_API"),
//   GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID(
//       "GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID", "SERVER_API"),
//   ;

//   final String action;
//   final String url;

//   const HostActions(this.action, this.url);
// }
