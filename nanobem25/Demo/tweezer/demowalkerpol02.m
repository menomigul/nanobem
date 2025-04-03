%  DEMOWALKERPOL02 - 3d plot of ellipsoidal walkers in OF2i setup.

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

%  initial position
zout = 500e3 * linspace( -1, 1, 801 );
pos = [ 10e3, 0, min( zout ) ];
%  random initial rotation matrices
rng( 1 );
rot = multipole.rotation( 360 * rand( 1, 3 ) );

%  set up walker object
walker = tweezer.walkerparticle( scatterer, fluid, pos, rot );

%  propagate walkers w/o or with Brownian motion
% [ wout, tout ] = propagatez( walker, zout, 'waitbar', 20 );
[ wout, tout ] = brownianz( walker, zout, 'nsub', 2, 'waitbar', 20 );

%  output positions and velocities
posout = cat( 1, wout.pos );
velout = cat( 1, wout.vel );
rotout = cat( 3, wout.rot );

%%  final plot
figure

%  matrix for rotation of z-axis to x-axis
rot1 = multipole.rotation( 90, 'order', 'y' );
%  particle
r = [ 1, 1, ratio ];
p = transform( trisphere( 256, 2 ), 'scale', 0.8 * r / max( r ), 'rot', rot );
val = repmat( 0.8 * [ 1, 1, 1 ], size( p.verts, 1 ), 1 );
%  plot particle, propagation direction along z
h1 = patch( struct( 'vertices', p.verts * rot1, 'faces', p.faces ),  ...
       'FaceVertexCData', val, 'FaceColor', 'interp', 'FaceAlpha', 0.5, 'EdgeColor', 'none' );
    
lighting phong
shading interp
camlight headlight

xlim( 1.5 * [ -1, 1 ] );
ylim( 1.5 * [ -1, 1 ] );
zlim( 1.5 * [ -1, 1 ] );

view( 0, 90 );
axis equal off
set( gcf, 'Color', [ 1, 1, 1 ] );

%  plot laser profile and particle position
r = wmax( field, k0, zout );
sz = 1.5 / max( zout );
sx = 4 * sz;

hold on
plot3( sz * zout,   sx * r - 1.3, 0 * r, 'Color', 0.8 * [ 1, 1, 1 ] );
plot3( sz * zout, - sx * r - 1.3, 0 * r, 'Color', 0.8 * [ 1, 1, 1 ] );

h2 = plot3( sz * posout( 1, 3 ), sx * posout( 1, 1 ) - 1.3,  ...
            sx * posout( 1, 2 ), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r' );


for iz = 2 : numel( zout )
  %  rotation angle and axis for transition from iz-1 to iz
  dr = rotout( :, :, iz ) * transpose( rotout( :, :, iz - 1 ) ); 
  [ angle, dir ] = rot2ang( dr );  
  %  rotate particle
  rotate( h1, dir * rot1, angle );
  
  %  update position
  ind = [ iz, iz - 1 ];
  plot3( sz * posout( ind, 3 ), sx * posout( ind, 1 ) - 1.3,  ...
                                sx * posout( ind, 2 ), 'k-' );
  set( h2, 'XData', sz * posout( iz, 3 ) );
  set( h2, 'YData', sx * posout( iz, 1 )  - 1.3 );
  set( h2, 'ZData', sx * posout( iz, 2 ) );
  
  drawnow;
end


function [ angle, dir ] = rot2ang( rot )
  %  ROT2ANG - Convert from rotation matrix to angle and direction.

  tr = trace( rot );
  eta = 1e-10;

  if abs( tr - 3 ) <= eta
    dir = [ 0, 0, 1 ];
    angle = 0;
  elseif abs ( tr + 1 ) <= eta  
    if ( rot( 1, 1 ) > rot( 2, 2 ) ) && ( rot( 1, 1 ) > rot( 3, 3 ) ) 
      dir = rot( 1, : ) + [ 1, 0, 0 ];
    elseif rot( 2, 2 ) > rot( 3, 3 ) 
      dir = rot( 2, : ) + [ 0, 1, 0 ];
    else
      dir = rot( 3, : ) + [ 0, 0, 1 ];
    end
    angle = 180;
  else
    dir = [ rot( 3, 2 ) - rot( 2, 3 ),  ...
            rot( 1, 3 ) - rot( 3, 1 ),  ...
            rot( 2, 1 ) - rot( 1, 2 ) ];
    angle = acosd( 0.5 * ( tr - 1 ) );
  end

  %  normalize direction
  dir = dir / norm( dir );
end
