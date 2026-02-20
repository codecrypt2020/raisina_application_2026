class Constants {
  //String for identifying dev build or prod build.
  //Prod environment
  // static String NODE_URL = 'https://raisina-orfonline.com/';
  // static String IMG_BASE_N_URL = 'https://adminmisafe.in:3004/';
  // static String NODE_URL_FORGOT_PASSWORD = "https://misafeadmin.in";
  // static const String env = "Production";

//DEV
  static const String NODE_URL = 'https://devapi.raisina-orfonline.com/';
  static const String registraionUrl =
      "https://dev.raisina-orfonline.com/new-registration";
  static const String env = "Development";
  static const String forgetPassUrl =
      "https://dev.raisina-orfonline.com/forgot-pass";

//Prod
  // static const String NODE_URL = "https://raisina-orfonline.com:3000/";
  // static const String registraionUrl =
  //     "https://raisina-orfonline.com/#/new-registration";
  // static const String env = "Production";

  static const String login = "users/login";
  static const String assignedUserDetails = "qr/assignedUserDetials";
  static const String eventStartDate = "registration/event-start-date";
  static const String getAgenda = "registration/get-agenda";
  static const String getdining = "registration/dining";
  static const String assignedUserspeakingDetails =
      "speaking/assignedUserDetials";
  static const String allresourcesapi = "qr/resources/all-resources";
  static const String get_user_qr = "qr/user_list";
  static const String userProfileApi = "userinfo/profile";
}
