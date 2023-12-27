import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingViewWithTakingTooLongMessage extends StatelessWidget {
  const LoadingViewWithTakingTooLongMessage({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations? appLocalizations;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed( const Duration( seconds: 3)), 
      builder: ( context, timerFutureSnapshot){
        if ( timerFutureSnapshot.connectionState == ConnectionState.done ){
          return Center ( 
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const CircularProgressIndicator(),
                Positioned(
                  bottom: -75,
                  child: Column(
                    children: [
                      Text( 
                        appLocalizations!.errors_geolocatorTimeout,
                        textAlign: TextAlign.center
                      ),
                    ],
                  )
                )
              ],
            )
          );
        }
        else{
          return const CircularProgressIndicator(); 
        }
      }
    );
  }
}
