%  DEMOWEEZER01 - Tweezer simulation for spherical particle.

%  material properties, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
%  diameter of sphere and wavenumber of light in vacuum
diameter = 400;
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

%  T-matrix for sphere
tmat = multipole.tmatsphere( mat2, mat1, diameter, k0 );
%  scatterer
fun = @( pos, k0 ) fields( foc, Point( mat1, 1, pos ) );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );

% x = 700 * linspace( 0, 1, 21 );
% scatterer = griddedscatterer( scatterer, x, x );
%  fluid forces 
fluid = tweezer.fluidsphere( diameter );
%  initial position and time step
pos = [ 0, 0, 0 ];
dt = 3e-5;
%  position of particles
h3 = plot( h1, pos( 1 ), pos( 2 ), 'mo', 'MarkerSize', 5, 'MarkerFaceColor', 'm' );
h4 = plot( h2, pos( 1 ), pos( 3 ), 'mo', 'MarkerSize', 5, 'MarkerFaceColor', 'm' );

%  propagate scatterer in presence of Brownian motion
for it = 1 : 400
  fopt = optforce( scatterer, pos );
  pos = browniant( fluid, pos, fopt, dt );
  %  update position of particle
  set( h3, 'XData', pos( 1 ), 'YData', pos( 2 ) );
  set( h4, 'XData', pos( 1 ), 'YData', pos( 3 ) );
  
  drawnow
end
