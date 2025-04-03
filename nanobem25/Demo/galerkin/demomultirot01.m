%  DEMOMULTIROT01 - Rotation of multipoles.

%  material properties
mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material vector
mat = [ mat1, mat2 ];

%  rotation matrix
rot = multipole.rotation( [ 40, 20, -35 ], 'order', 'zxz' );
%  nanosphere
diameter = 50;
p1 = trisphere( 144, diameter );
p1 = transform( p1, 'scale', [ 2, 1, 1.5 ] );
p2 = transform( p1, 'rot', rot );
%  boundary elements with linear shape functions
tau1 = BoundaryEdge( mat, p1, [ 2, 1 ] );     
tau2 = BoundaryEdge( mat, p2, [ 2, 1 ] );     

%  wavenumber of light in vacuum and BEM solvers
k0 = 2 * pi / 500;
bem1 = fill( galerkin.bemsolver( tau1, 'order', [] ), k0 );
bem2 = fill( galerkin.bemsolver( tau2, 'order', [] ), k0 );
%  T-matrix solver
lmax = 4;
tsolver = multipole.tsolver( mat, 1, lmax );
%  T-matrix
sol1 = bem1 \ tsolver( tau1, k0 );
sol2 = bem2 \ tsolver( tau2, k0 );
t1 = eval( tsolver, sol1 );
t2 = eval( tsolver, sol2 );

%  rotate T-matrix
t1 = rotate( t1, rot );

%%
fun = @( x ) log10( abs( ( x( : ) ) ) );
% fun = @( x ) real( x( : ) );
name = 'aa'; 

figure
plot( fun( t2.( name ) ), 'o' );  hold on
plot( fun( t1.( name ) ), '+' );
