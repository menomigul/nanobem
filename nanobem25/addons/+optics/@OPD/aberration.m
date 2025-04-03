function field = aberration( obj, lens, field, varargin )
%  ABERRATION - Add aberration factor to field.
%
%  Usage for obj = optics.OPD :
%    field = aberration( obj, lens, field, varargin )
%  Input
%    lens   :  imaging lens w/o abberation
%    field  :  electric far-fields or planewave decomposition
%  PropertyName
%    focus  :  focus position of imaging lens
%  Output
%     e     :  electric image fields in focal plane

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'focus', [ 0, 0, 0 ] );
%  parse input
parse( p, varargin{ : } );

%  light propagation direction
switch class( field )
  case 'double'
    dir = lens.dir;
  case 'optics.decompose'
    dir = field.dir;
end

%  correct OPD for defocusing
q = obj.n( end ) * lens.k0 - lens.mat1.k( lens.k0 );
field = field .* exp( 1i * q * dir * p.Results.focus .' );
%  optical path length difference
dir = dir * lens.rot;
kpar = lens.k0 * obj.n( 1 ) * sqrt( sum( dir( :, 1 : 2 ) .^ 2, 2 ) );
len = path( obj, kpar, lens.k0 ) - path( obj, kpar, lens.k0, 'star' );
%  add aberration factor
field = exp( 1i * len ) .* field;
