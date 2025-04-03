function [ obj, tout ] = brownianz( obj, zout, varargin )
%  BROWNIANZ - Propagate walkers along z in presence of Brownian motion.
%
%  Usage for obj = tweezer.walkersphere :
%    [ obj, tout ] = brownianz( obj, zout, PropertyPairs )
%  Input
%    zout     :  propagation distances where output is requested
%  PropertyName
%    nsub     :  number of sub-intervals for solution
%    waitbar  :  show waitbar
%  Output
%    walker   :  array of walkers
%    tout     :  output times

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nsub', 1 );
addParameter( p, 'waitbar', 0 );
%  parse input
parse( p, varargin{ : } );

%  initial positions and times
pos = obj.pos;
tout = zeros( size( pos, 1 ), numel( zout ) );
%  initial velocity
fopt = optforce( obj.scatterer, pos );
vel = drift( obj.fluid, fopt );
%  allocate output
obj = repelem( obj, 1, numel( zout ) );
obj( 1 ).vel = vel;
%  show waitbar
name = 'walkersphere.brownianz';
if p.Results.waitbar,  multiWaitbar( name, 0, 'Color', 'g' );  end


%  loop over propagation distances
for iz = 2 : numel( zout )
  %  spatial increments and initial time
  dz = ( zout( iz ) - zout( iz - 1 ) ) / p.Results.nsub;
  tout( :, iz ) = tout( :, iz - 1 );
  %  loop over sub-intervals
  for i1 = 1 : p.Results.nsub
    %  update positions and times
    fopt = optforce( obj( 1 ).scatterer, pos );
    [ pos, dt ] = brownianz( obj( 1 ).fluid, pos, fopt, dz );
    tout( :, iz ) = tout( :, iz ) + dt;
  end
  
  %  save output
  dt = tout( :, iz ) - tout( :, iz - 1 );
  obj( iz ).pos = pos;
  obj( iz ).vel = ( pos - obj( iz - 1 ).pos ) ./ dt;
  %  update waitbar
  if p.Results.waitbar && ~mod( iz, p.Results.waitbar ) 
    multiWaitbar( name, iz / numel( zout ) );  
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( 'CloseAll' );  end
