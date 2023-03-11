#!/usr/bin/python3
# -*- coding: utf-8 -*-

import heapq
INF = 10**20

N, M, X, Y = map(int, input().split())
X -= 1
Y -= 1

train = [[] for i in range(N)]
tm = [INF]*(N)
tm[X] = 0

for _ in range(M):
    a, b, t, k = map(int, input().split())
    train[a-1].append((b-1, t, k))
    train[b-1].append((a-1, t, k))

que = []
#for tr in train[X]:
#    bb,tt,kk=tr
#    heapq.heappush(que, (bb, tt))
#    tm[bb]=tt

heapq.heappush(que, (X, 0))

while que:
    now, ti = heapq.heappop(que)
    if now == Y:
        continue

    for tr in train[now]:
        bb, tt, kk = tr
        arri = -(-ti//kk)*kk+tt
        if tm[bb] > arri:
            heapq.heappush(que, (bb, arri))
            tm[bb] = arri

print(tm[Y] if tm[Y] != INF else -1)
