# V2ray_bbr  --加入bbr测试失败 --有时间再修改  
0.0.0.0 12948 0.0.0.0 12948
0.0.0.0 45678/udp 0.0.0.0 45678/udp
0.0.0.0 6666 0.0.0.0 8388 #bbr --ss
0.0.0.0 8888 0.0.0.0 10086 #bbr --v2ray
UID 60ca58e9-003e-4c01-98de-c2223ae49153

#不加入bbr 以存放在 docker pull linux52/v2ray-test
