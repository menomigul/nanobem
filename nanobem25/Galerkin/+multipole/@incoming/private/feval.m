function [ e, h, siz ] = feval( obj, pos, varargin )
%  FEVAL - Evaluate incoming fields.
%
%  Usage for obj = multipole.incoming :
%    [ e, h, siz ] = eval( obj, pos, PropertyPairs )
%  Input
%    pos      :  positions for evaluation
%  PropertyName
%    shift    :  shift of coordinate system
%    rot      :  rotation matrix of coordinate system
%  Output
%    e,h      :  electromagnetic fields
%    siz      :  size of tailing dimensions

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'shift', [] );
addOptional( p, 'rot', [] );
%  parse input
parse( p, varargin{ : } );    

%  extract rotation and shift
[ rot, shift ] = deal( p.Results.rot, p.Results.shift );
npos = size( pos, 1 );
%  rotate and/or shift positions
if ~isempty( p.Results.rot ) && isempty( p.Results.shift )  
  pos = pagemtimes( pos, 'none', rot, 'transpose' );
elseif isempty( p.Results.rot ) && ~isempty( p.Results.shift )
  pos = arrayfun( @( i ) pos + shift( i, : ), 1 : size( shift, 1 ), 'uniform', 0 );
  pos = cat( 3, pos{ : } );
elseif ~isempty( p.Results.rot ) && ~isempty( p.Results.shift )  
  pos = pagemtimes( pos, 'none', rot, 'transpose' );
  pos = reshape( reshape( pos, npos, [] ) +  ...
                 reshape( transpose( shift ), 1, [] ), size( pos ) );
end  

%  number of position transformations
pos = permute( pos, [ 1, 3, 2 ] );
n = size( pos, 2 );
%  evaluate fields 
[ e, h ] = obj.fun( reshape( pos, [], 3 ), obj.k0 );
siz = size( e );
%  reshape fields
e = permute( reshape( e, npos, n, 3, [] ), [ 1, 3, 2, 4 ] );
h = permute( reshape( h, npos, n, 3, [] ), [ 1, 3, 2, 4 ] );
%  rotate fields 
if ~isempty( rot )
  e = pagemtimes( e, rot );
  h = pagemtimes( h, rot );
end
%  size of fields
siz = [ n, siz( 3 : end ) ];
if n == 1 && numel( siz ) > 1,  siz = siz( 2 : end );  end

