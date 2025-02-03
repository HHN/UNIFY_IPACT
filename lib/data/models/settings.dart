
class CommonSettings {
  String? appTitle;
  String? tagTitle;
  String? companyEmail;
  String? companyAddress;
  String? helpline;
  String? logo;
  String? loginLogo;
  String? landingLogo;
  String? favicon;
  String? copyrightText;
  String? paginationCount;
  String? currency;
  String? lang;
  String? mailDriver;
  String? mailHost;
  String? mailPort;
  String? mailUsername;
  String? mailPassword;
  String? mailEncryption;
  String? mailFromAddress;
  String? defaultCoin;
  String? defaultCurrency;

  CommonSettings({
    this.appTitle,
    this.tagTitle,
    this.companyEmail,
    this.companyAddress,
    this.helpline,
    this.logo,
    this.loginLogo,
    this.landingLogo,
    this.favicon,
    this.copyrightText,
    this.paginationCount,
    this.currency,
    this.lang,
    this.mailDriver,
    this.mailHost,
    this.mailPort,
    this.mailUsername,
    this.mailPassword,
    this.mailEncryption,
    this.mailFromAddress,
    this.defaultCoin,
    this.defaultCurrency,
  });

  factory CommonSettings.fromJson(Map<String, dynamic> json) => CommonSettings(
    appTitle: json["app_title"],
    tagTitle: json["tag_title"],
    companyEmail: json["company_email"],
    companyAddress: json["company_address"],
    helpline: json["helpline"],
    logo: json["logo"],
    loginLogo: json["login_logo"],
    landingLogo: json["landing_logo"],
    favicon: json["favicon"],
    copyrightText: json["copyright_text"],
    paginationCount: json["pagination_count"],
    currency: json["currency"],
    lang: json["lang"],
    mailDriver: json["mail_driver"],
    mailHost: json["mail_host"],
    mailPort: json["mail_port"],
    mailUsername: json["mail_username"],
    mailPassword: json["mail_password"],
    mailEncryption: json["mail_encryption"],
    mailFromAddress: json["mail_from_address"],
    defaultCoin: json["default_coin"],
    defaultCurrency: json["default_currency"],
  );

}

