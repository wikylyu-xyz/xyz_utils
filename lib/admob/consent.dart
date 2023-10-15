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

void resetConsentInfo() {
  ConsentInformation.instance.reset();
}

void loadConsentInfoForm({
  List<String> testIdentifiers = const [],
  bool? children,
}) {
  ConsentDebugSettings debugSettings = ConsentDebugSettings(
    debugGeography: DebugGeography.debugGeographyEea,
    testIdentifiers: testIdentifiers,
  );
  final params = ConsentRequestParameters(
    consentDebugSettings: debugSettings,
    tagForUnderAgeOfConsent: children,
  );

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
