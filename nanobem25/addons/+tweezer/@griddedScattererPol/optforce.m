function [ f, n ] = optforce( obj, pos, rot )
%  OPTFORCE - Optical force and torque interpolation from gridded data.
%
%  Usage for obj = tweezer.griddedScattererPol :
%    [ f, n ] = optforce( obj, pos, rot )
%  Input
%    pos    :  positions where force and torque are evaluated
%    rot    :  corresponding rotation matrices 
%  Output
%    f      :  optical force

obj = refresh( obj, pos );
f = igrid( obj, obj.f, pos, rot );  
n = igrid( obj, obj.n, pos, rot );
