function obj = propagatet( obj, tout, varargin )
%  PROPAGATEt - Propagate walkers in time.
%
%  Usage for obj = tweezer.walkerparticle :
%    obj = propagatez( obj, tout, PropertyPairs )
%  Input
%    tout     :  output times
%  PropertyName
%    solver   :  ODE solver ode23 or ode45
%    waitbar  :  show waitbar
%  Output
%    walker   :  array of walkers

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'solver', 'ode45' );
addParameter( p, 'waitbar', 0 );
%  parse input
parse( p, varargin{ : } );

%  initial positions
y0 = obj.pos( :, 1 : 3 );
%  quaternion parametrization of rotation matrices
quater = tweezer.rotation( obj.rot );
y0 = horzcat( y0, quater.q );
%  options for ODE solver
op = odeset( p.Unmatched );
if p.Results.waitbar
  op.OutputFcn = @( varargin ) waitbar( tout, p.Results.waitbar, varargin{ : } );
end

%  solve ODE equation
switch p.Results.solver
  case 'ode23'
    [ ~, yout ] = ode23( @( t, x ) funderiv( obj, t, x ), tout, y0, op );
  case 'ode45'
    [ ~, yout ] = ode45( @( t, x ) funderiv( obj, t, x ), tout, y0, op );
end

%  reshape output array n×nt×3
n = size( obj.pos, 1 );
yout = permute( reshape( yout, numel( tout ), n, 7 ), [ 2, 1, 3 ] );
%  positions
x = yout( :, :, 1 );
y = yout( :, :, 2 );
z = yout( :, :, 3 );
%  rotation matrices
quater = tweezer.rotation( 'quater', reshape( yout( :, :, 4 : 7 ), [], 4 ) );
rot = reshape( eval( quater ), 3, 3, n, [] );

%  velocities from derivatives of trajectories
vel = @( t, x ) ppval( fnder( spline( t, x ) ), t );
vx = arrayfun( @( i ) vel( tout, x( i, : ) ), 1 : n, 'uniform', 0 );  
vy = arrayfun( @( i ) vel( tout, y( i, : ) ), 1 : n, 'uniform', 0 );
vz = arrayfun( @( i ) vel( tout, z( i, : ) ), 1 : n, 'uniform', 0 );
%  make array
vx = vertcat( vx{ : } );
vy = vertcat( vy{ : } );
vz = vertcat( vz{ : } );
%  allocate output
obj = repelem( obj, numel( tout ) );

%  loop over propagation distances
for it = 1 : numel( tout )
  obj( it ).pos = horzcat( x ( :, it ), y ( :, it ), z ( :, it ) );
  obj( it ).vel = horzcat( vx( :, it ), vy( :, it ), vz( :, it ) );
  obj( it ).rot = rot( :, :, :, it );
end



function y = funderiv( obj, ~, x )
%  FUNDERIV - Derivative function for ODE solver.

x = reshape( x, [], 7 );
%  particle positions 
pos = x( :, 1 : 3 );
%  quaternion parametrization of rotation matrices
quater = tweezer.rotation( 'quater', x( :, 4 : end ) );
rot = eval( quater );
%  optical force and particle velocity
[ fopt, nopt ] = optforce( obj.scatterer, pos, rot );
[ vel, omega ] = drift( obj.fluid, rot, fopt, nopt );
%  quaternion derivative of angular velocity
omega = deriv( quater, omega );

%  set output
y = vertcat( vel( : ), omega( : ) );
