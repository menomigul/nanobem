function obj = init( obj, varargin )
%  Initialize rotation matrix.
%
%  Usage for obj = tweezer.rotation :
%    obj = init( obj, rot )
%    obj = init( 'quater', q )
%  Input
%    rot    :  rotation matrix
%    q      :  quaternions

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'rot', [] );
addParameter( p, 'quater', [] );
%  parse input
parse( p, varargin{ : } );

if isempty( p.Results.rot )
  obj.q = p.Results.quater;
  if size( obj.q, 2 ) ~= 4,  obj.q = transpose( obj.q );  end
else
  %  trace over rotation matrix
  rot = p.Results.rot;
  tr = squeeze( rot( 1, 1, : ) + rot( 2, 2, : ) + rot( 3, 3, : ) );
  %  slight rotation for tr = 0
  if any( tr == 0 )
    [ s, c ] = deal( sin( 1e-8 ), cos( 1e-8 ) );
    R = [ 1, 0, 0; 0, c, -s; 0, s, c ] *  ...
        [ c, 0, -s; 0, 1, 0; s, 0, c ] * [ c, -s, 0; s, c, 0; 0, 0, 1 ];
    rot( :, :, tr == 0 ) =  ...
      pagemtimes( R, pagemtimes( rot( :, :, tr == 0 ), R .' ) );
    tr = squeeze( rot( 1, 1, : ) + rot( 2, 2, : ) + rot( 3, 3, : ) );
  end
  %  convert from rotation matrix to quaternions
  s = 2 * sqrt( 1 + tr );
  obj.q = [ 0.25 * s,  ...
            squeeze( ( rot( 3, 2, : ) - rot( 2, 3, : ) ) ) ./ s,  ...
            squeeze( ( rot( 1, 3, : ) - rot( 3, 1, : ) ) ) ./ s,  ...
            squeeze( ( rot( 2, 1, : ) - rot( 1, 2, : ) ) ) ./ s ];
end
