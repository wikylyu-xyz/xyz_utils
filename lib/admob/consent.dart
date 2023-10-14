import 'package:google_mobile_ads/google_mobile_ads.dart';

void loadForm() {
  ConsentForm.loadConsentForm(
    (ConsentForm consentForm) async {
      var status = await ConsentInformation.instance.getConsentStatus();
      if (status == ConsentStatus.required) {
        consentForm.show(
          (FormError? formError) {
            loadForm();
          },
        );
      }
    },
    (FormError formError) {},
  );
}

void setConsentEea() {}

loadConsentInfoForm(
    {bool testing = false, List<String> testIdentifiers = const []}) async {
  final ConsentRequestParameters params;
  if (testing) {
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: testIdentifiers,
    );
    params = ConsentRequestParameters(
      consentDebugSettings: debugSettings,
    );
  } else {
    params = ConsentRequestParameters();
  }
  ConsentInformation.instance.requestConsentInfoUpdate(
    params,
    () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        loadForm();
      }
    },
    (FormError error) {},
  );
}
