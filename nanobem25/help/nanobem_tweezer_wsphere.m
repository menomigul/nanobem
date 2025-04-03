%% tweezer.walkersphere
%
% Tweezer simulations of nanospheres subject to optical and fluidic
% forces are performed with the _tweezer.walkersphere_ class.
%
%% Initialization
% 
% Walkers are initialized by providing the following information.

%  initialize walker for spherical particles in tweezer simulations
%    scatterer    -  optical force evaluator for spherical particle
%    fluid        -  Stokes drag and diffusion for spherical particle
%    pos          -  initial walker positions
walker = tweezer.walkersphere( scatterer, fluid, pos );

%%
% Alternatively the positions can be set after initialization.

%  set walker positions after initialization
walker.pos = pos;

%% Methods
%
% Once the _tweezer.walkersphere_ is initialized, the following methods are
% available.

%  trapping position for particles starting at the walker positions
%    dir    -  direction along which trap position is determined
walker = trap( walker, dir );

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
% * <matlab:edit('demotrapsph01') demotrapsph01.m> |-| Trapping position for spherical walkers in OF2i setup.
% * <matlab:edit('demowalkersph01') demowalkersph01.m> |-| Propagate spherical walkers in OF2i setup.
%
% Copyright 2025 Ulrich Hohenester
