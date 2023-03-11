#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc main():void =
  var
    N = nextInt()
    c = newSeq[string](N*2)
    a = newSeq[int](N*2)
    wb = newSeqWith(N,newSeq[int](N+1))
    bw = newSeqWith(N,newSeq[int](N+1))
    dp = newSeqWith(N+1,newSeqWith(N+1,int.infty))
    b = newSeq[int](N)
    w = newSeq[int](N)
    bvec = newSeq[int]()
    wvec = newSeq[int]()
    bsum = 0
    wsum = 0
  for i in 0..<2*N:
    c[i] = nextString()
    a[i] = nextInt()
    a[i] -= 1
  for i in 0..<2*N:
    if c[i][0] == 'W':
      wvec.add(a[i])
      var s = 0
      wb[a[i]][N] = s
      for j in countdown(N-1,0):
        s += b[j]
        wb[a[i]][j] = s
      w[a[i]] = 1
    else:
      bvec.add(a[i])
      var s = 0
      bw[a[i]][N] = s
      for j in countdown(N-1,0):
        s += w[j]
        bw[a[i]][j] = s
      b[a[i]] = 1
  for i in 0..N-1:
    for j in i+1..N-1:
      if bvec[i] > bvec[j]:
        bsum += 1
      if wvec[i] > wvec[j]:
        wsum += 1
  dp[0][0] = 0
  for i in 0..N:
    for j in 0..N:
      block white:
        if i < N:
          dp[i+1][j].min= dp[i][j] + wb[i][j]
      block black:
        if j < N:
          dp[i][j+1].min= dp[i][j] + bw[j][i]
      discard
  echo dp[N][N] + bsum + wsum
  discard

#{{{ main function
main()
#}}}
