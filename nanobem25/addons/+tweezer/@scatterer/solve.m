function sol = solve( obj, pos, varargin )
%  SOLVE - Multipole solution for scatterer.
%
%  Usage for obj = tweezer.scatterer :
%    sol = solve( obj, pos, rot, PropertyPairs )
%  Input
%    pos    :  scatterer positions
%    rot    :  rotation matrix for scatterer
%  PropertyName
%    frame  :  'lab' or 'particle'
%  Output
%    sol      :  multipole solution

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'rot', [] );
addParameter( p, 'frame', 'lab' );
%  parse input
parse( p, varargin{ : } );

%  multipole solution in coordinate system of T-matrix
qinc = obj.qinc( pos, p.Results.rot );
sol = solve( obj.tmat, qinc );
%  rotate to laboratory frame
if ~isempty( p.Results.rot ) && strcmp( p.Results.frame, 'lab' )
  sol = rotate( sol, permute( p.Results.rot, [ 2, 1, 3 ] ), 'same', 1 );
end
