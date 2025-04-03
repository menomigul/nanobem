%% tweezer.fluidsphere
%
% _tweezer.fluidsphere_ accounts for the Stokes drag and diffusion of
% a sphereical particle in a fluid.
%
%% Initialization

%  initialize Stokes drag and diffusion for sphere in fluid
%     diameter    -  diameter of sphere
%     vel         -  velocity of fluid in z-direction
fluid = tweezer.fluidsphere( diameter, vel );
%  modify default values for viscosity and temperature
fluid.eta = eta;      %  default viscosity is 9.544e-4 Pa×s
fluid.temp = temp;    %  default temperature is 293 K

%% Methods
%
% Once the _tweezer.fluidsphere_ is initialized, one can use the following
% methods

%  drift velocity for given force
%    ftot     -  total force acting on nanoparticle (pN)
%    vel      -  drift velocity (nm/s)
vel = drift( obj, ftot );

%  diffusion coefficients for spherical particle
%    D.t    -  diffusion coefficient for translation (mm^2/s)
%    D.r    -  diffusion coefficient for rotation (rad^2/s)
D = diffusion( fluid );

%  propagate particle in time using drift and diffusion
%    pos      -  initial positions of particle
%    ftot     -  total force acting on particle (pN)
%    dt       -  time increment
pos = browniant( fluid, pos, ftot, dt );

%  propagate particle in space using drift and diffusion
%    pos      -  initial positions of particle
%    ftot     -  total force acting on particle (pN)
%    dz       -  space increment
%    dt       -  time increment
[ pos, dt ] = brownianz( fluid, pos, ftot, dz );

%% Examples
%
% * <matlab:edit('demotweezer01') demotweezer01.m> |-| Tweezer simulation for spherical particle.
% * <matlab:edit('demotrapsph01') demotrapsph01.m> |-| Trapping position for spherical walkers in OF2i setup.
% * <matlab:edit('demowalkersph01') demowalkersph01.m> |-| Propagate spherical walkers in OF2i setup.
%
% Copyright 2025 Ulrich Hohenester
