import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: squaredButtonStyle,
      onPressed: (){
        launchUrl(
          Uri.parse("https://github.com/sponsors/deadlyunicorn")
        );
      }, 
      child: Text( appLocalizations.settings_supportTheDeveloper ),
    );
  }
}
