function [ e, h ] = paraxial( obj, pos, k0, varargin )
%  PARAXIAL - Electromagnetic fields in paraxial approximation.
%
%  Usage for obj = gaussfocus :
%    [ e, h ] = paraxial( obj, pos, k0, PropertyPairs )
%  Input
%    pos    :  positions where fields are evaluated
%    k0     :  wavenumber of light in vacuum
%  PropertyName
%    shift  :  additional shift of positions
%  Output
%    e,h    :  electromagnetic fields in paraxial approximation

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'shift', [] );
%  parse input
parse( p, varargin{ : } );

%  additional shift of positions
if ~isempty( p.Results.shift )
  pos = tensor( pos, [ 1, 2 ] ) + tensor( p.Results.shift, [ 3, 2 ] );
  pos = reshape( double( pos, [ 1, 3, 2 ] ), [], 3 );
end

%  convert positions to cylinder coordinates
[ x, y ] = deal( pos( :, 1 ), pos( :, 2 ) );
[ u, r, z ] = cart2pol( x, y, pos( :, 3 ) );
%  wavenmumber and impedance
[ k, Z ] = deal( obj.mat.k( k0 ), obj.mat.Z( k0 ) );

%  waist
zr = 0.5 * k * obj.w0 ^ 2;
w = obj.w0 * sqrt( 1 + 1i * z ./ zr );
%  scalar solution
x = 0.5 * r .^ 2 ./ w .^ 2;
u1 = 2 * pi ^ 1.5 * r * obj.w0 ^ 2 ./ w .^ 3 .*  ...
                        exp( - x ) .* ( besseli( 0, x ) - besseli( 1, x ) );
%  electromagnetic fields
a = amplitude( obj, k0 ) .* exp( 1i * k * z );
e = - a .* u1 .* [ - sin( u ),   cos( u ), 0 * u ];
h = - a .* u1 .* [ - cos( u ), - sin( u ), 0 * u ] / Z;
%  z-component of magnetic field
u2 = 4 * pi ^ 1.5 * obj.w0 ^ 2 ./ ( k * w .^ 5 ) .* exp( - x ) .*  ...
  ( ( w .^ 2 - r .^ 2 ) .* besseli( 0, x ) + r .^ 2 .* besseli( 1, x ) );
h( :, 3 ) = 1i * a .* u2 / Z;

%  deal with additional shift of positions
if ~isempty( p.Results.shift )
  e = permute( reshape( e, [], size( p.Results.shift, 1 ), 3 ), [ 1, 3, 2 ] );
  h = permute( reshape( h, [], size( p.Results.shift, 1 ), 3 ), [ 1, 3, 2 ] );
end
