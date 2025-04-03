%  DEMOFORCE01 - Force on spherical particle, comparison T-matrix and BEM.

%  material properties, water and polysytrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
%  diameter of sphere and wavenumber of light in vacuum
diameter = 400;
k0 = 2 * pi / 520;
%  positions where force is evaluated
xout = linspace( 0, 500, 20 );
posout = xout( : ) * [ 1, 0, 0 ];

%  focus lens
NA = 1.0;
lens = optics.lensfocus( mat1, k0, NA, 'nphi', 21, 'ntheta', 20 );
%  incoming fields
e = 2 * normpdf( lens.rho, 0, 1 );
e = e( : ) * [ 1, 0, 0 ];
%  planewave decomposition of focal fields
foc = eval( lens, e );

% %  points in focal plane
% x = 700 * linspace( -1, 1, 101 );
% [ xx, yy ] = ndgrid( x );
% pts = Point( [ mat1, mat2 ], 1, [ xx( : ), yy( : ), 0 * xx( : ) ] );
% %  evaluate focal fields
% [ e, h ] = fields( foc, pts );
% 
% %  power in image plane
% P = 0.5 * real( cross( e, conj( h ), 2 ) );
% P = sum( P( :, 3 ) ) * ( x( 2 ) - x( 1 ) ) ^ 2 / 376.730;  
% %  plot field in image plane
% imagesc( x, x, reshape( dot( e, e, 2 ), size( xx ) ) .' );
% 
% hold on
% plot(  posout( :, 1), posout( :, 2 ), 'mo' );
% 
% xlabel( 'x (nm)' );
% ylabel( 'y (nm)' );
% 
% axis equal tight

%%  compute forces using BEM

%  boundary for BEM simulation
p = trisphere( 400, diameter );
mat = [ mat1, mat2 ];
tau = BoundaryEdge( mat, p, [ 2, 1 ] );
%  set up BEM solver
bem = galerkin.bemsolver( tau, 'order', [] );
bem = fill( bem, k0 );

%  allocate output
fopt1 = zeros( size( posout ) );
%  loop over particle positions
for i1 = 1 : size( posout, 1 )
  sol = solve( bem, eval( foc, tau, 'shift', posout( i1, : ) ) );
  fopt1( i1, : ) = optforce( sol );
end

%%  compute forces using T-matrices

%  T-matrix for nansphere
tmat = multipole.tmatsphere( mat2, mat1, diameter, k0 );
%  multipole solution
fun = @( pos, k0 ) fields( foc, Point( mat, 1, pos ) );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );
%  optical force
fopt2 = optforce( scatterer, posout );

%%  final plot
figure

plot( xout, fopt1, 'o' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( xout, fopt2, '+' );  hold on

legend( 'x (BEM)', 'y (BEM)', 'z (BEM)' );

xlabel( 'x (nm)' );
ylabel( 'Force (pN)' );
