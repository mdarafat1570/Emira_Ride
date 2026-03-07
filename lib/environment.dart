class Environment {
  // 🔧 APP CONFIG
  static const String appName = 'NMC rider';
  static const String version = '1.0.0';
  static String defaultLangCode = "en";
  static String defaultLanguageName = "English";
  static const String baseCurrency = "৳"; // Bangladesh currency symbol

  // 🔐 LOGIN AND REG PART
  static const int otpResendSecond = 120; // OTP resend wait time
  static const String defaultCountryCode = 'BD'; // ISO country code for Bangladesh
  static const String defaultDialCode = '880';   // Dial code for Bangladesh
  static const String defaultCountry = 'Bangladesh';

  // 🗺️ MAP CONFIG
  static const bool addressPickerFromMapApi = true;

  static const String mapKey = "AIzaSyBCY8kyLw0CuasykUITALBvQzDmYIuEHV8";
  static const double mapDefaultZoom = 16;
  static const String devToken = "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG";
}
