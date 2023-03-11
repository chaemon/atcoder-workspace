#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc infinity[T]():T =
  return (T(1) shl T(sizeof(T)*8-2))-1
#}}}

proc main():void =
  var
    N = nextInt()
    A = newSeqWith(N,nextInt())
    left = newSeqWith(N,[[0,0],[0,0]])
    right = newSeqWith(N,[[0,0],[0,0]])
  block:
    var
      s = 0
      t = 0
      j = 0
    for i in countup(0,N-1):
      t += A[i]
      # make s>=t
      while s < t:
        t -= A[j]
        s += A[j]
        j += 1
      left[i][0] = [s,t]
      left[i][1] = [s-A[j-1],t+A[j-1]]
  block:
    var
      s = 0
      t = 0
      j = N-1
    for i in countdown(N-1,0):
      s += A[i]
      while s > t:
        s -= A[j]
        t += A[j]
        j -= 1
      right[i][0] = [s,t]
      right[i][1] = [s+A[j+1],t-A[j+1]]
  var ans = 10^18
  for i in countup(0,N-2):
    for p in 0..1:
      if left[i][p][0]==0 or left[i][p][1]==0:
        continue
      for q in 0..1:
        if right[i+1][q][0]==0 or right[i+1][q][1]==0:
          continue
        let a = [left[i][p][0],left[i][p][1],right[i+1][q][0],right[i+1][q][1]]
        ans = min(ans,max(a)-min(a))
  echo ans

main()

