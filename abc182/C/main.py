#!/usr/bin/python3
# -*- coding: utf-8 -*-


n=input()
a=[0]*3
for i in range(len(n)):
  a[int(n[i])%3]+=1
 
if a[0]==0 and (a[1]+2*a[2]<3 or a[1]==0):
  print(-1)
else:
  ans = 1000000000
  for i in range(1, min(3, a[1])):
  print(abs(a[1]-a[2])%3)
