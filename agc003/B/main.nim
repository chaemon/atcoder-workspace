import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc cin(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

var
  N = nextInt()
  A = newSeqWith(N,nextInt())
  ans = 0
  sum = 0

for i in 0..<N:
  if A[i] == 0:
    ans += sum div 2
    sum = 0
  else:
    sum += A[i]

ans += sum div 2

echo ans
