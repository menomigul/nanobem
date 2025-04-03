%  DEMOSTOKES01 - Stokes drag for ellipsoid.

%  sphere and aspect ratio for ellipsoid
rad = 1;
u = linspace( 0, 2 * pi, 25 );
t = acos( linspace( -1, 1, 60 ) );
p = trispheresegment( u, t, 2 * rad );
e = linspace( 1, 4, 10 );
%  allocate output
[ force, torque, force0, torque0 ] = deal( zeros( numel( e ), 3 ) );

multiWaitbar( 'Stokes drag', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over aspect ratios
for it = 1 : numel( e )
  %  BEM solution of Stokes equation
  drag = tweezer.stokesdrag(  ...
    transform( p, 'scale', [ 1, 1, e( it ) ] ), 'quad', triquad( 3 ) );
  force(  it, : ) = - diag( drag.tt );
  torque( it, : ) = - diag( drag.rr );
  %  analytic solution for ellipsoids
  drag0 = tweezer.dragellipsoid( 2 * rad, e( it ) );
  force0(  it, : ) = - drag0.tt;
  torque0( it, : ) = - drag0.rr;  
  
  multiWaitbar( 'Stokes drag', it / numel( e ) ); 
end
%  close waitbar
multiWaitbar( 'CloseAll' );


%  final plot for force
figure
plot( e, force, 'o-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( e, force0, '+--' );

legend( 'x', 'y', 'z', 'Location', 'NorthWest' );

xlabel( 'Aspect ratio' );
ylabel( 'Force' );

%  final plot for torque
figure
plot( e, torque, 'o-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( e, torque0, '+--' );

legend( 'x', 'y', 'z', 'Location', 'NorthWest' );

xlabel( 'Aspect ratio' );
ylabel( 'Torque' );
