const APIKEY = "w3knD4w6gh3lH6ZSVU1Qn9aRLKNgMQUa8YhJZYic";

const jsonHeaders = {
  'Content-Type': 'application/json', // Define el tipo de contenido como JSON
  'x-api-key': APIKEY
};
const HOST_API = {
  "dev_ip": "https://etohps0ija.execute-api.eu-west-3.amazonaws.com/dev",
  "dev_port": 3000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_api": "/api",
};

const HOST_AUTH = {
  "dev_ip": "https://etohps0ija.execute-api.eu-west-3.amazonaws.com/dev",
  "dev_port": 5500,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_login": "/login",
  "endpoint_register": "/register",
};

const HOST_CHAT = {
  "dev_ip": "https://etohps0ija.execute-api.eu-west-3.amazonaws.com/dev/chat",
  "dev_port": 4000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_root": "/base"
};

const HOST_MULT = {
  "dev_ip": "https://etohps0ija.execute-api.eu-west-3.amazonaws.com/dev/mult",
  "dev_port": 7000,
  "pro_ip": "",
  "pro_host": "",
  "endpoint_up_image": "/upload/image",
  "endpoint_up_audio": "/upload/audio",
  "endpoint_sec_images": "/secure-images",
  "endpoint_sec_audios": "/secure-audios",
  "endpoint_root": "/base",
};

const HOST_CHAT_SOCKET = {"dev_ip": "http://15.188.83.61", "dev_port": 8000};

// String BASE_AUTH_URL = "http://${HOST_AUTH["dev_ip"]}:${HOST_AUTH["dev_port"]}";
// String BASE_API_URL = "http://${HOST_API["dev_ip"]}:${HOST_API["dev_port"]}";
// String BASE_MULT_URL = "http://${HOST_MULT["dev_ip"]}:${HOST_MULT["dev_port"]}";
// String BASE_CHAT_URL = "http://${HOST_CHAT["dev_ip"]}:${HOST_CHAT["dev_port"]}";

String BASE_AUTH_URL = "${HOST_AUTH["dev_ip"]}";
String BASE_API_URL = "${HOST_API["dev_ip"]}";
String BASE_MULT_URL = "${HOST_MULT["dev_ip"]}";
String BASE_CHAT_URL = "${HOST_CHAT["dev_ip"]}";
String BASE_CHAT_SOCKET_URL =
    "${HOST_CHAT_SOCKET["dev_ip"]}:${HOST_CHAT_SOCKET["dev_port"]}";

class HostActionsItem {
  String action;
  String _url;
  String path;
  HostActionsItem(this.action, this._url, this.path);
  String build() => _url + path;
}

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

  static final HostActionsItem getActiveFlirtsFromPointAndTendency =
      HostActionsItem("GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY", BASE_API_URL,
          HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllSocialNetworks = HostActionsItem(
      "GET_ALL_SOCIAL_NETWORKS",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getllGenders = HostActionsItem(
      "GET_ALL_GENDERS", BASE_API_URL, HOST_API["endpoint_api"].toString());

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
      "UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID",
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

  // static final HostActionsItem getUserImagesByUserId = HostActionsItem(
  //     "GET_USER_IMAGES_BY_USER_ID",
  //     BASE_API_URL,
  //     HOST_API["endpoint_api"].toString());

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

  static final HostActionsItem putSmartPointByUserIdQrId = HostActionsItem(
      "PUT_SMART_POINT_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateSmartPointStatusByPointId =
      HostActionsItem("UPDATE_SMART_POINT_STATUS_BY_POINT_ID", BASE_API_URL,
          HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateSmartPointStatusByUserId = HostActionsItem(
      "UPDATE_SMART_POINTS_STATUS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllSmartPointsByUserId = HostActionsItem(
      "GET_ALL_SMART_POINTS_BY_USER_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem getSmartPointByPointId = HostActionsItem(
      "GET_SMART_POINTS_BY_POINT_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem deleteSmartPointByPointId = HostActionsItem(
      "REMOVE_SMART_POINT_BY_POINT_ID",
      BASE_API_URL,
      HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateMatchAudioAccessByMatchIdUserId =
      HostActionsItem("UPDATE_MATCH_AUDIO_ACCESS_BY_MATCH_ID_USER_ID",
          BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateMatchPicturesAccessByMatchIdUserId =
      HostActionsItem("UPDATE_MATCH_PICTURE_ACCESS_BY_MATCH_ID_USER_ID",
          BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem getAllSubscriptionTypes =
      HostActionsItem("GET_ALL_SUBSCRIPTION_TYPES",
          BASE_API_URL, HOST_API["endpoint_api"].toString());

  static final HostActionsItem updateSubscription =
      HostActionsItem("UPDATE_USER_SUBSCRIPTION_BY_USER_ID",
          BASE_API_URL, HOST_API["endpoint_api"].toString());
}

class HostMultActions {
  static final HostActionsItem uploadImageByUserId = HostActionsItem(
      "", BASE_MULT_URL, HOST_MULT["endpoint_up_image"].toString());

  static final HostActionsItem uploadAudioByUserId = HostActionsItem(
      "", BASE_MULT_URL, HOST_MULT["endpoint_up_audio"].toString());

  static final HostActionsItem getProtectedImagesUrlsByUserId = HostActionsItem(
      "GET_PROTECTED_IMAGES_URLS_BY_USER_ID",
      BASE_MULT_URL,
      HOST_MULT["endpoint_root"].toString());

  static final HostActionsItem removeUserImagesByUuserIdImageId =
      HostActionsItem("REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID", BASE_MULT_URL,
          HOST_MULT["endpoint_root"].toString());

  static final HostActionsItem getUserAudiosByUserId = HostActionsItem(
      "GET_USER_AUDIOS_BY_USER_ID",
      BASE_MULT_URL,
      HOST_MULT["endpoint_root"].toString());

  static final HostActionsItem removeUserAudioByUserIdAudioId = HostActionsItem(
      "REMOVE_USER_AUDIO_BY_USER_ID_AUDIO_ID",
      BASE_MULT_URL,
      HOST_MULT["endpoint_root"].toString());

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

  static final HostActionsItem removePendingMessagesByUserIdContactId =
      HostActionsItem("REMOVE_PENDING_CHAT_MESSGES_BY_USER_ID_SENDER_ID",
          BASE_CHAT_URL, HOST_CHAT["endpoint_root"].toString());

  static final HostActionsItem socketListen =
      HostActionsItem("", BASE_CHAT_SOCKET_URL, "");
}
