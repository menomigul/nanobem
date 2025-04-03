%% tweezer.fluidparticle
%
% _tweezer.fluidarticle_ accounts for the Stokes drag and diffusion of
% particles without any special symmetry in a fluid. For the initialization
% we need the drag tensors for translation, rotation, and their coupling,
% as computed e.g. with the _optics.stokesdrag_ function.
%
%% Initialization

%  initialize Stokes drag and diffusion for particle in fluid
%     drag      -  drag tensor with components 'tt', 'tr', 'rt', 'tt'
%     vel       -  velocity of fluid in z-direction
fluid = tweezer.fluidartucle( drag, vel );
%  modify default values for viscosity and temperature
fluid.eta = eta;      %  default viscosity is 9.544e-4 Pa×s
fluid.temp = temp;    %  default temperature is 293 K

%% Methods
%
% Once the _tweezer.fluidparticle_ object is initialized, one can use the
% following methods

%  drift velocity for given force and torque
%    rot      -  rotation matrix for particle
%    ftot     -  total force acting on nanoparticle (pN)
%    ntot     -  total torque acting on particle (pN×nm)
%    vel      -  drift velocity (nm/s)
%    omega    -  angular velocity
[ vel, omega ] = drift( fluid, rot, ftot, ntot );

%  propagate particle in time using drift and diffusion
%    pos      -  initial positions of particle
%    rot      -  initial rotation matrix for particle
%    ftot     -  total force acting on particle (pN)
%    ntot     -  total torque acting on particle (pN×nm)
%    dt       -  time increment
[ pos, rot ] = browniant( fluid, pos, rot, ftot, ntot, dt );

%  propagate particle in space using drift and diffusion
%    pos      -  initial positions of particle
%    rot      -  initial rotation matrix for particle
%    ftot     -  total force acting on particle (pN)
%    ntot     -  total torque acting on particle (pN×nm)
%    dz       -  space increment
%    dt       -  time increment
[ pos, rot, dt ] = brownianz( fluid, pos, rot, ftot, ntot, dz );

%%
% Copyright 2025 Ulrich Hohenester
