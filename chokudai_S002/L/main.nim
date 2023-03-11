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

#{{{ longest increasing subsequence
proc LISFast(a:seq[int]):seq[int] =
  let n = a.len
  var
    A = newSeqWith(n,int.infty)
    id = newSeq[int](n)
  for i in 0..<n:
    id[i] = A.lowerBound(a[i])
    A[id[i]] = a[i]
  var
    m = max(id)
    b = newSeq[int](m+1)
  for i in countdown(n-1,0):
    if id[i] == m: b[m] = a[i]; m -= 1
  return b
#}}}

proc mycmp(a,b:(int,int)): int =
  var t = cmp[int](a[0],b[0])
  if t != 0: t
  else: -cmp[int](a[1],b[1])

proc main():void =
  let N = nextInt()
  var
    p = newSeq[(int,int)]()
    A = newSeq[int](N)
    B = newSeq[int](N)
    v = newSeq[int]()
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    if A[i] > B[i]: swap(A[i],B[i])
    p.add((A[i],B[i]))
  p.sort(mycmp)
  for t in p: v.add(t[1])
  echo LISFast(v).len

main()

