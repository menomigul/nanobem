function obj = init( obj, mat, k0, fun, varargin )
%  Initialize multipole solution.
%
%  Usage for multipole.incoming :
%    obj = init( obj, mat, k0, fun, PropertyPairs )
%  Input
%    mat        :  material properties of embedding medium
%    k0         :  wavenumber of light in vacuum
%    fun        :  incoming fields [e,h]=fun(pos,k0) 
%  PropertyName
%    diameter   :  diameter for multipole expansion
 
%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'diameter', [] );
%  parse input
parse( p, varargin{ : } );    

%  save input 
[ obj.mat, obj.k0, obj.fun ] = deal( mat, k0, fun );
%  diameter for multipole expansion
if isempty( p.Results.diameter )
  %  estimate diameter from Wiscombe cutoff parameter
  x = fzero( @( x ) x + 2 + 4.05 * abs( x ) .^ ( 1 / 3 ) - obj.lmax, 1 );
  obj.diameter = 2 * x / mat.k( k0 );
else
  obj.diameter = p.Results.diameter;
end
