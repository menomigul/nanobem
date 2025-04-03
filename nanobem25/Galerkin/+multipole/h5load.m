function [ tsol, tmat ] = h5load( finp )
%  H5LOAD - Load T-matrices from file.
%
%  Usage :
%    [ sol, mat ] = multipole.h5load( finp )
%  Input
%    finp   :  input file
%  Output
%    tsol   :  T-matrix solver
%    tmat   :  T-matrices
%
%  h5file
%    |
%    +-- modes
%         |
%         +-- l
%         +-- m
%         +-- polarization
%    +-- tmatrix
%    +-- angular_vacuum_wavenumber
%    +-- embedding
%         |
%         +-- relative_permittivity
%         +-- relative_permeability

%  load modes 
l = double( h5read( finp, '/modes/l' ) );
m = double( h5read( finp, '/modes/m' ) );
pol = h5read( finp, '/modes/polarization' );
%  index to TE and TM modes, same ordering for TE and TM modes
te = find( pol == "te" | pol == "magnetic" );
tm = find( pol == "tm" | pol == "electric" );
[ ~, ind ] = ismember( [ l( te ), m( te ) ], [ l( tm ), m( tm ) ], 'rows' ); 
te = te( ind );
%  load T-matrix data
data = h5read( finp, '/tmatrix' );
data = data.r + 1i * data.i;

%  frequency, wavelength or wavenumber in FINP ?
info = h5info( finp );
name = { 'frequency', 'angular_frequency', 'vacuum_wavelength', ...
              'vacuum_wavenumber', 'angular_vacuum_wavenumber' };
ind = cellfun( @( x )  ...
  any( strcmp( x, name ) ), { info.Datasets.Name }, 'uniform', 1 );
%  read frequency, wavelength or wavenumber
i1 = find( ind, 1 );
val = h5read( finp, [ '/', info.Datasets( i1 ).Name ] );
unit = info.Datasets( i1 ).Attributes.Value;
%  convert to wavenumber
if iscell( unit ),  unit = unit{ 1 };  end
k0 = multipole.to_wavenumber( val, info.Datasets( i1 ).Name, unit );

%  default embedding material
mat = Material( 1, 1 );
name1 = [ "/relative_permeability", "/relative_permittivity" ];
name2 = [ "mufun", "epsfun" ];
%  loop over material properties
for i = 1 : 2
  try
    %  load material data
    val = h5read( finp, "/embedding" + name1( i ) );
    if isstruct( val ),  val = val.r + 1i * val.i;  end
    %  set material property
    switch numel( val )
      case 1
        mat.( name2( i ) ) = @( k0 ) val;
      otherwise
        fun = spline( k0, val );
        mat.( name2( i ) ) = @( k0 ) ppval( fun, k0 );
    end
  catch
    warning( "using default value for " + name2( i ) );
  end
end

%  initialize T-matrix solver
tsol = multipole.tsolver( mat, 1, max( l ) );
[ ~, i1 ] = ismember( [ l( tm ), m( tm ) ], [ tsol.tab.l, tsol.tab.m ], 'rows' );
[ ~, i2 ] = ismember( [ l( te ), m( te ) ], [ tsol.tab.l, tsol.tab.m ], 'rows' );
n = numel( tsol.tab.l );
%  allocate T-matrices
tmat = multipole.tmatrix( tsol );
[ tmat.aa, tmat.ab, tmat.ba, tmat.bb ] = deal( zeros( n ) );
tmat = repelem( tmat, 1, numel( k0 ) );
%  loop over T-matrices
for i = 1 : numel( tmat )
  tmat( i ).aa( i1, i1 ) = data( tm, tm, i );
  tmat( i ).ab( i1, i2 ) = data( tm, te, i );
  tmat( i ).ba( i2, i1 ) = data( te, tm, i );
  tmat( i ).bb( i2, i2 ) = data( te, te, i );
  tmat( i ).k0 = k0( i );
end
%  convert to different definition between H5 and nanobem toolbox
tmat = convert( tmat, 'from_h5' );
