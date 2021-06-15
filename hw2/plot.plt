set title ""
set xlabel "M rounds"
set ylabel "execution time (seconds)"
set terminal png font " Times_New_Roman,12 "
set output "statistic.png"
set key left
set logscale x

plot \
"data.txt" using 1:2 with linespoints linewidth 2 title "CPU", \
"data.txt" using 1:3 with linespoints linewidth 2 title "device 1", \
"data.txt" using 1:4 with linespoints linewidth 2 title "device 2", \
"data.txt" using 1:5 with linespoints linewidth 2 title "device 3", \
"data.txt" using 1:6 with linespoints linewidth 2 title "device 4"
