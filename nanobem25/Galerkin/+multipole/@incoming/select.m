function obj = select( obj, fun )
%  SELECT - Select specific multipole elements.
%
%  Usage for obj = multipole.incoming :
%    t = select( obj, fun )
%  Input
%    fun  :  function handle @(m,l) or index to selected elements 
%  Output
%    obj  :  incoming multipole elements with selected elements

%  deal with function handle
tab = obj( 1 ).tab;
switch class( fun )
  case 'function_handle'
    ind = fun( tab.m, tab.l );
  otherwise
    ind = fun;
end

switch numel( obj )
  case 1
    obj.tab = struct( 'l', tab.l( ind ), 'm', tab.m( ind ) );    
    obj.a = obj.a( ind, : );
    obj.a = obj.b( ind, : );
  otherwise
    obj = arrayfun( @( x ) select( x, ind ), obj, 'uniform', 1 );
end
