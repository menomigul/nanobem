%% multipole.incoming
%
% _multipole.incoming_ performs a multipole expansion for the incoming
% fields.
%
%% Initialization
%
% The multipole expansion for the incoming fields is initialized through

%  Initialize multipole expansion for incoming fields
%    mat        -  material properties of embedding medium
%    k0         -  wavenumber of light in vacuum
%    fun        -  incoming fields [e,h]=fun(pos,k0) 
%   'lmax'      -  maximum of spherical degrees
%   'diameter'  -  diameter for multipole expansion
qinc = multipole.incoming( mat, k0, fun, 'lmax', lmax, 'diameter', diameter );

%%
% _diameter_ specifies the sphere diameter over which the coefficients for
% the incoming fields are evaluated, see Eq. (E.5) of Hohenester, Nano and
% Qantum Optics (2020). If the parameter is not specified, the diameter is
% selected using the Wiscombe cutoff parameter.

%% Methods

%  evaluate multipole coefficients for incoming fields
%    shift    -  shift origin for multipole expansion
%    rot      -  rotation matrix for coordinate system of multipole expansion
qinc = eval( qinc, shift );
qinc = eval( qinc, shift, 'rot', rot );

%% 
% After the evaluation, _qinc.a_ and _qinc.b_ store the multipole
% coefficients for the incoming fields. The incoming multipole
% coefficiensts can be also rotated and translated.

%  rotate multipole solution SOL
%    rot      -  rotation matrix of size 3×3 or 3×3×n
%   'same'    -  dimensions of multipole solution match n, rotate each coefficient separately
qinc = rotate( qinc, rot );
qinc = rotate( qinc, rot, 'same', 1 );
%  translate origin for multipoles
%    shift      -  shift vector for multipole translation of size 3×3 or 3×3×n
%   'same'    -  dimensions of multipole solution match n, rotate each coefficient separately
qinc = translate( qinc, shift );
qinc = translate( qinc, shift, 'same', 1 );

%% 
%
% Copyright 2024 Ulrich Hohenester

