#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams, future
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#import macros
#from sequtils import newSeqWith
#
#proc newNdSeqImpl[T](lens: seq[int]; init: T; lensLen: static[int]): auto =
#  when lensLen == 1:
#    newSeqWith(lens[0], init)
#  else:
#    newSeqWith(lens[0], newNdSeqImpl(lens[1..(lensLen - 1)], init, lensLen - 1))
#
#template newNdSeq*[T](lens: seq[int]; init: T): auto =
#  newNdSeqImpl(lens, init, lens.len)

#echo newNdSeq(@[2, 3, 4], -1.0)

#{{{ main function
proc main() =
  let
    N = nextInt()
    pq = nextString().split('/').map(x => parseInt(x))
    P = float(pq[0])/float(pq[1])
  var
    v = newSeq[(int,int)]() # -point, index (= yosen-rank)
    yrank = newSeq[int](N)
    A = newSeqWith(N,newSeqWith(N,0))
  for i in 0..<N:
    for j in 0..<N:
      A[i][j] = nextInt()
  for i in 0..<N:
    var p = 0
    for j in 0..<N:
      p += A[i][j]
    v.add((-p,i))
  v.sort(cmp[(int,int)])
  for i in 0..<N:
    yrank[i] = v[i][1]
  var
    dp = newSeqWith(N+1,0.0)
    dp_tmp = newSeq[float]()
  dp[0] = 1.0
  for t in countdown(N-1,0):
    let i = yrank[t]
    dp_tmp = newSeqWith(N+1,0.0)
    var
      p = newSeqWith(N+1,0.0)
      p_tmp = newSeqWith(N+1,0.0)
    p[0] = 1.0
    for j in 0..<N:
      p_tmp = newSeqWith(N+1,0.0)
      if i == j: continue
      var wp = 0.0
      if A[i][j] == 1: wp = P
      else: wp = 1.0 - P
      for s in 0..<N:
        p_tmp[s+1] += p[s] * wp
        p_tmp[s] += p[s] * (1.0 - wp)
      swap(p,p_tmp)
    var psum = 0.0
    for s in 0..<N:
      var opt = false
      if t == N-1 or yrank[t] < yrank[t+1]: opt = true
      if opt: psum += dp[s]
      dp_tmp[s] = psum * p[s]
      if not opt: psum += dp[s]
    swap(dp,dp_tmp)
  var ans = 0.0
  for s in 0..N:
    ans += dp[s]
  echo ans
  return

main()
#}}}
