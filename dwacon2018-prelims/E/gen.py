#!/usr/bin/python3
# -*- coding: utf-8 -*-

import random

N = 3000
Q = 14
input_file = open("in_2.txt", "w")
output_file = open("out_2.txt", "w")

id = [i for i in range(0, N)]
di = [[i] for i in range(0, N)]
s = set(id)


def union(u, v):
    a = id[u]
    b = id[v]
    if len(di[a]) < len(di[b]):
        a, b = b, a
        u, v = v, u
    di[a] += di[b]
    for v2 in di[b]:
        id[v2] = a
    di[b] = None
    s.remove(b)


input_file.write("{:d} {:d}\n".format(N, Q))

for i in range(0, N-1):
    a, b = random.sample(s, 2)
    u = random.choice(di[a])
    v = random.choice(di[b])
    input_file.write("{:d} {:d}\n".format(u+1, v+1))
    union(u, v)

output_file.write("{:d}\n".format(random.randint(0, N-1)))
