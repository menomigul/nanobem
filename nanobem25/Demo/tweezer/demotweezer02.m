%  DEMOWEEZER02 - Tweezer simulation for ellipsoidal particle.

%  material properties, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
%  diameter and axis ratio of ellipsoid, wavenumber of light in vacuum
diameter = 300;
ratio = 2;
k0 = 2 * pi / 520;

%  focus lens
NA = 1.0;
lens = optics.lensfocus( mat1, k0, NA, 'nphi', 21, 'ntheta', 20 );
%  incoming fields
e = 2 * normpdf( lens.rho, 0, 1 );
e = e( : ) * [ 1, 0, 0 ];
%  planewave decomposition of focal fields
foc = eval( lens, e );

%  points in xy plane
x = 700 * linspace( -1, 1, 101 );
[ xx, yy ] = ndgrid( x );
%  evaluate fields
e1 = fields( foc, Point( mat1, 1, [ xx( : ), yy( : ), 0 * xx( : ) ] ) );
e2 = fields( foc, Point( mat1, 1, [ xx( : ), 0 * yy( : ), yy( : ) ] ) );

%  plot field in image plane
figure
h1 = subplot( 1, 2, 1 );
imagesc( x, x, reshape( dot( e1, e1, 2 ), size( xx ) ) .' );
hold on

xlabel( 'x (nm)' );
ylabel( 'y (nm)' );
set( gca, 'YDir', 'norm' );
axis equal tight

h2 = subplot( 1, 2, 2 );
imagesc( x, x, reshape( dot( e2, e2, 2 ), size( xx ) ) .' );
hold on

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );
set( gca, 'YDir', 'norm' );
axis equal tight

%  T-matrix for ellipsoid
tmat = multipole.tmatellipsoid( mat2, mat1, diameter, ratio, k0, 'lmax', 10 );
%  scatterer
fun = @( pos, k0 ) fields( foc, Point( mat1, 1, pos ) );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );
%  fluid forces 
fluid = tweezer.fluidellipsoid( diameter, ratio );
%  initial position and time step
pos = [ 0, 0, 0 ];
rot = multipole.rotation( 90, 'order', 'y' );
dt = 3e-5;
%  position of particles
dir = 60 * rot * [ 0, 0; 0, 0; -1, 1 ];
h3 = plot( h1, pos( 1 ) + dir( 1, : ), pos( 2 ) + dir( 2, : ), 'm-', 'LineWidth', 2  );
h4 = plot( h2, pos( 1 ) + dir( 1, : ), pos( 3 ) + dir( 3, : ), 'm-', 'LineWidth', 2  );

%  propagate scatterer in presence of Brownian motion
for it = 1 : 2000
  [ fopt, nopt ] = optforce( scatterer, pos, rot );
  [ pos, rot ] = browniant( fluid, pos, rot, fopt, nopt, dt );
  %  update position of particle
  dir = 60 * rot * [ 0, 0; 0, 0; -1, 1 ];
  set( h3, 'XData', pos( 1 ) + dir( 1, : ), 'YData', pos( 2 ) + dir( 2, : ) );
  set( h4, 'XData', pos( 1 ) + dir( 1, : ), 'YData', pos( 3 ) + dir( 3, : ) );
  
  drawnow
end
