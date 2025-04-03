%  DEMOWALKERPOL05 - Histogram for Brownian motion and ellipsoids.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  ellipsoid and wavenumber of light in vacuum
diameter = 200;
ratio = 2;
k0 = 2 * pi / 532;
%  T-matrix for ellipsoidal scatterer
tmat = multipole.tmatellipsoid( mat2, mat1, diameter, ratio, k0, 'lmax', 10 );

%  Laguerre-Gauss beam
field = laguerregauss( mat1 );

field.foc = 50.8e6;
field.w0  = 1.8e6;
field.nLG = 0;
field.mLG = 2;
field.pow = 1.65;
field.pol = [ 0, 1, 0 ];

%  incoming fields and scatterer
fun = @( pos, k0 ) paraxial( field, pos, k0 );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );
%  fluid forces and velocity of fluid (m/s)
fluid = tweezer.fluidellipsoid( diameter, ratio );
fluid.vel = 0.3e-3;

%  bounding box with periodic boundary conditions
xmax = 20e3;
box = tweezer.boundingbox( xmax * [ -1, 1; -1, 1 ] );
%  initial positions and rotations
n = 50000;
zout = 800e3 * linspace( -1, 1, 201 );
pos = box.rand( n, zout( 1 ) );
rot = multipole.rotation( 360 * rand( n, 3 ) );
%  gridded scatterer for faster force evaluation
r = sqrt( 2 ) * xmax * linspace( 0, 1, 21 );
grid = tweezer.griddedScattererPol( scatterer, r, 'lmax', 2 );

%  allocate output
rbin = linspace( 0, xmax, 60 );
rout = zeros( numel( zout ), numel( rbin ) - 1 );
%  space increments 
nsub = 2;
dz = ( zout( 2 ) - zout( 1 ) ) / nsub;

multiWaitbar( 'Brownian loop', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over propagation distances and sub-intervals
for iz = 1 : numel( zout )
  for i1 = 1 : nsub
    %  optical force and torque
    [ fopt, nopt ] = optforce( grid, pos, rot );
    if i1 == 1
      %  histogram of walkers
      rout( iz, : ) = histcounts( hypot( pos( :, 1 ), pos( :, 2 ) ), rbin );
    end
    %  update positions and orientations
    [ pos, rot ] = brownianz( fluid, pos, rot, fopt, nopt, dz );
  end
  
  if ~mod( iz, 5 ),  multiWaitbar( 'Brownian loop', iz / numel( zout ) ); end
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
figure

%  normalize distribution function
r = 0.5 * ( rbin( 1 : end - 1 ) + rbin( 2 : end ) );
a = 2 * pi * r * ( r( 2 ) - r( 1 ) );
h = box.area ./ ( n * a ) .* rout;
%  plot particle distribution and waist of laser beam
imagesc( 1e-3 * zout, 1e-3 * rbin, h .' );  hold on
plot( 1e-3 * zout, 1e-3 * field.wmax( k0, zout ), 'w-' );

set( gca, 'YDir', 'norm' );
colorbar

xlabel( 'z (\mum)' );
ylabel( 'x (\mum)' );
