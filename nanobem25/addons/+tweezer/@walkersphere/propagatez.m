function [ obj, tout ] = propagatez( obj, zout, varargin )
%  PROPAGATEZ - Propagate walkers along z.
%
%  Usage for obj = tweezer.walkersphere :
%    [ obj, tout ] = propagatez( obj, zout, PropertyPairs )
%  Input
%    zout     :  propagation distances where output is requested
%  PropertyName
%    solver   :  ODE solver ode23 or ode45
%    waitbar  :  show waitbar
%  Output
%    obj      :  array of walkers
%    tout     :  output times

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'solver', 'ode45' );
addParameter( p, 'waitbar', 0 );
%  parse input
parse( p, varargin{ : } );

%  initial positions and times
y0 = obj.pos( :, 1 : 2 );
y0( :, 3 ) = 0;
%  options for ODE solver
op = odeset( p.Unmatched );
if p.Results.waitbar
  op.OutputFcn = @( varargin ) waitbar( zout, p.Results.waitbar, varargin{ : } );
end

%  solve ODE equation
switch p.Results.solver
  case 'ode23'
    [ ~, yout ] = ode23( @( z, x ) funderiv( obj, z, x ), zout, y0, op );
  case 'ode45'
    [ ~, yout ] = ode45( @( z, x ) funderiv( obj, z, x ), zout, y0, op );
end

%  reshape output array n×nz×3
n = size( obj.pos, 1 );
yout = permute( reshape( yout, numel( zout ), n, 3 ), [ 2, 1, 3 ] );
%  transverse positions and time
x = yout( :, :, 1 );
y = yout( :, :, 2 );
tout = yout( :, :, 3 );
%  velocities from derivatives of trajectories
vel = @( t, x ) ppval( fnder( spline( t, x ) ), t );
vx = arrayfun( @( i ) vel( tout( i, : ), x( i, : ) ), 1 : n, 'uniform', 0 );  
vy = arrayfun( @( i ) vel( tout( i, : ), y( i, : ) ), 1 : n, 'uniform', 0 );
vz = arrayfun( @( i ) vel( tout( i, : ), zout  ),     1 : n, 'uniform', 0 );
%  make array
vx = vertcat( vx{ : } );
vy = vertcat( vy{ : } );
vz = vertcat( vz{ : } );
%  allocate output
obj = repelem( obj, numel( zout ) );

%  loop over propagation distances
for iz = 1 : numel( zout )
  obj( iz ).pos = horzcat( x( :, iz ), y( :, iz ) );
  obj( iz ).pos( :, 3 ) = zout( iz );
  obj( iz ).vel = horzcat( vx( :, iz ), vy( :, iz ), vz( :, iz ) );
end



function y = funderiv( obj, z, x )
%  FUNDERIV - Derivative function for ODE solver.

%  particle positions
pos = reshape( x, [], 3 );
pos( :, 3 ) = z;
%  optical force and particle velocity
fopt = optforce( obj.scatterer, pos );
vel = drift( obj.fluid, fopt );

%  set output
y = vertcat( vel( :, 1 ) ./ vel( :, 3 ),  ...
             vel( :, 2 ) ./ vel( :, 3 ) , 1 ./ vel( :, 3 ) );
