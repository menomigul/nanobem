%  DEMOFORCE03 - Force and torque for ellipsoid in OF2i setup.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  nanoellipsoid and wavenumber of light in vacuum
diameter = 400;
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

%  optical forces and scatterer
fun = @( pos, k0 ) paraxial( field, pos, k0 );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax );
scatterer = tweezer.scatterer( tmat, qinc );

%  positions where force is computed
x = 10 * linspace( -1, 1, 61 );
[ xx, yy ] = ndgrid( 1e3 * x );
pos = [ xx( : ), yy( : ), 0 * xx( : ) ];
%  rotation matrix for ellipsoid
rot = multipole.rotation( [ 90, 0 ], 'order', 'xz' );
rot = repmat( rot, 1, 1, numel( xx ) );

%  compute optical force and torque
[ fopt, nopt ] = optforce( scatterer, pos, rot );

%  final figure
figure
str = 'xyz';

for k = 1 : 3
  subplot( 2, 3, k );  
  imagesc( x, x, reshape( fopt( :, k ), size( xx ) ) .' );
  colorbar
  set( gca, 'YDir', 'norm' );
  axis equal tight
  title( [ 'F', str( k ) ] );
  
  subplot( 2, 3, k + 3 );  
  imagesc( x, x, reshape( nopt( :, k ), size( xx ) ) .' );
  colorbar
  set( gca, 'YDir', 'norm' );
  axis equal tight 
  title( str( 1, k ) );
  title( [ 'N', str( k ) ] );
end
