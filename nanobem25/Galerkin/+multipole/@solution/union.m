function obj = union( obj, varargin )
%  UNION - Combine multiple multipole solutions into single one.
%
%  Usage for obj = multipole.solution :
%    obj = union( obj, shift )
%  Input
%    shift  :  translation vector (optional)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'shift', [] );
%  parse input
parse( p, varargin{ : } );

%  shift multipoles ?
if ~isempty( p.Results.shift )
  for i1 = 1 : numel( obj )
    obj( i1 ) = translate( obj( i1 ), p.Results.shift( i1, : ) );
  end
end
%  put together multipoles
for it = 2 : numel( obj )
for name = [ "a", "b", "ai", "bi" ]
  obj( 1 ).( name ) = obj( 1 ).( name ) + obj( it ).( name );
end
end
%  set output
obj = obj( 1 );

