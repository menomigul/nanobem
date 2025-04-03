function obj = eval( obj, z )
%  EVAL - Evaluate grid for spherical scatterer.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    obj = eval( obj, z )
%  Input
%    z    :  z-values for interpolation

%  positions for function evaluation
pos = obj.pos;
if size( pos, 2 ) == 2,  pos( :, 3 ) = z;  end
%  compute data for gridding
[ f, ~, sol ] = optforce( obj.scatterer, pos );
data = cellfun( @( x ) x( sol, pos ), obj.fun, 'uniform', 0 );
%  transform data for gridding
obj.z = z;
obj.f = grid( obj, f );
obj.data = cellfun( @( x ) grid( obj, x ), data, 'uniform', 0 );
