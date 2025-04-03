function status = waitbar( zout, nz, z, ~, flag )
%  WAITBAR - Show waitbar during solution of ODE equation.

if isempty( flag )
  [ ~, iz ] = ismember( z( end ), zout );
  if ~mod( iz, nz ),  multiWaitbar( 'walkerparticle', iz / numel( zout ) );  end
elseif strcmp( flag, 'init' )
  multiWaitbar( 'walkerparticle', 0, 'Color', 'g' );
elseif strcmp( flag, 'done' )
  multiWaitbar( 'CloseAll' );
end

%  clear status flag
status = 0;
