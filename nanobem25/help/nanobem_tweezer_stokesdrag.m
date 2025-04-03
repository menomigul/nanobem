%% tweezer.stokesdrag
%
% The nanobem toolbox allows to compute the drag tensors for particles with
% arbitrary shape, following the approach described in
%
% * H. Power and G. Miranda, SIAM J. Appl. Math. 47, 689 (1987).
%
% Users must provide the discretized boundary of the particle using a
% _particle_ object provided by the toolbox.  Once the particle boundary is
% specified, the drag tensors can be computed through

%  drag tensor for Stokes flow around a particle
%    p      -  particle object for discretized nanoparticle, see Base classes>Particle help page
%    rules  -  quadrature rule
drag = tweezer.stokesdrag( p, varargin );

%%
% _drag_ is a structure with the different translational, rotational, and
% mixing tensors. For instance, for an ellispsoid with an axis ratio of 1:2
% the drag tensors can be computed through

%  diameter and axis ratio of ellipsoid
diameter = 50;
ratio = 2;
%  initialize ellipsoid
p = transform( trisphere( 400, diameter ), 'scale', [ 1, 1, ratio ] );
%  compute drag tensor
drag = tweezer.stokesdrag( p )

%%
%  drag = 
% 
%    struct with fields:
% 
%      tt: [3×3 double]
%      tr: [3×3 double]
%      rt: [3×3 double]
%      rr: [3×3 double]
%
% Users might like to compare the results with the analytic expressions
% provided by the _tweezer.dragellipsoid_ function.
%
% *Examples*
%
% * <matlab:edit('demostokes01') demostokes01.m> |-| Stokes drag for
% ellipsoid.
%
% Copyright 2025 Ulrich Hohenester
