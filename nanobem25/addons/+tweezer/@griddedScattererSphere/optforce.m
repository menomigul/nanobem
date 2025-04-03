function f = optforce( obj, pos )
%  OPTFORCE - Optical force interpolation from gridded data.
%
%  Usage for obj = tweezer.griddedScattererSphere :
%    f = optforce( obj, pos )
%  Input
%    pos    :  positions where force is evaluated
%  Output
%    f      :  optical force

obj = refresh( obj, pos );
f = igrid( obj, obj.f, pos );  
