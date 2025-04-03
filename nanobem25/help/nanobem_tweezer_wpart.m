%% tweezer.walkerparticle
%
% Tweezer simulations of particles subject to optical and fluidic forces
% are performed with the _tweezer.walkerparticle_ class.
%
%% Initialization
% 
% Walkers are initialized by providing the following information.

%  initialize walker for particles in tweezer simulations
%    scatterer    -  optical force evaluator for particle
%    fluid        -  Stokes drag and diffusion for particle
%    pos          -  initial walker positions
%    rot          -  rotation matrix or matrices for particles
walker = tweezer.walkerparticle( scatterer, fluid, pos, rot );

%%
% The rotation matrix must rotate the particle into the proper orientatuon
% within the laboratory frame. Alternatively the positions can be set after
% initialization.

%  set walker positions and orientations after initialization
walker.pos = pos;
walker.rot = rot;

%% Methods
%
% Once the _tweezer.walkerparticle_ is initialized, the following methods
% are available.

%  propagate walker in time and in presence of optofluidic forces
%    tout       -  output times
%    solver     -  'ode23' or 'ode45' (default)
%    waitbar    -  show waitbar during ODE solution
%    wout       -  array of walkers with positions and velocities at output times
wout = propagatet( walker, tout, 'solver', 'ode45', 'waitbar', 1 );

%  propagate walker in space and in presence of optofluidic forces
%    zout       -  propagation distances where output is requested
%    tout       -  output times
[ wout, tout ] = propagatez( walker, tout, 'solver', 'ode45', 'waitbar', 1 );

%%
% Additionally, one can also perform simulations under consideration of
% Brownian motion.

%  propagate walker in time using Brownian motion and optofluidic forces 
%    tout       -  output times
%    nsub       -  divide each time interval into NSUB sub-intervals
%    waitbar    -  show waitbar during evaluation
%    wout       -  array of walkers with positions and velocities at output times
wout = browniant( walker, zout, 'nsub', 10, 'waitbar', 1 );

%  propagate walker in space using Brownian motion and optofluidic forces 
%    zout       -  propagation distances where output is requested
%    tout       -  walker times at ZOUT
[ wout, tout ] = brownianz( walker, zout, 'nsub', 10, 'waitbar', 1 );

%% Examples
%
% * <matlab:edit('demowalkerpol01') demowalkerpol01.m> |-| Propagate ellipsoidal walkers in OF2i setup.
% * <matlab:edit('demowalkerpol02') demowalkerpol02.m> |-| 3d plot of ellipsoidal walkers in OF2i setup.
% * <matlab:edit('demowalkerpol03') demowalkerpol03.m> |-| Light scattering for ellipsodial walkers in OF2i setup.
%
% Copyright 2025 Ulrich Hohenester
