%% tweezer.scatterer
%
% _tweezer.scatterer_ characterizes an optical T-matrix scatterer for
% tweezer simulations.
%
%% Initialization
% 
% Scatterers are initialized with a T-matrix and a function that provides
% the coefficients for the incoming fields, typically a _tweezer.incoming_
% object.

%  initialize scatterer for tweezer simulations
%    tmat     -  T-matrix for scatterer
%    qinc     -  function or functor that gives multipole coefficients for incoming fields
obj = tweezer.scatterer( tmat, qinc );

%%
% For tweezer simulations where the particle position does not change
% dramatically over time, one can also evaluate _qinc_ and translate it.
% For a spherical particle this can be done with.

%  evaluate multipole coefficients for incoming fields
qinc = eval( qinc );
%  functor for translation 
%    shift    -  shift vector
qinc = @( pos, ~ ) translate( qinc, shift );

%%
% For non-spherical particles one needs an additional rotation.

%  functor for translation and rotation
%    shift    -  shift vector
%    rot      -  rotation marix
qinc = @( pos, rot ) translate( rotate( qinc, rot ), pos );

%% Methods
%
% Once the _tweezer.scatterer_ is initialized, the following methods are
% available.

%  optical force for T-matrx scatterer
%    pos      -  positions of scatterers
%    rot      -  rotation matrices for scatterers
%    f        -  optical force (pN)
%    n        -  optical torque (pN×nm)
f = optforce( obj, pos );
[ f, n ] = optforce( obj, pos, rot );

%  multipole solution for scatterer
%    pos      -   positions of scatterers
%    rot      -  rotation matrices for scatterers
%   'frame'   -  'lab' for laboratory frame or 'particle' for particle frame
%   sol       -  multipole solution
sol = solve( obj, pos );
sol = solve( obj, pos, rot );
sol = solve( obj, pos, rot, 'frame', 'lab' );


%% Examples
%
% * <matlab:edit('demoforce02') demoforce02.m> |-| Force on spherical particle, 2d map.
% * <matlab:edit('demoforce03') demoforce03.m> |-| Force and torque for ellipsoid in OF2i setup.
%
% Copyright 2025 Ulrich Hohenester
