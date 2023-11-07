import 'package:flutter_test/flutter_test.dart';
import 'package:path_finders/src/types/coordinates.dart';

import 'dart:math' as math;

void main(){

  double pi = math.pi;
  test( 'Should get 0 rads for North',(){
    final north = Coordinates( 20, 0);
    expect( north.getRotationFromNorth(), 0);
  });

  test( 'Should get π/2 rads for East',(){
    final east = Coordinates( 0, 20);
    expect( east.getRotationFromNorth(), pi / 2 );
  });

  test( 'Should get π rads for South',(){
    final south = Coordinates( -20, 0);
    expect( south.getRotationFromNorth(), pi );
  });

  test( 'Should get -π/2 rads for West',(){
    final west = Coordinates( 0, -20 );
    expect( west.getRotationFromNorth(), -pi/2 );
  });

  test( 'Should get π/4 rads for NorthEast',(){
    final northEast = Coordinates( 20, 20);
    expect( northEast.getRotationFromNorth(), pi / 4 );
  });

  test( 'Should get π - π/4 rads for SouthEast',(){
    final southEast = Coordinates( -20, 20);
    expect( southEast.getRotationFromNorth(), pi -  pi / 4 );
  });

  test( 'Should get -π + π/4 rads for SouthWest',(){
    final southWest = Coordinates( -20, -20);
    expect( southWest.getRotationFromNorth(), -pi + pi / 4 );
  });

  test( 'Should get -π/4 rads for NorthWest',(){
    final southWest = Coordinates( 20, -20);
    expect( southWest.getRotationFromNorth(), -pi / 4 );
  });


  


}