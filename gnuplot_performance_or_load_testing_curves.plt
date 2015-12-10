set size 1,1
set grid

# 输出图片文件
#set output "log_test.png"


#set terminal jpeg size 1920,1080

#set output "log_test.jpeg"




set title 'load testing'

set ylabel  'response time(ms)'

set xlabel  'req/s'

set format  y "%.0f"

plot   'HTTP.txt' with lines title "HTTP request", 'SMPP.txt' with lines title "SMPP"




