%  DEMOMIEFIELD01 - Fields around sphere in OF2i setup.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  nanosphere and wavenumber of light in vacuum
diameter = 400;
k0 = 2 * pi / 532;
%  Wiscombe cutoff and Mie solver
x = 0.5 * diameter * mat2.k( k0 );
lmax = ceil( x + 2 + 4.05 * x ^ ( 1 / 3 ) );
mie = multipole.miesolver( mat2, mat1, diameter, 'lmax', lmax );

%  Laguerre-Gauss beam
field = laguerregauss( mat1 );

field.foc = 50.8e6;
field.w0  = 1.8e6;
field.nLG = 0;
field.mLG = 2;
field.pow = 1.65;
field.pol = [ 0, 1, 0 ];

%  incoming fields 
fun = @( pos, k0 ) paraxial( field, pos, k0 );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', lmax, 'diameter', diameter );
%  sphere position
shift = [ 5e3, 0, 0 ];
%  positions where fields are evalulated
x = 2 * diameter * linspace( -1, 1, 151 );
z = 3 * diameter * linspace( -1, 1, 201 );
[ xx, zz ] = ndgrid( x, z );
pos = [ xx( : ), 0 * xx( : ), zz( : ) ];
%  scattered fields
[ esca, hsca ] = fields( mie, eval( qinc, 'shift', shift ), pos );

%%  final plot
figure

%  intensity
ee = reshape( dot( esca, esca, 2 ), size( xx ) );

imagesc( z, x, ee );  hold on

t = linspace( 0, 2 * pi, 101 );
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ), 'w-' );

xlabel( 'z (nm)' );
ylabel( 'x (nm)' );

set( gca, 'YDir', 'norm' );
axis equal tight
