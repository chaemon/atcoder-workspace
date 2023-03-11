import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

var
  N = nextInt()
  A = newSeqWith(N,nextInt())
  A1 = sorted(A,cmp[int])
  t = initTable[int,int]()
  t1 = initTable[int,int]()

for a in A:
  t[a] = 0
  t1[a] = 0

for i in countup(0,N-1,2):
  t[A[i]] += 1
  t1[A1[i]] += 1

var
  ans = 0

for k,v in t.pairs:
  ans += abs(v - t1[k])

echo ans div 2
