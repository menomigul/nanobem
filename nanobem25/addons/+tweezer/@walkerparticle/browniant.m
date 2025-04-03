function obj = browniant( obj, tout, varargin )
%  BROWNIANT - Propagate walkers in time and presence of Brownian motion.
%
%  Usage for obj = tweezer.walkerparticle :
%    obj = browniant( obj, tout, PropertyPairs )
%  Input
%    tout     :  output times
%  PropertyName
%    nsub     :  number of sub-intervals for solution
%    waitbar  :  show waitbar
%  Output
%    obj      :  array of walkers

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nsub', 1 );
addParameter( p, 'waitbar', 0 );
%  parse input
parse( p, varargin{ : } );

%  initial positions and rotation matrix
pos = obj.pos;
rot = obj.rot;
%  initial velocity
[ fopt, nopt ] = optforce( obj.scatterer, pos, rot );
vel = drift( obj.fluid, rot, fopt, nopt );
%  allocate output
obj = repelem( obj, 1, numel( tout ) );
obj( 1 ).vel = vel;
%  show waitbar
name = 'walkerparticle.browniant';
if p.Results.waitbar,  multiWaitbar( name, 0, 'Color', 'g' );  end


%  loop over propagation distances
for it = 2 : numel( tout )
  %  increment in time
  dt = ( tout( :, it ) - tout( :, it - 1 ) ) / p.Results.nsub;
  %  loop over sub-intervals
  for i1 = 1 : p.Results.nsub
    %  update positions and times
    [ fopt, ntot ] = optforce( obj( 1 ).scatterer, pos, rot );
    [ pos, rot ] = browniant( obj( 1 ).fluid, pos, rot, fopt, ntot, dt );
  end
  
  %  save output
  dt = tout( :, it ) - tout( :, it - 1 );
  obj( it ).pos = pos;
  obj( it ).rot = rot;
  obj( it ).vel = ( pos - obj( it - 1 ).pos ) ./ dt;
  %  update waitbar
  if p.Results.waitbar && ~mod( it, p.Results.waitbar )
    multiWaitbar( name, it / numel( tout ) );  
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( 'CloseAll' );  end
