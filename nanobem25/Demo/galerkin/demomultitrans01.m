%  DEMOTRANS01 - Translate multipole solution.

%  material property and wavenumber of light in vacuum
mat = Material( 1.33 ^ 2, 1 );
k0 = 2 * pi / 500;

%  table of spherical degrees and orders
lmax = 20;
base = multipole.base( lmax );
%  multipole coefficients
tab = base.tab;
n = numel( tab.l );
m = 4;
x = zeros( n, m );  x( 1 : m, 1 : m ) = eye( m );
a = [ x, 0 * x ];
b = [ 0 * x, x ];
%  multipole solution
sol1 = multipole.solution( lmax, mat, k0, a, b );

%  sphere boundary and shift value
diameter = 2000;
p = trisphere( 144, diameter );
shift = 10 * [ 40, -20, 30 ];
%  multipole fields at sphere boundary
[ e1, h1 ] = fields( sol1, p.pos + shift );

%  multipole fields for shifted solution
sol2 = translate( sol1, shift );
[ e2, h2 ] = fields( sol2, p.pos );

% %  final plot
% plot( p, e1 );
% plot( transform( p, 'shift', 1.5 * diameter * [ 1, 0, 0 ] ), e2 );

fun = @real;
plot(real(e1(:)),'o');hold on;plot(real(e2(:)),'+')
