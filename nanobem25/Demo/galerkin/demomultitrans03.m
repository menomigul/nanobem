%  DMEOMULTITRANS03 - Coupled spheres, Fig. F8a of arXiv:2408.10727.

%  diameter of spheres and shift vectors
diameter = 100 : 20 : 160;
a = 300;
shift = [ - 0.5, - sqrt( 3 ) / 6, - sqrt( 6 ) / 12;  ...
          + 0.5, - sqrt( 3 ) / 6, - sqrt( 6 ) / 12;  ...
            0.0,   sqrt( 3 ) / 3, - sqrt( 6 ) / 12; 0, 0, sqrt( 6 ) / 4 ] * a;
%  dielectric functions
mat1 = Material( 1, 1 );
mat2 = Material( 9, 1 );
%  wavenumbers of light in vacuum
lambda = linspace( 300, 800, 200 );
k0 = 2 * pi ./ lambda;
%  maximal degree for multipole expansion
lmax = 6;
%  allocate output
[ csca, cext ] = deal( zeros( size( k0 ) ) );

multiWaitbar( 'Wavelength loop', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for it = 1 : numel( k0 )
  %  T-matrices for single sphere and incoming coefficients
  fun = @( x ) multipole.tmatsphere( mat2, mat1, x, k0( it ), 'lmax', lmax );
  t = arrayfun( fun, diameter, 'uniform', 1 );
  %  extinction cross section for coupled spheres
  t2 = union( t, shift, 'interaction', 1 );
  csca( it ) = scattering( t2 ); 
  cext( it ) = extinction( t2 ); 
  
  if ~mod( it, 10 ),  multiWaitbar( 'Wavelength loop', it / numel( k0 ) );  end
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
figure

plot( lambda, 1e-6 * csca, '-'  );  hold on
plot( lambda, 1e-6 * cext, '--'  );

legend( 'Scattering', 'Extinction' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Optical cross section (\mum^2)' );
