function varargout = feval( obj, pos )
%  FEVAL - Interpolation of additional gridded data.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    [ f1, f2, ... ] = feval( obj, pos )
%  Input
%    pos    :  positions where fields are evaluated
%  Output
%    f1     :  interpolated data

obj = refresh( obj, pos );
varargout = cellfun( @( x ) igrid( obj, x, pos ), obj.data, 'uniform', 0 );
