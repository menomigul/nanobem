function obj = init( obj, varargin )
%  INIT - Initialize Mie solver.
%
%  Usage for obj = multipole.miesolver :
%    obj = init( obj, lmax )
%  Input
%    lmax     :  maximal degree for multipole expansion

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', 20 );
%  parse input
parse( p, varargin{ : } );

obj.lmax = p.Results.lmax;
[ obj.tab.l, obj.tab.m ] = sphtable( p.Results.lmax );
