#!/usr/bin/python3
# -*- coding: utf-8 -*-

import itertools, copy
H,W,K=map(int,input().split())
li=[["." for _ in range(W+1)]]+[["."]+list(input()) for _ in range(H)]
li2=copy.deepcopy(li)
ans=0
if list(itertools.chain.from_iterable(li)).count("#")==K:
    ans+=1
for i in range(H+1):
    li=copy.deepcopy(li2)
    li[i]=["." for _ in range(W+1)]
    for k in range(1,H+1):
        for j in range(W+1):
            li[k][j]="."
            print(li)
            if list(itertools.chain.from_iterable(li)).count("#")==K:
                ans+=1
print(ans)
