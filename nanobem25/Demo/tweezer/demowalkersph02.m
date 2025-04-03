%  DEMOWALKERSPH02 - 3d plot for spherical walkers in OF2i setup.

%  materials, water and polystyrene
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( 1.59 ^ 2, 1 );
mat = [ mat1, mat2 ];

%  nanosphere and wavenumber of light in vacuum
diameter = 400;
k0 = 2 * pi / 532;
%  T-matrix for spherical scatterer
tmat = multipole.tmatsphere( mat2, mat1, diameter, k0 );

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
fluid = tweezer.fluidsphere( diameter );
fluid.vel = 0.3e-3;

%  initial positions
x = linspace( 0, 30e3, 21 );
zout = 1000e3 * linspace( -1, 1, 401 );
pos = x( : ) * [ 1, 0, 0 ] + [ 0, 0, min( zout ) ];
%  set up walker object
walker = tweezer.walkersphere( scatterer, fluid, pos );

%  propagate walkers w/o or with Brownian motion
[ wout, tout ] = propagatez( walker, zout, 'waitbar', 10 );
% [ wout, tout ] = brownianz( walker, zout, 'nsub', 2, 'waitbar', 10 );

%  output positions (mm) and velocities (mm/s)
posout = cat( 3, wout.pos ) * 1e-6;
velout = cat( 3, wout.vel ) * 1e-6;

%%  final plot
figure

%  plot envelope for Laguerre-Gauss beam
t = linspace( 0, 2, 21 ) * pi;
[ zz, tt ] = ndgrid( zout, t );

[ x, y, z ] = pol2cart( tt, wmax( field, k0, zz ), zz );

h = surf( z, x, y );
set( h, 'EdgeColor', 'none', 'FaceColor', 0.9 * [ 1, 1, 1 ], 'FaceAlpha', 0.05 );
hold on

r = wmax( field, k0, zz );
for t1 = linspace( 0, 2 * pi, 8 )
  plot3( zout, r * cos( t1 ), r * sin( t1 ),  ...
    'Color', 0.7 * [ 1, 1, 1 ], 'LineWidth', 1 ); 
end

for iz = 1 : 20 : numel( zout )
  plot3( 0 * t + zout( iz ), r( iz ) * cos( t ), r( iz ) * sin( t ),  ...
    'Color', 0.7 * [ 1, 1, 1 ], 'LineWidth', 1 );
end

%  plot walkers
[ scale, n ] = deal( 100, 20 );

for i1 = 1 : size( posout, 1 )
  verts = squeeze( posout( i1, [ 3, 1, 2 ], : ) ) .' * 1e6;
  vel = squeeze( velout( i1, 3, : ) );
  h = streamtube( { verts }, { 10 * vel }, [ scale, n ] );
  set( h, 'EdgeColor', 'none' );
  CData = get( h, 'CData' );
  CData = repmat( vel( 1 : size( CData, 1 ) ), 1, size( CData, 2 ) );
  set( h, 'CData', CData );
end

shading interp;
lighting gouraud;
camlight 
camlight left

ylim( [ -1, 1 ] * 3e4 );
zlim( [ -1, 1 ] * 3e4 );
axis tight off

caxis( [ 0.3, 0.5 ] );
c = colorbar;
c.Label.String = 'Velocity (mm/s)';
c.Label.FontSize = 11;

view( 0, 90 );
set( gcf, 'Color', [ 1, 1, 1 ] );
