function varargout = efield( obj, lens, field, varargin )
%  EFIELD - Electric field on image side including aberration.
%
%  Usage for obj = optics.OPD :
%    e = efield( obj, lens, field, varargin )
%  Input
%    lens   :  imaging lens w/o aberration
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
ind = find( cellfun( @ischar, varargin, 'uniform', 1 ), 1 );
parse( p, varargin{ ind : end } );

field = aberration( obj, lens, field, 'focus', p.Results.focus );
[ varargout{ 1 : nargout } ] = efield( lens, field, varargin{ : } );
