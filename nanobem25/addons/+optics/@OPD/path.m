function len = path( obj, kpar, k0, varargin )
%  PATH - Optical path length through stratified medium.
%
%  Usage for obj = optics.OPD :
%    len = path( kpar, k0 )
%    len = path( kpar, k0, 'star' )
%  Input
%    kpar     :  parallel momenta
%    k0       :  wavenumber of light in vacuum

%  refractice indices and thicknesses
if ~isempty( varargin ) && strcmp( varargin{ 1 }, 'star' )
  [ n, t ] = deal( obj.nstar, obj.tstar );
else
  [ n, t ] = deal( obj.n, obj.t );
end
%  allocate output
len = zeros( size( kpar ) );

%  loop over layers
for it = 1 : numel( n )
  theta = asin( kpar / ( k0 * n( it ) ) );
  len = len + t( it ) * n( it ) ./ cos( theta );
end
%  optical path length
len = k0 * len;
