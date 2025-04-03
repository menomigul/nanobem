%% tweezer.griddedScatterer
%
% For spherical scatterers one can set up a force grid for the fast
% evaluation of optical forces for many walkers, typically up to a million.
% A similar class exists for scatterers with cylinder symmetry, which,
% however, is significantly slower.
%
%% tweezer.griddedScattererSphere
% 
% The grid for optical forces is set up with

%  initialize optical force grid for spherical scatterer
%    scatterer    -  optical force evaluator for particle
%    r            -  grid of radii
%    z            -  single z-value (optional) or grid thereof
%    lmax         -  maximal order for azimuthal Fourier expansion  
grid = tweezer.griddedScsttererSphere( scatterer, r, z, 'lmax', lmax );

%%
% We perform a Fourier transform in the azimuthal direction for the gridded
% data, where _lmax_ controls the maximal order. After initialization, the
% grid object can be used similarly to the _multipole.scatterer_ object and
% can be directly passed to the functions of the _tweezer.walkersphere_
% class. For simulations with propagation in the z-direction using the
% functions _propagatez_ and _brownianz_ one typically uses only a single
% z-value in the initialization or omits the value.
%
% Once the _tweezer.griddedScattererSphere_ object is initialized, the
% optical force can be computed with

%  evaluate grid for given propagation distance (optional)
%    z    -  single propagation distance where forces are evaluated
grid = eval( grid, z );
%  optical force for many walker positions
%    pos    -  positiosn where force is requested
f = optforce( grid, pos );

%% tweezer.griddedScattererPol
%
% Same as _tweezer.griddedScattererSphere_ but for scatterers with cylinder
% symmetry. For the azimuthal direction of the grid we perform a Fourier
% transform that is controlled by _lmax(1)_. For the orientation of the
% scatterer we perform a spherical-harmonics transformation that is
% controlled by _lmax(2)_. Alternatively one can also pass a single _lmax_
% value.

%  initialize optical force grid for scatterer with cylinder symmetry
%    scatterer    -  optical force evaluator for particle
%    r            -  grid of radii
%    z            -  single z-value (optional) or grid thereof
%    lmax         -  maximal order for azimuthal Fourier and multipole expansion  
grid = tweezer.griddedScsttererPol( scatterer, r, z, 'lmax', lmax );

%%
% Once the _tweezer.griddedScattererPol_ object is initialized, the optical
% force and torque can be computed with

%  evaluate grid for given propagation distance (optional)
%    z    -  single propagation distance where forces are evaluated
grid = eval( grid, z );
%  optical force for many walker positions
%    pos    -  positiosn where force is requested
%    rot    -  corresponding rotation matrices
[ f, n ] = optforce( grid, pos, rot );

%% Examples
%
% * <matlab:edit('demowalkersph04') demowalkersph04.m> |-| Histogram for Brownian motion and spheres.
% * <matlab:edit('demowalkerpol05') demowalkerpol05.m> |-| Histogram for Brownian motion and ellipsoids.
%
% Copyright 2025 Ulrich Hohenester
