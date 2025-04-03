function obj = init( obj, varargin )
%  INIT - Initialize aberration object.
%
%  Usage for obj = optics.OPD :
%    obj = init( obj, n, t, nstar, tstar )
%  Input
%    n      :  refractive indices for stratified medium of lens
%    t      :  thicknesses for stratified medium of lens
%    nstar  :  design refractive indices
%    tstar  :  design thicknesses

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'n', [] );
addOptional( p, 't', [] );
addOptional( p, 'nstar', [] );
addOptional( p, 'tstar', [] );
%  parse input
parse( p, varargin{ : } );

for name = { 'n', 't', 'nstar', 'tstar' }
  obj.( name{ 1 } ) = p.Results.( name{ 1 } );
end
