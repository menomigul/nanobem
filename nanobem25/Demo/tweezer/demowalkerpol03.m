%  DEMOWALKERPOL03 - Light scattering for ellipsodial walkers in OF2i setup.

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
%  set up walker object
walker = tweezer.walkerparticle( scatterer, fluid, pos );
%  random initial rotation matrices
rng( 1 );
walker.rot = multipole.rotation( 360 * rand( numel( x ), 3 ) );

%  propagate walkers w/o or with Brownian motion
% [ wout, tout ] = propagatez( walker, zout, 'waitbar', 20 );
[ wout, tout ] = brownianz( walker, zout, 'nsub', 2, 'waitbar', 20 );

%  output positions (mm) and velocities (mm/s)
posout = cat( 3, wout.pos ) * 1e-6;
velout = cat( 3, wout.vel ) * 1e-6;
%  concatenate rotation matrices
rotout = cat( 4, wout.rot );
rotout = reshape( permute( rotout, [ 1, 2, 4, 3 ] ), 3, 3, [] );

%  detector for light scattering from side
u = linspace( 0, 2 * pi, 25 );
t = linspace( 0, 0.3 * pi, 21 );
pinfty = trispheresegment( u, t, 2 );
pinfty.verts = pinfty.verts( :, [ 3, 1, 2 ] );
%  light scattering
shift = reshape( permute( posout, [ 3, 1, 2 ] ) * 1e6, [], 3 );
sol = solve( scatterer, shift, rotout, 'frame', 'lab' );
sca = scattering( sol, 'shift', shift, 'pinfty', pinfty );
sca = reshape( sca, numel( zout ), [] );

%  final plot
figure
imagesc( 1e-6 * zout, 1 : numel( x ), sca .' );
set( gca, 'YDir', 'norm' );

c = colorbar;
c.Label.String = 'Scattering intensity';
c.Label.FontSize = 11;

xlabel( 'Propagation distance (nm)' );
ylabel( 'Walkers' );
