function obj = browniant( obj, tout, varargin )
%  BROWNIANT - Propagate walkers in time and presence of Brownian motion.
%
%  Usage for obj = tweezer.walkersphere :
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

%  initial positions 
pos = obj.pos;
%  initial velocity
fopt = optforce( obj.scatterer, pos );
vel = drift( obj.fluid, fopt );
%  allocate output
obj = repelem( obj, 1, numel( tout ) );
obj( 1 ).vel = vel;
%  show waitbar
name = 'walkersphere.browniant';
if p.Results.waitbar,  multiWaitbar( name, 0, 'Color', 'g' );  end


%  loop over propagation distances
for it = 2 : numel( tout )
  %  increment in time
  dt = ( tout( :, it ) - tout( :, it - 1 ) ) / p.Results.nsub;
  %  loop over sub-intervals
  for i1 = 1 : p.Results.nsub
    %  update positions and times
    fopt = optforce( obj( 1 ).scatterer, pos );
    pos = browniant( obj( 1 ).fluid, pos, fopt, dt );
  end
  
  %  save output
  dt = tout( :, it ) - tout( :, it - 1 );
  obj( it ).pos = pos;
  obj( it ).vel = ( pos - obj( it - 1 ).pos ) ./ dt;
  %  update waitbar
  if p.Results.waitbar && ~mod( it, p.Results.waitbar )
    multiWaitbar( name, it / numel( tout ) );  
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( 'CloseAll' );  end
