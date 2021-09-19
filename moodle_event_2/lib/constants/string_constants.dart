class StringConstants {
  static const String MOODLE_AUTH_URL =
      "https://cclms.kyoto-su.ac.jp/auth/shibboleth/";

  static const String MOODLE_URL = "https://cclms.kyoto-su.ac.jp/";

  static final RegExp GAKUNIN_REG_EXP = new RegExp(
      r"https://gakunin.kyoto-su.ac.jp/idp/profile/SAML2/Redirect/SSO\?execution=e[0-9]+s[0-9]+.?");

  static final RegExp MOODLE_REG_EXP =
      new RegExp(r"https://cclms.kyoto-su.ac.jp/?");
}
