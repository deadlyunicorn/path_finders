import 'package:flutter_test/flutter_test.dart';
import 'package:path_finders/src/types/coordinates.dart';

import 'dart:math' as math;

void main(){

  const double pi = math.pi;
  final Coordinates centerOfEarth = Coordinates( 0, 0 );
  final north = Coordinates( 20, 0);
  final east = Coordinates( 0, 20);
  final easternMost = Coordinates( 0, 170);
  final south = Coordinates( -20, 0);
  final west = Coordinates( 0, -20 );
  final westernMost = Coordinates( 0, -170 );
  final northEast = Coordinates( 20, 20);
  final southEast = Coordinates( -20, 20);
  final southWest = Coordinates( -20, -20);
  final northWest = Coordinates( 20, -20);

  group( "Tests from the center of earth", () { 

    Coordinates currentPosition = centerOfEarth;

    test( 'Should get 0 rads for centerOfEarth ',(){
      expect( currentPosition.getRotationFromNorthTo( centerOfEarth ), 0);
    });

    test( 'Should get 0 rads for North',(){
      expect( currentPosition.getRotationFromNorthTo( north ), 0);
    });

    test( 'Should get π/2 rads for East',(){
      expect( currentPosition.getRotationFromNorthTo( east ), pi / 2 );
    });

    test( 'Should get π rads for South',(){
      expect( currentPosition.getRotationFromNorthTo( south ), pi );
    });

    test( 'Should get -π/2 rads for West close to center',(){
      expect( currentPosition.getRotationFromNorthTo( west ), -pi/2 );
    });

    test( 'Should get π/4 rads for NorthEast',(){
      expect( currentPosition.getRotationFromNorthTo( northEast ), pi / 4 );
    });

    test( 'Should get π - π/4 rads for SouthEast',(){
      expect( currentPosition.getRotationFromNorthTo( southEast ), pi -  pi / 4 );
    });

    test( 'Should get -π + π/4 rads for SouthWest',(){
      expect( currentPosition.getRotationFromNorthTo( southWest ), -pi + pi / 4 );
    });

    test( 'Should get -π/4 rads for NorthWest',(){
      expect( currentPosition.getRotationFromNorthTo( northWest ), -pi / 4 );
    });

  });
  group( "Tests from the EasternMost", () { 


    Coordinates currentPosition = easternMost;

    test( 'Should get -π/2 rads for centerOfEarth ',(){
      expect( currentPosition.getRotationFromNorthTo( centerOfEarth ), -pi/2 );
    });

    test( 'Should get -π/2 for East (closer to center)',(){
      expect( currentPosition.getRotationFromNorthTo( east ), -pi / 2 );
    });

    test( 'Should get π/2 rads for West',(){
      expect( currentPosition.getRotationFromNorthTo( west ),  pi / 2 );
    });


  });

  group( "Tests from the WesternMost", () { 


    Coordinates currentPosition = westernMost;

    test( 'Should get π/2 rads for centerOfEarth ',(){
      expect( currentPosition.getRotationFromNorthTo( centerOfEarth ), pi/2 );
    });

    test( 'Should get π/2 for West (closer to center)',(){
      expect( currentPosition.getRotationFromNorthTo( west ), pi / 2 );
    });

    test( 'Should get -π/2 rads for East',(){
      expect( currentPosition.getRotationFromNorthTo( east ),  -pi / 2 );
    });


  });


  


}