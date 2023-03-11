#!/usr/bin/python3
# -*- coding: utf-8 -*-

from subprocess import Popen, PIPE

MAX_CT = 64

def test(n,N):
    if (n<=N and str(n)<=str(N)) or (n>N and str(n)>str(N)):
        return True
    else:
        return False

def process(N):
    print "test: ",N
    ct = 0
    p = Popen("./main", stdin = PIPE, stdout = PIPE)
    
    while True:
        ct += 1
        if ct>MAX_CT:
            print "LIMIT EXCEED!!"
            break
        t = p.stdout.readline()
        print "read: ",t
        c,n = t.split(' ')
        n = int(n)
        if c=='?':
            result = test(n,N)
            if result:
                print 'Y'
                p.stdin.write('Y')
            else:
                print 'N'
                p.stdin.write('N')
        else:
            assert(c=='!')
            if N==n:
                print 'AC'
            else:
                print 'WA'
            return

if __name__ == '__main__':
#    process(1)
#    process(10)
#    process(100)
#    process(192098)
#    process(123000)
    process(1000000000)
    process(999999999)

