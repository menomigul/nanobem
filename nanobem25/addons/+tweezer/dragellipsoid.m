function drag = dragellipsoid( diameter, ratio )
%  DRAGELLIPSOID - Drag tensor for Stokes flow around ellipsoid.
%
%  Usage :
%    drag = tweezer.dragellipsoid( diameter, ratio )
%  Input
%    diameter   :  diameter for ellipsoid
%    ratio      :  axis ratio
%  Output
%    drag       :  drag tensor for translation and rotation
%  Literature
%    Liu et al., J. Comp. Phys. 228, 3559 (2009).

%  radius of ellipsoid
a = 0.5 * diameter;
%  ratio
if ratio == 1
  e = 1 + 1e-5;
else
  e = ratio;
end
%  auxiliary quantity
tau = sqrt( abs( e ^ 2 - 1 ) );

%  translation
if e >= 1
  tz =  8 * pi * a * tau ^ 3 / ( ( 2 * tau ^ 2 + 1 ) * log( e + tau ) - e * tau );
  tx = 16 * pi * a * tau ^ 3 / ( ( 2 * tau ^ 2 - 1 ) * log( e + tau ) + e * tau );
else
  tz =  8 * pi * a * tau ^ 3 / ( ( 2 * tau ^ 2 - 1 ) * atan( tau / e ) + e * tau );
  tx = 16 * pi * a * tau ^ 3 / ( ( 2 * tau ^ 2 - 1 ) * atan( tau / e ) - e * tau ); 
end

%  rotation
if e >= 1
  rz = 16 / 3 * pi * ( a * tau ) ^ 3 / ( e * tau - log( e + tau ) );
  rx = 16 / 3 * pi * ( a * tau ) ^ 3 *  ...
    ( 1 + e ^ 2 ) / ( ( 2 * tau ^ 2 + 1 ) * log( e + tau ) - e * tau );
else
  rz = 16 / 3 * pi * ( a * tau ) ^ 3 ./ ( atan( tau / e ) - e * tau );
  rx = 16 / 3 * pi * ( a * tau ) ^ 3 .*  ...
    ( 1 + e ^ 2 ) / ( ( 2 * tau ^ 2 - 1 ) * atan( tau / e ) + e * tau );  
end

%  set output
drag = struct( 'tt', - [ tx, tx, tz ], 'rr', - [ rx, rx, rz ] );
