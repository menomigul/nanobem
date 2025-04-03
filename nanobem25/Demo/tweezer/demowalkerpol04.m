%  DEMOWALKERPOL04 - Same as demowalkerpol03.m but with Brownian loop.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  ellipsoid and wavenumber of light in vacuum
diameter = 300;
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
field.pol = [ 0, 1, 0 ];

%  incoming fields and scatterer
fun = @( pos, k0 ) paraxial( field, pos, k0 );
qinc = multipole.incoming( mat1, k0, fun, 'lmax', tmat.lmax, 'diameter', diameter );
scatterer = tweezer.scatterer( tmat, qinc );
%  fluid forces and velocity of fluid (m/s)
fluid = tweezer.fluidellipsoid( diameter, ratio );
fluid.vel = 0.3e-3;

%  initial positions
x = linspace( 0, 20e3, 21 );
zout = 1000e3 * linspace( -1, 1, 801 );
pos = x( : ) * [ 1, 0, 0 ] + [ 0, 0, min( zout ) ];
%  random initial orientation
rng( 1 );
rot = multipole.rotation( 360 * rand( numel( x ), 3 ) );

%  detector for light scattering from side
u = linspace( 0, 2 * pi, 25 );
t = linspace( 0, asin( 0.25 ), 21 );
pinfty = trispheresegment( u, t, 2 );
pinfty.verts = pinfty.verts( :, [ 3, 1, 2 ] );
%  allocate output
sca = zeros( numel( zout ), numel( x ) );
nsub = 2;
%  space increments
dz = ( zout( 2 ) - zout( 1 ) ) / nsub;

multiWaitbar( 'Brownian loop', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over propagation distances and sub-intervals
for iz = 1 : numel( zout )
  for i1 = 1 : nsub
    %  optical force 
    [ fopt, ntot, sol ] = optforce( scatterer, pos, rot );
    if i1 == 1
      %  scattering cross section, rotate SOL to laboratory frame
      sol = rotate( sol, permute( rot, [ 2, 1, 3 ] ), 'same', 1 );
      sca( iz, : ) = scattering( sol, 'shift', pos, 'pinfty', pinfty );      
    end
    %  update positions and orientations
    [ pos, rot ] = brownianz( fluid, pos, rot, fopt, ntot, dz );
  end
  
  if mod( iz, 20 ) == 0, multiWaitbar( 'Brownian loop', iz / numel( zout ) ); end
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%  final plot
figure
imagesc( 1e-6 * zout, 1 : numel( x ), sca .' );
set( gca, 'YDir', 'norm' );

c = colorbar;
c.Label.String = 'Scattering intensity';
c.Label.FontSize = 11;

xlabel( 'Propagation distance (mm)' );
ylabel( 'Walkers' );
