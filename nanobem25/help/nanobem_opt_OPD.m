%% optics.OPD
%
% _optics.lensfocus_ allows to account for aberration effects due to
% optical path difference (OPD). For detail see e.g.
%
% * Mahmoodabadi et al., Opt. Express 28, 25969 (2020), Sec. 2.
%
%% Initialization
%
% For the OPD correction we consider a stratified medium with actual and
% design parameters. Refractive indices and thicknesses of the stratified
% medium must be given for the optical axis pointing in the positive +z
% direction and for an ascending order of layers. We only account for the
% phase differences but not the slightly modified light propagation
% directions and field strengths.

%  initialize OPD abberation object
%    n      -  refractive indices for stratified medium of lens
%    t      -  thicknesses for stratified medium of lens
%    nstar  -  design refractive indices
%    tstar  -  design thicknesses
opd = optics.OPD( n, t, nstar, tstar );

%% Methods
%
% After initialization, the user can account for OPD aberration effects in
% the calls to the _optics.lensimage_,  _optics.lensimage2_, and
% _optics.lensfocus_ objects. The imaging and focus functions can be used
% in the same way as for the classes w/o aberration, however, the
% _optics.OPD_ object must be provided as the first argument in the
% function call.

%  imaging of farfields
%    lens     -  imaging lens w/o aberration
%    far      -  optical far-fields in direction of lens.dir
%    field    -  planewave decomposition
%    x        -  x-coordinates of image, w/o magnification
%    y        -  y-coordinates of image, w/o magnification
%    focus    -  shift focus position wrt origin of BEM simulation
ifar   = efield( opd, lens, far,   x, y, 'focus', focus );  
ifield = efield( opd, lens, field, x, y, 'focus', focus );  

%  focusing of incoming fields
%    lens     -  focusing lens w/o aberration
%    e        -  incoming electric fields, see help page for lensfocus
%    focus    -  shift focus position wrt origin of BEM simulation
field = eval( opd, lens, e );
field = eval( opd, lens, e, 'focus', focus );    %  shift focus point

%% Examples
%
% * <matlab:edit('demoiscat07') demoiscat07.m> |-| Focusing of incoming fields.
%
%%
%
% Copyright 2025 Ulrich Hohenester
