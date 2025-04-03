function obj = init( obj, tmat, qinc )
%  INIT - Initialize optical T-matrix scatterer.
%
%  Usage for tweezer.scatterer :
%    obj = init( tmat, qinc )
%  Input
%    tmat   :  T-matrix for scatterer
%    qinc   :  multipole coefficients for incoming fields

%  save input
obj.tmat = tmat;
obj.qinc = qinc;
%  auxiliary data for optical force evaluation
[ q.a, q.b ] = deal( zeros( size( tmat.tab.l ) ) );
[ ~, ~, obj.data ] = optforce( solve( tmat, q ) );
