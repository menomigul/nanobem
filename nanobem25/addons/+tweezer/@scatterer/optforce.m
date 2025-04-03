function [ f, n, sol ] = optforce( obj, pos, varargin )
%  SOLVE - Optical force for T-matrix scatterer.
%
%  Usage for obj = tweezer.scatterer :
%    [ f, n, sol ] = optforce( obj, pos, rot )
%  Input
%    pos    :  scatterer positions
%    rot    :  rotation matrix for scatterer
%  Output
%    f      :  optical force
%    n      :  optical torque
%    sol    :  multipole solution

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'rot', [] );
%  parse input
parse( p, varargin{ : } );

%  multipole solution in coordinate system of T-matrix
qinc = obj.qinc( pos, p.Results.rot );
sol = solve( obj.tmat, qinc );
%  optical force in coordinate system of T-matrix
[ f, n ] = optforce( sol, 'data', obj.data );
%  rotate to laboratory frame
if ~isempty( p.Results.rot )
  for it = 1 : size( p.Results.rot, 3 )
    f( it, : ) = f( it, : ) * p.Results.rot( :, :, it ) .';
    n( it, : ) = n( it, : ) * p.Results.rot( :, :, it ) .';
  end
end
  