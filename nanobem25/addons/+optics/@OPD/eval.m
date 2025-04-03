function [ field, P ] = eval( obj, lens, varargin )
%  EVAL - Planewave decomposition of focal fields including aberration.
%
%  Usage for obj = optics.OPD :
%    [ field, P ] = eval( obj, lens, efield, PropertyPairs )
%  Input
%    lens       :  focusing lens w/o aberration
%    efield     :  incoming electric field before Gaussian sphere
%  PropertyName
%    focus      :  focus position 
%  Output
%    field      :  planewave decomposition of focal fields
%    P          :  incoming power

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'focus', [ 0, 0, 0 ] );
%  parse input
ind = find( cellfun( @ischar, varargin, 'uniform', 1 ), 1 );
parse( p, varargin{ ind : end } );

%  wavenumber difference of OPD and lens
q = obj.n( end ) * lens.k0 - lens.mat.k( lens.k0 );
%  focus fields w/o abberation
[ field, P ] = eval( lens, varargin{ : } );
field.efield = exp( - 1i * q * field.dir * p.Results.focus .' );

%  optical path length difference
dir = field.dir * lens.rot;
kpar = lens.k0 * obj.n( 1 ) * sqrt( sum( dir( :, 1 : 2 ) .^ 2, 2 ) );
len = path( obj, kpar, field.k0 ) - path( obj, kpar, field.k0, 'star' );
%  add abberation factor
field.efield = exp( 1i * len ) .* field.efield;
