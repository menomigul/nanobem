function D = diffusion( obj, varargin )
%  DIFFUSION - Diffusion coefficients for particle with polar symmetry.
%
%  Usage for obj = tweezer.fluidpol :
%    D = drift( obj, PropertyPairs )
%  PropertyName
%    trace    :  trace of Stokes coefficient
%  Output
%    D.t      :  diffusion coefficient for translation (mm^2/s)
%    D.r      :  diffusion coefficient for rotation (rad^2/s)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'trace', 0 );
%  parse input
parse( p, varargin{ : } );

%  nanometer and Boltzman constant
nm = 1e-9;
kb = 1.38e-23;
%  diffusion coefficients in (mm^2/s) and (rad^2/s)
drag = obj.drag;
D.t = - kb * obj.temp ./ ( drag.tt * nm     * obj.eta ) * 1e6;
D.r = - kb * obj.temp ./ ( drag.rr * nm ^ 3 * obj.eta );

if p.Results.trace
  D.t = mean( D.t );
  D.r = mean( D.r );
end
