function obj = refresh( obj, pos )
%  REFRESH - Re-evaluate gridded data if needed.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    obj = refresh( obj, pos )
%  Input
%    pos  :  requested positions for interpolation

%  refresh only in case of r-grid
if numel( obj.z ) <= 1
  %  unique z-values for interpolation ?
  assert( isscalar( unique( round( pos( :, 3 ), 5 ) ) ) );
  z = pos( 1, 3 );
  %  re-evaluate gridded data ?
  if isempty( obj.z ) || abs( obj.z - z ) > 1e-8
    obj = eval( obj, z );
  end
end
