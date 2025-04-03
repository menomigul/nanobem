function q = qinc( obj, fun, varargin )
%  QINC - Mie coefficients for incoming excitation.
%
%  Usage for obj = multipole.tmatrix :
%    q = qinc( obj, fun, PropertyPairs )
%  Input
%    fun        :  incoming fields [e,h]=fun(pos,k0) 
%  PropertyName
%    diameter   :  diameter for multipole expansion
%  Output
%    q          :  structure with incoming multipole coefficients

%  initialize object for incoming fields
solver = obj.solver;
qinc = multipole.incoming(  ...
  solver.embedding, obj.k0, fun, 'lmax', obj.lmax, varargin{ : } );
%  evaluate inhomogeneities
q = eval( qinc, varargin{ : } );
