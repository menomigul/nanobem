function D = diffusion( obj )
%  DIFFUSION - Diffusion coefficients for spherical particle.
%
%  Usage for obj = tweezer.fluidsphere :
%    D = drift( obj )
%  Output
%    D.t      :  diffusion coefficient for translation (mm^2/s)
%    D.r      :  diffusion coefficient for rotation (rad^2/s)

%  radius of sphere (m) and Boltzman constant
a = 0.5e-9 * obj.diameter;
kb = 1.38e-23;
%  diffusion coefficients in (mm^2/s) and (rad^2/s)
D.t = kb * obj.temp / ( 6 * pi * a     * obj.eta ) * 1e6;
D.r = kb * obj.temp / ( 8 * pi * a ^ 3 * obj.eta );
