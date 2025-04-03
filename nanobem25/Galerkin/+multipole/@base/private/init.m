function obj = init( obj, varargin )
%  INIT - Initialize spherical degrees and orders.
%
%  Usage :
%    obj = multipole.base( lmax )
%  Input
%    lmax     :  maximal degree for multipole expansion

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', 10 );
%  parse input
parse( p, varargin{ : } );

[ obj.tab.l, obj.tab.m ] = sphtable( p.Results.lmax );
