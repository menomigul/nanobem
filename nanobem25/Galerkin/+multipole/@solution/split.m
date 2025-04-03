function obj = split( obj )
%  SPLIT - Split multipole solutions into solution array.
%
%  Usage for obj = multipole.solution :
%    obj = split( obj )

%  copies of object
n = size( reshape( obj.a, size( obj.a, 1 ), [] ), 2 );
obj = repelem( obj, 1, n );
%  set multipole coefficients for each copy
for i1 = 1 : n
for name = [ "a", "b", "ai", "bi" ]
  obj( i1 ).( name ) = obj( i1 ).( name )( :, i1 );
end
end
