function a = amplitude( obj, k0 )
%  AMPLITUDE - Field amplitude for given input power and light frequency.
%
%  Usage for obj = gaussfocus :
%    a = amplitude( obj, k0 )
%  Input
%    k0   :  wavenumber of light in vacuum
%  Output
%    a    :  field amplitude

Z = 376.730 * obj.mat.Z( k0 );
a = sqrt( Z * obj.pow / ( 4 * pi ^ 3 ) ) / obj.w0;
