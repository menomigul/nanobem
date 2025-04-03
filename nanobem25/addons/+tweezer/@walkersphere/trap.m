function obj = trap( obj, varargin )
%  TRAP - Trap particles for fixed propagation distance.
%
%  Usage for obj = tweezer.walkersphere :
%    obj = trap( obj, PropertyPairs )
%  PropertyName
%    dir    :  transverse trap direction

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'dir', [ 1, 0, 0 ] );
%  parse input
parse( p, varargin{ : } );

%  start position propagation distance
dir = p.Results.dir;
x = obj.pos( :, 1 : 2 ) * dir( 1 : 2 ) .';
z = obj.pos( :, 3 );
%  find equilibrium positions
for it = 1 : numel( z )
  %  force in transverse direction
  fun = @( x ) optforce( obj.scatterer, x * dir + [ 0, 0, z( it ) ] );
  %  find position where force is zero
  x0 = fzero( @( x ) dot( fun( x ), dir, 2 ), x( it ) );
  obj.pos( it, : ) = x0 * p.Results.dir + [ 0, 0, z( it ) ];
end
