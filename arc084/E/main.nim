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

proc nextBaseK(a:var openArray[int], K:int = 10): bool {.discardable.} = 
  for i in 0..<a.len:
    if a[i] < K - 1:
      a[i] += 1
      return true
    else:
      a[i] = 0
  return false

proc `<`(x,y:seq[int]):bool =
  var M = max(x.len,y.len)
  for i in 0..<M:
    if i >= x.len:
      return true
    elif i >= y.len:
      return false
    elif x[i] < y[i]:
      return true
    elif x[i] > y[i]:
      return false
  return false

proc naive(K,N:int):void =
  var v = newSeq[seq[int]]()
  for l in 1..N:
    var a = newSeq[int](l)
    while true:
      v.add(a.reversed)
      if not a.nextBaseK(K): break
  v.sort()
  echo v[((v.len+1) div 2) - 1]

proc main():void =
  var
    K = nextInt()
    N = nextInt()
  if K == 1:
    let t = N div 2
    for _ in 0..<t:
      stdout.write 1, " "
    return
  elif K mod 2 == 0:
    stdout.write K div 2, " "
    for _ in 1..N-1:
      stdout.write K, " "
    return
  elif N == 1:
    echo K div 2
    return
  echo "naive: "
  naive(K,N)
  var
    a = newSeq[int](N)
  a[N-1] = K - 2
  a[0] += 1
  block:
    var
      carry = 0
      t = K - 1
    for i in countdown(N-1,0):
      carry *= K
      var s = a[i] + carry
      a[i] = s div t
      carry = s mod t
    assert carry == 0
  block:
    var
      carry = 0
      t = 2
    for i in countdown(N-1,0):
      carry *= K
      var s = a[i] + carry
      a[i] = s div t
      carry = s mod t
  echo "ans: "
  echo a
  discard

main()

