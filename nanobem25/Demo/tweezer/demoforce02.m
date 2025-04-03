%  DEMOFORCE02 - Force on spherical particle, 2d map.

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

%  T-matrix for nansphere
tmat = multipole.tmatsphere( mat2, mat1, diameter, k0 );
%  multipole solution
fun = @( pos, k0 ) fields( foc, Point( mat1, 1, pos ) );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );

%%  xy-plane

%  positions in xy plane
x = 700 * linspace( -1, 1, 51 );
[ xx, yy ] = ndgrid( x );
pos = [ xx( : ), yy( : ), 0 * xx( : ) ];
%  force in focal plane
fopt = optforce( scatterer, pos );
fopt = reshape( fopt, [ size( xx ), 3 ] );

%  final plot
figure

for k = 1 : 3
  subplot( 1, 3, k );
  imagesc( x, x, fopt( :, :, k ) .' );

  xlabel( 'x (nm)' );
  ylabel( 'y (nm)' );

  colorbar( 'Location', 'NorthOutside' );
  set( gca, 'YDir', 'norm' );
  axis equal tight
end

%%  xz-plane

%  positions in xz plane
x = 1000 * linspace( -1, 1, 51 );
z = 1000 * linspace( -1, 1, 51 );
[ xx, zz ] = ndgrid( x, z );
pos = [ xx( : ), 0 * xx( : ), zz( : ) ];
%  force in focal plane
fopt = optforce( scatterer, pos );
fopt = reshape( fopt, [ size( xx ), 3 ] );

%  final plot
figure

for k = 1 : 3
  subplot( 1, 3, k );
  imagesc( x, z, fopt( :, :, k ) .' );

  xlabel( 'x (nm)' );
  ylabel( 'z (nm)' );

  colorbar( 'Location', 'NorthOutside' );
  set( gca, 'YDir', 'norm' );
  axis equal tight
end
