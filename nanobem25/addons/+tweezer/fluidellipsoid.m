function obj = fluidellipsoid( diameter, ratio, varargin )
%  Initialize Stokes drag for ellipsoid in fluid.
%
%  Usage :
%    obj = tweezer.fluidellipsoid( diameter, ratio, vel, PropertyPairs )
%  Input
%    diameter   :  diameter of ellipsoid (nm)
%    ratio      :  axes ratio
%    vel        :  fluid velocity (m/s)
%  Output
%    obj        :  tweezer.fluidpol object for ellipsoid

%  drag tensor for ellipsoid
drag = tweezer.dragellipsoid( diameter, ratio );
%  Stokes drag and diffusion for particle with polar symmetry
obj = tweezer.fluidpol( drag, varargin{ : } );
