%  DMEOMULTITRANS01 - Coupled spheres with BEM and coupled T-matrices.

%  diameter of spheres and shift vectors
diameter = 50;
gap = 10;
shift = 0.5 * ( diameter + gap ) * [ 0, 0, 1; 0, 0, -1 ];
%  wavenumbers of light in vacuum
lambda = linspace( 400, 800, 20 );
k0 = 2 * pi ./ lambda;

%  spheres 
[ p1, p2 ] = deal( trisphere( 256, diameter ) );
p1 = transform( p1, 'shift', shift( 1, : ) );
p2 = transform( p2, 'shift', shift( 2, : ) );
%  dielectric functions
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
mat3 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2, mat3 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p1, [ 2, 1 ], p2, [ 3, 1 ] );
%  initialize BEM solver
bem = galerkin.bemsolver( tau, 'waitbar', 1 );
%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ] );
fun = @( pos, k0 ) fields( exc, Point( mat1, 1, pos ), k0 );
%  maximal degree for multipole expansion
%    for large LMAX values the coupling matrices for the T-matrix approach
%    have a large condition number that may cause a warning, although the
%    results are usually fine
lmax = 10;
warning( 'off', 'MATLAB:nearlySingularMatrix' );

%  allocate output
[ csca1, csca2 ] = deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

multiWaitbar( 'Wavelength loop', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for it = 1 : numel( k0 )
  %  solution of BEM equations
  sol = bem \ exc( tau, k0( it ) );
  %  scattering cross sections
  csca1( it, : ) = scattering( exc, sol );

  %  T-matrix for single sphere and incoming coefficienst
  t = multipole.tmatsphere( mat2, mat1, diameter, k0( it ), 'lmax', lmax );
  qinc = multipole.incoming( mat1, k0( it ), fun, 'lmax', lmax );
  %  solve T-matrix equation for coupled spheres
  t2 = union( [ t, t ], shift, 'interaction', 1 );
  sol2 = solve( t2, eval( qinc ) );
  %  scattering cross section, divide scattered power by incoming power
  P = 0.5 / mat1.Z( k0( it ) );
  csca2( it, : ) = scattering( sol2 ) / P; 
  
  multiWaitbar( 'Wavelength loop', it / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
figure

plot( lambda, csca1, 'o-'  );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( lambda, csca2, '+-' );  hold on

legend( 'BEM(x)', 'BEM(z)', 'T-mat(x)', 'T-mat(z)' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );
