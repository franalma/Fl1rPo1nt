const jsonHeaders = {
  'Content-Type': 'application/json', // Define el tipo de contenido como JSON
};

const String _HOST_IP = "192.168.2.206";
const String _DEV_HOST = "http://$_HOST_IP:3000";
const String _DEV_BASE_API_URL = "$_DEV_HOST/api";
const String _DEV_BASE_AUTH_URL = "$_DEV_HOST/auth";
const String SERVER_API = _DEV_BASE_API_URL;
const String SERVER_AUTH = _DEV_BASE_AUTH_URL;

enum HostActions {
  LOGIN("DO_LOGIN", SERVER_AUTH),
  REGISTER("PUT_USER", SERVER_AUTH),
  GET_USER_QR_BY_USER_ID("GET_USER_QR_BY_USER_ID", SERVER_API),
  GET_USER_BY_DISTANCE_FROM_POINT("GET_USER_BY_DISTANCE_FROM_POINT", SERVER_API)

  ; 

  final String action;
  final String url;

  const HostActions(this.action, this.url);
}