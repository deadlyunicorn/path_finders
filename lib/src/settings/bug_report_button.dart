import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/settings/bug_report_dialog.dart';

class BugReportButton extends StatelessWidget {
  const BugReportButton({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: squaredButtonStyle,
      onPressed: (){
        showDialog(
          context: context, 
          builder: (context) => const BugReportDialog()
        );
      }, 
      child: Text( appLocalizations.bugReport )
    );
  }
}
