set size 1,1
set grid

# 输出图片文件
#set output "log_test.png"


#set terminal jpeg size 1920,1080

#set output "log_test.jpeg"

#告诉gnuplot x坐标轴是时间格式 
#set xdata time

# 设置数据里的时间格式 %s seconds since the Unix epoch (1970-01-01 00:00 UTC)
#set timefmt "%s"  

# 设置 时间的显示格式
#set format x "%y/%m/%d"  
#set format x "%H%M%S"


#%x 轴范围为-10 到 10，
# set xrange [0:50]
# set yrange [0:50]

# %x 轴的主刻度的宽度为 10
# set xtics 10
# %x 轴上每个主刻度中画 2 个分刻度
# set mxtics 2




set title 'load testing'

set ylabel  'response time(ms)'

set xlabel  'time'

set format  y "%.0f"

#plot   'HTTP.txt' with lines title "HTTP request", 'SMPP.txt' with lines title "SMPP"
# 好像一定要用using 1:2 指定使用文件里面第一个第二列数据才行
#plot  'avg_time.txt' using 1:2 title "avg time" with lines, 'max_time.txt' using 1:2 title "max time" with lines

plot 'connections-1 sessions-1 updates-100.txt' with linespoints title 'connections=1 sessions=1 updates=100' ,  \
     'connections-1 sessions-400 updates-100.txt' with linespoints  title 'connections=1 sessions=400 updates=100', \
     'connections-1 sessions-1600 updates-100.txt' with linespoints  title 'connections=1 sessions=1600 updates=100', \
     'connections-1 sessions-3200 updates-100.txt' with linespoints  title 'connections=1 sessions=3200 updates=100', \
     'connections-4 sessions-1 updates-100.txt' with linespoints title 'connections=4 sessions=1 updates=100', \
     'connections-4 sessions-400 updates-100.txt' with linespoints  title 'connections=4 sessions=400 updates=100', \
     'connections-4 sessions-1600 updates-100.txt' with linespoints  title 'connections=4 sessions=1600 updates=100', \
     'connections-4 sessions-3200 updates-100.txt.txt' with linespoints  title 'connections=4 sessions=3200 updates=100', \
     'connections-32 sessions-1 updates-100.txt' with linespoints title 'connections=32 sessions=1 updates=100', \
     'connections-32 sessions-400 updates-100.txt' with linespoints  title 'connections=32 sessions=400 updates=100', \
     'connections-32 sessions-1600 updates-100.txt' with linespoints  title 'connections=32 sessions=1600 updates=100', \
     'connections-32 sessions-3200 updates-100.txt' with linespoints  title 'connections=32 sessions=3200 updates=100'

