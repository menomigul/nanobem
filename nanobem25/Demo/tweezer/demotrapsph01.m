%  DEMOTRAPSPH01 - Trapping position for spherical walkers in OF2i setup.

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

%  initial walker positions
z = linspace( 0, 500e3, 15 );
pos = z( : ) * [ 0, 0, 1 ] + [ 20e3, 0, 0 ];

%  set up walker object
walker = tweezer.walkersphere( scatterer, fluid, pos );
%  trap positions
walker = trap( walker );

%  positions where fields are evaluated
x =  50e3 * linspace( -1, 1, 51 );
z = 500e3 * linspace( -1, 1, 101 );
[ xx, zz ] = ndgrid( x, z );
%  incoming electromagnetic fields 
[ e, h ] = paraxial( field, [ xx( : ), 0 * xx( : ), zz( : ) ], k0 );

%  final plot
figure

imagesc( 1e-6 * z, 1e-3 * x, reshape( dot( e, e, 2 ), size( xx ) ) );  hold on
plot( 1e-6 * walker.pos( :, 3 ), 1e-3 * walker.pos( :, 1 ), 'mo-' );

set( gca, 'YDir', 'normal' );

xlabel( 'z (mm)' );
ylabel( 'x (\mum)' );
