ps = 0; eps = 0; fmap = 1; pert = 0;

#N = 1; N_x = 33; N_y = 16;
N = 3; N_x = 11; N_y = 5;
#N = 15; N_x =  2; N_y = 1;
#nu_x = 33.134; nu_y = 16.180;
# MAX-IV
#N = 20; N_x = 2; N_y = 0;
# DIAMOND
#N = 6; N_x = 4; N_y = 2;
#nu_x = 27.225; nu_y = 12.422;


font_size = 24; line_width = 2;
#font_size = 30; line_width = 2;
if (!ps) set terminal x11;
if (ps && !eps) \
  set terminal postscript enhanced color solid
#  lw line_width "Times-Roman" font_size;
if (ps && eps) \
  set terminal postscript eps enhanced color solid 
#  lw line_width "Times-Roman" font_size;

# left adjusted labels
set key Left;

set grid;

set style line 1 lt 1 lw line_width lc rgb "blue";
set style line 2 lt 1 lw line_width lc rgb "dark-green";
set style line 3 lt 1 lw line_width lc rgb "red";
set style line 4 lt 1 lw line_width lc rgb "dark-orange";

set clabel "%5.2f"; set key left;

set palette rgbformulae 22, 13, -31 negative;

if (ps) set output "dnu.ps"

set multiplot;

set size 0.5, 0.5; set origin 0.0, 0.5;
set title "{/Symbol n}_x vs. A_{x,y}";
set xlabel "A_{x,y} [mm]"; set ylabel "{/Symbol n}_x"; \
if (!pert) \
  plot "dnu_dAx.out" using 1:(N*(N_x+$5)) title "A_x" \
        with linespoints ls 1, \
       "dnu_dAy.out" using 2:(N*(N_x+$5)) title "A_y" with linespoints ls 3;
if (pert) \
  plot "dnu_dAx.out" using 1:(N*(N_x+$5)) title "A_x" \
       with linespoints ls 1, \
       "dnu_dAy.out" using 2:(N*(N_x+$5)) title "A_y" \
       with linespoints ls 3, \
       "dnu_dAx_pert.out" using 1:(N*(N_x+$3)) title "A_x (pert)" \
       with linespoints ls 2, \
       "dnu_dAy_pert.out" using 2:(N*(N_x+$3)) title "A_y (pert)" \
       with linespoints ls 4;

set origin 0.0, 0.0;
set title "{/Symbol n}_y vs. A_{x,y}";
set xlabel "A_{x,y} [mm]"; set ylabel "{/Symbol n}_y"; \
if (!pert) \
  plot "dnu_dAx.out" using 1:(N*(N_y+$6)) title "A_x" \
        with linespoints ls 1, \
       "dnu_dAy.out" using 2:(N*(N_y+$6)) title "A_y" \
       with linespoints ls 3;
if (pert) \
  plot "dnu_dAx.out" using 1:(N*(N_y+$6)) title "A_x" \
       with linespoints ls 1, \
       "dnu_dAy.out" using 2:(N*(N_y+$6)) title "A_y" \
       with linespoints ls 3, \
       "dnu_dAx_pert.out" using 1:(N*(N_y+$4)) title "A_x (pert)" \
       with linespoints ls 2, \
       "dnu_dAy_pert.out" using 2:(N*(N_y+$4)) title "A_y (pert)" \
       with linespoints ls 4;

set origin 0.5, 0.5;
set title "Chromaticity";
set xlabel "{/Symbol d} [%]"; set ylabel "{/Symbol n}_x";
set y2label "{/Symbol n}_y";
set ytics nomirror; set y2tics;
if (!pert) \
  plot "chrom2.out" using 1:(N*$2) title "{/Symbol n}_x" with lines ls 1, \
       "chrom2.out" using 1:(N*$3) axis x1y2 title "{/Symbol n}_y" \
       with lines ls 3;
if (pert) \
  plot "chrom2.out" using 1:(N*$2) title "{/Symbol n}_x" with lines ls 1, \
       "chrom2.out" using 1:(N*$3) axis x1y2 title "{/Symbol n}_y" \
       with lines ls 3, \
       "chrom2_pert.out" using 1:(N*(N_x+$2)) axis x1y1 \
       title "{/Symbol n}_x (pert)" with lines ls 2, \
       "chrom2_pert.out" using 1:(N*(N_y+$3)) axis x1y2 \
       title "{/Symbol n}_y (pert)" with lines ls 4;

if (!fmap) \
  unset multiplot; \
  if (!ps) pause(-1);

if (!fmap) exit;

set origin 0.5, 0.0;

set style line 1 lw line_width lc rgb "red";
set style line 2 lw line_width lc rgb "dark-orange";
set style line 3 lw line_width lc rgb "blue";
set style line 4 lw line_width lc rgb "dark-green";
set style line 5 lw line_width lc rgb "purple";
set style line 6 lw line_width lc rgb "cyan";

set clabel "%4.1f"; set key left;
#unset clabel;
set noztics; unset colorbox;
set cbrange [0:1];

# x <-> horizontal, y <-> vertical, z <-> perpendicular to screen
set view 0, 0, 1, 1;

#set title "Norm of the Resonance Terms";
#set title "Norm of the Tune Shift Terms";
set title "Tune Footprint";
set xlabel "{/Symbol n}_x"; set ylabel "{/Symbol n}_y";

set parametric;

x_min = 32.99; x_max = 33.51; y_min = 14.99; y_max = 16.51;
# DIAMOND
#x_min = 26.99; x_max = 27.51; y_min = 11.99; y_max = 12.51;

# Compute n for the different resonances:
#
#   n_x*nu_x + n_y*nu_y = n
#
#  nu_y = +/-(n-n_x*nu_y)/n_y
#
# The adjustment is the difference between x_min/x_max and y_min/y_max
# vs. the actual (nu_x,y) values

i10    = floor(x_min) + 1.0;
i01_1  = floor(y_min) + 1.0;
i01_2  = floor(y_min) + 2.0;

i20    = floor(x_min) + 1.5;
i02_1  = floor(y_min) + 0.5;
i02_2  = floor(y_min) + 1.5;
i02_3  = floor(y_min) + 2.5;

i11    = floor(x_min+y_max);
i1m1_1 = floor(x_min-y_min);
i1m1_2 = floor(x_min-y_min) - 1.0;

i30    = floor(x_min) + 4.0/3.0;
i12_1  = floor(x_min+2*y_max) - 2.0;
i12_2  = floor(x_min+2*y_max) - 1.0;
i12_3  = floor(x_min+2*y_max);
i1m2_1 = floor(x_min-2*y_min);
i1m2_2 = floor(x_min-2*y_min) - 1.0;
i1m2_3 = floor(x_min-2*y_min) - 2.0;
i1m2_4 = floor(x_min-2*y_min) + 1.0;

i40    = floor(x_min) + 1.25;
i04_1  = floor(y_min) + 1.25;
i04_2  = floor(y_min) + 1.75;
i04_3  = floor(y_min) + 2.25;
i22_1  = floor(2.0*x_min+2.0*y_max) - 2.0;
i22_2  = floor(2.0*x_min+2.0*y_max);
i2m2_1 = floor(2.0*x_min-2.0*y_min) - 1.0;
i2m2_2 = floor(2.0*x_min-2.0*y_min);
i2m2_3 = floor(2.0*x_min-2.0*y_min) + 1.0;

i14_1  = floor(x_min+4.0*y_max) - 5.0;
i14_2  = floor(x_min+4.0*y_max) - 4.0;
i14_3  = floor(x_min+4.0*y_max) - 3.0;
i14_4  = floor(x_min+4.0*y_max) - 2.0;
i14_5  = floor(x_min+4.0*y_max) - 1.0;
i14_6  = floor(x_min+4.0*y_max);
i32_1  = floor(3.0*x_min+2.0*y_max);
i32_2  = floor(3.0*x_min+2.0*y_max) + 1.0;
i32_3  = floor(3.0*x_min+2.0*y_max) + 2.0;
i1m4_1 = floor(x_min-4.0*y_min);
i1m4_2 = floor(x_min-4.0*y_min) - 1.0;
i1m4_3 = floor(x_min-4.0*y_min) - 2.0;
i1m4_4 = floor(x_min-4.0*y_min) - 3.0;
i1m4_5 = floor(x_min-4.0*y_min) - 4.0;
i1m4_6 = floor(x_min-4.0*y_min) - 5.0;
i3m2_1 = floor(3.0*x_min-2.0*y_min);
i3m2_2 = floor(3.0*x_min-2.0*y_min) + 1.0;
i3m2_3 = floor(3.0*x_min-2.0*y_min) + 2.0;

i2m1   = floor(2.0*x_min-y_min);

#i60    = floor(x_min);
i06    = floor(y_min) + 14.0/6.0;
#i51    = floor(5.0*x_min+1.0*y_max);
#i5m1   = floor(5.0*x_min-1.0*y_min);
i15    = floor(1.0*x_min+5.0*y_max);
i1m5_1 = floor(1.0*x_min-5.0*y_min) - 6;
i1m5_2 = floor(1.0*x_min-5.0*y_min) - 7;
#i24    = floor(2.0*x_min+4.0*y_max);
i2m4   = floor(2.0*x_min-4.0*y_min) - 5;
i42    = floor(4.0*x_min+2.0*y_max) + 2;
i4m2   = floor(4.0*x_min-2.0*y_min) - 1;
i33    = floor(3.0*x_min+3.0*y_max) + 1;
#i3m3   = floor(3.0*x_min-3.0*y_min) - 3;

#i6m4   = floor(6.0*x_min-4.0*y_min) - 2;

#x_min = 32.99; x_max = 33.26; y_min = 16.0; y_max = 16.26;
x_min = 32.99; x_max = 33.26; y_min = 16.0; y_max = 16.31;
# DIAMOND
#x_min = 27.1; x_max = 27.35; y_min = 12.24; y_max = 12.51;
#x_min = 26.99; x_max = 27.51; y_min = 11.99; y_max = 12.51;

set xrange [x_min:x_max]; set yrange [y_min:y_max]; set zrange [0:1];
set urange [x_min:x_max]; set vrange [y_min:y_max];

splot "fmapdp_est.dat" using (N*($3+N_x)):(N*($4+N_y)):5 notitle \
      with points pt 2 lc rgb "blue" ps 0.5,\
      "fmap_est.dat" using (N*($3+N_x)):(N*($4+N_y)):5 notitle \
      with points pt 1 lc rgb "red" ps 0.5, \
      i10,   v,                  1.0 notitle with lines ls 1, \
      u,     i01_1,              1.0 notitle with lines ls 1, \
      u,     i01_2,              1.0 notitle with lines ls 1, \
                                                              \
      i20,   v,                  1.0 notitle with lines ls 1, \
      u,     i02_1,              1.0 notitle with lines ls 1, \
      u,     i02_2,              1.0 notitle with lines ls 1, \
      u,     i02_3,              1.0 notitle with lines ls 1, \
      u,     i11-u,              1.0 notitle with lines ls 2, \
      u,     u-i1m1_1,           1.0 notitle with lines ls 2, \
      u,     u-i1m1_2,           1.0 notitle with lines ls 2, \
                                                              \
      i30,   v,                  1.0 notitle with lines ls 1, \
      u,     (i12_1-u)/2.0,      1.0 notitle with lines ls 1, \
      u,     (i12_2-u)/2.0,      1.0 notitle with lines ls 1, \
      u,     (i12_3-u)/2.0,      1.0 notitle with lines ls 1, \
      u,     (u-i1m2_1)/2.0,     1.0 notitle with lines ls 1, \
      u,     (u-i1m2_2)/2.0,     1.0 notitle with lines ls 1, \
      u,     (u-i1m2_3)/2.0,     1.0 notitle with lines ls 1, \
      u,     (u-i1m2_4)/2.0,     1.0 notitle with lines ls 1, \
                                                              \
      i40, v,                    1.0 notitle with lines ls 3, \
      u,     i04_1,              1.0 notitle with lines ls 1, \
      u,     i04_2,              1.0 notitle with lines ls 1, \
      u,     i04_3,              1.0 notitle with lines ls 1, \
      u,     (i22_1-2.0*u)/2.0,  1.0 notitle with lines ls 3, \
      u,     (i22_2-2.0*u)/2.0,  1.0 notitle with lines ls 3, \
      u,     (2.0*u-i2m2_1)/2.0, 1.0 notitle with lines ls 3, \
      u,     (2.0*u-i2m2_2)/2.0, 1.0 notitle with lines ls 3, \
      u,     (2.0*u-i2m2_3)/2.0, 1.0 notitle with lines ls 3, \
                                                              \
      u,     (i32_1-3.0*u)/2.0,  1.0 notitle with lines ls 4, \
      u,     (i32_2-3.0*u)/2.0,  1.0 notitle with lines ls 4, \
      u,     (i32_3-3.0*u)/2.0,  1.0 notitle with lines ls 4, \
      u,     (i14_1-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (i14_2-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (i14_3-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (i14_4-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (i14_5-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (i14_6-u)/4.0,      1.0 notitle with lines ls 4, \
      u,     (3.0*u-i3m2_1)/2.0, 1.0 notitle with lines ls 4, \
      u,     (3.0*u-i3m2_2)/2.0, 1.0 notitle with lines ls 4, \
      u,     (3.0*u-i3m2_3)/2.0, 1.0 notitle with lines ls 4, \
      u,     (u-i1m4_1)/4.0,     1.0 notitle with lines ls 4, \
      u,     (u-i1m4_2)/4.0,     1.0 notitle with lines ls 4, \
      u,     (u-i1m4_3)/4.0,     1.0 notitle with lines ls 4, \
      u,     (u-i1m4_4)/4.0,     1.0 notitle with lines ls 4, \
      u,     (u-i1m4_5)/4.0,     1.0 notitle with lines ls 4, \
      u,     (u-i1m4_6)/4.0,     1.0 notitle with lines ls 4, \
                                                              \
      u,     2.0*u-i2m1,         1.0 notitle with lines ls 6; \

#                                                              \
#      u,     (4.0*u-i4m2)/2.0,   1.0 notitle with lines ls 5;
#      u,     i06,                1.0 notitle with lines ls 5, \
#      u,     (i15-u)/5.0,        1.0 notitle with lines ls 5, \
#      u,     (u-i1m5_1)/5.0,     1.0 notitle with lines ls 5, \
#      u,     (u-i1m5_2)/5.0,     1.0 notitle with lines ls 5, \
#      u,     (2.0*u-i2m4)/4.0,   1.0 notitle with lines ls 5, \
#      u,     (i42-4.0*u)/2.0,    1.0 notitle with lines ls 5, \
#      u,     (4.0*u-i4m2)/2.0,   1.0 notitle with lines ls 5, \
#      u,     (i33-3.0*u)/3.0,    1.0 notitle with lines ls 5;

#      u,     (6.0*u-i6m4)/4.0,   1.0 notitle with lines ls 5;

unset multiplot;
if (!ps) pause(-1);
