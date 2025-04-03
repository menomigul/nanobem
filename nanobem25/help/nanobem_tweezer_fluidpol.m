%% tweezer.fluidpol
%
% _tweezer.fluidpol_ accounts for the Stokes drag and diffusion of
% particles with polar symmetry in a fluid. We assume that the drag tensors
% for translation and rotation are diagonal and neglect possible drag
% couplings between translation and rotation.
%
%% Initialization

%  initialize Stokes drag and diffusion for particle in fluid
%     drag      -  diagonal components of drag tensor
%     vel       -  velocity of fluid in z-direction
fluid = tweezer.fluidpol( drag, vel );
%  modify default values for viscosity and temperature
fluid.eta = eta;      %  default viscosity is 9.544e-4 Pa×s
fluid.temp = temp;    %  default temperature is 293 K

%%
% For an ellipsoidal particle the _tweezer.fluidpol_ object can be
% initialized with

%  initialize Stokes drag for ellipsoid in fluid
fluid = tweezer.fluidellipsoid( diameter, ratio, vel );

%%
% For particles with arbitrary shape we provide the _tweezer.stokesdrag_
% function, as described in the corresponding help page.
%
%% Methods
%
% Once the _tweezer.fluidpol_ object is initialized, one can use the
% following methods

%  drift velocity for given force and torque
%    rot      -  rotation matrix for particle
%    ftot     -  total force acting on nanoparticle (pN)
%    ntot     -  total torque acting on particle (pN×nm)
%    vel      -  drift velocity (nm/s)
%    omega    -  angular velocity
[ vel, omega ] = drift( fluid, rot, ftot, ntot );

%  diffusion coefficients for particle with polar symmetry
%    D.t    -  diffusion coefficient for translation (mm^2/s)
%    D.r    -  diffusion coefficient for rotation (rad^2/s)
%    trace  -  compute mean of diagonal parts of drag tensors
D = diffusion( fluid );
D = diffusion( fluid, 'trace', 1 );

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

%% Examples
%
% * <matlab:edit('demotweezer02') demotweezer02.m> |-| Tweezer simulation for ellipsoidal particle.
% * <matlab:edit('demowalkerpol01') demowalkerpol01.m> |-| Propagate ellipsoidal walkers in OF2i setup.
% * <matlab:edit('demowalkerpol02') demowalkerpol02.m> |-| 3d plot of ellipsoidal walkers in OF2i setup.
%
% Copyright 2025 Ulrich Hohenester
