%  DEMOWALKERSPH01 - Propagate spherical walkers in OF2i setup.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  nanosphere and wavenumber of light in vacuum
diameter = 400;
k0 = 2 * pi / 532;
%  T-matrix for spherical scatterer
tmat = multipole.tmatsphere( mat2, mat1, diameter, k0 );

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
fluid = tweezer.fluidsphere( diameter );
fluid.vel = 0.3e-3;

%  initial positions
x = linspace( 0, 30e3, 21 );
zout = 1000e3 * linspace( -1, 1, 201 );
pos = x( : ) * [ 1, 0, 0 ] + [ 0, 0, min( zout ) ];
%  set up walker object
walker = tweezer.walkersphere( scatterer, fluid, pos );

%  propagate walkers w/o or with Brownian motion
[ wout, tout ] = propagatez( walker, zout, 'waitbar', 1 );
% [ wout, tout ] = brownianz( walker, zout, 'nsub', 5, 'waitbar', 1 );

%  output positions (mm) and velocities (mm/s)
posout = cat( 3, wout.pos ) * 1e-6;
velout = cat( 3, wout.vel ) * 1e-6;
%  final plot
figure
plot( zout * 1e-6, squeeze( velout( :, 3, : ) ) .' );

xlabel( 'Propagation distance (mm)' );
ylabel( 'Velocity (mm/s)' );

% %  plot trajectories
% figure
% plot3( squeeze( posout( :, 3, : ) ) .',  ...
%        squeeze( posout( :, 1, : ) ) .', squeeze( posout( :, 2, : ) ) .' );
