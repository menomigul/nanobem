function obj = eval( obj, z )
%  EVAL - Evaluate grid for scatterer with polar symmetry.
%
%  Usage for obj = tweezer.griddedScattererPol :
%    obj = eval( obj, z )
%  Input
%    z    :  z-values for interpolation

%  positions for function evaluation
pos = obj.pos;
if size( pos, 2 ) == 2,  pos( :, 3 ) = z;  end

%  inhomogeneity for incoming field 
scatterer = obj.scatterer;
q = eval( scatterer.qinc, 'shift', pos );
%  solve T-matrix equations and concatenate solution
sol = arrayfun( @( tmat ) solve( tmat, q ), obj.tmat, 'uniform', 1 );
for name = [ "a", "b", "ai", "bi" ]
  sol( 1 ).( name ) = horzcat( sol.( name ) );
end
%  optical force 
[ f, n ] = optforce( sol( 1 ), 'data', scatterer.data );
data = cellfun( @( x ) x( sol( 1 ), pos ), obj.fun, 'uniform', 0 );
%  transform data for gridding
obj.z = z;
obj.f = grid( obj, f );
obj.n = grid( obj, n );
obj.data = cellfun( @( x ) grid( obj, x ), data, 'uniform', 0 );
