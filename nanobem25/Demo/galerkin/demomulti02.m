%  DEMOMULT02 - T-matrices for TiO2 nanodisk and plot optical spectrum.

%  materials
mat1 = Material( 1, 1 );
mat2 = Material( 6.25, 1 );
mat = [ mat1, mat2 ];

%  polygon for disk
diameter = 500;
n = [ 25, 10 ];  %  coarse [25,10], fine [35,15]
poly = polygon( n( 1 ), 'size', diameter * [ 1, 1 ] ); 
%  edge profile for nanodisk
edge = edgeprofile( 300, n( 2 ), 'mode', '11' );  
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );
tau = BoundaryEdge( mat, p, [ 2, 1 ] );

%  BEM solver and planewave excitation
bem = galerkin.bemsolver( tau, 'waitbar', 1 );
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );
fun = @( pos, k0 ) fields( exc, Point( mat, 1, pos ), k0 );
%  T-matrix solver
lmax = 4;
tsolver = multipole.tsolver( mat, 1, lmax );
%  light wavelength in vacuum
lambda = linspace( 750, 1250, 20 );
k0 = 2 * pi ./ lambda;

%  allocate optical cross sections, T-matrices
[ csca1, cext1, csca2, cext2 ] = deal( zeros( size( k0 ) ) );
tmat = repelem( multipole.tmatrix( tsolver ), 1, numel( k0 ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solve BEM equation and optical cross sections
  [ sol1, bem ] = solve( bem, exc( tau, k0( i ) ) );
  csca1( i ) = scattering( exc, sol1 ); 
  cext1( i ) = extinction( exc, sol1 );   
  %  compute T-matrix
  [ sol2, bem ] = solve( bem, tsolver( tau, k0( i ) ) );
  tmat( i ) = eval( tsolver, sol2 );
  
  %  multipole solution 
  sol = solve( tmat( i ), qinc( tmat( i ), fun ) );
  %  scattering and extinction cross sections
  P0 = 0.5 / mat1.Z( k0( i ) );
  csca2( i ) = scattering( sol ) / P0;
  cext2( i ) = extinction( sol ) / P0;
  
  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%  additional information for H5 file
info = multipole.h5info( tau );
info.name = "TiO2 nanodisk, diameter=500 nm, height=300 nm";
info.description = "TiO2";
info.matname = [ "Embedding medium, n=1", "TiO2 n=2.5" ];
%  save T-matrices
h5save( tmat, 'tmatrix_cylinder.h5', info );

% h5disp( 'tmatrix_cylinder.h5' );

%  final plot
% plot( lambda, csca1 * 1e-6, 'o-', lambda, csca2 * 1e-6, '+-' );
plot( lambda, cext1 * 1e-6, 'o-', lambda, cext2 * 1e-6, '+-' );

legend( 'BEM', 'T-matrix' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Optical cross section (\mum^2)' );
