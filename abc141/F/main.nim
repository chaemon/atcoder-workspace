#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams,future
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

#{{{ bitutils
proc bits(v:varargs[int]): int =
  result = 0
  for x in v: result = (result or (1 shl x))

proc `[]`(b:int,n:int):int =
  if (b and (1 shl n)) == 0: 0 else: 1

proc test(b:int,n:int):bool =
  if b[n] == 1:true else: false

proc set(b:var int,n:int) = b = (b or (1 shl n))
proc unset(b:var int,n:int) = b = (b and (not (1 shl n)))

proc `[]=`(b:var int,n:int,t:int):int =
  if t == 0: b.unset(n)
  else: b.set(n)

var b = 0
b[2]=1

proc write_bits(b:int,n:int = 64) =
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
#}}}

proc gauss(v:seq[int],n:int):seq[int] =
  var
    v = v
    p = 0
  for i in countdown(n-1,0):
    var found = false
    for j in p..<v.len:
      if v[j].test(i):
        swap(v[p],v[j])
        found = true
        break
    if not found: continue
    for j in 0..<v.len:
      if j == p: continue
      if v[j].test(i): v[j] = (v[j] xor v[p])
    p += 1
  v.setlen(p)
  return v

let B = 60

proc solve(N:int, A:var seq[int]) =
  var ans = 0
  for i in 0..<B:
    var ct = 0
    for j in 0..<N:
      if A[j].test(i): ct += 1
    if ct mod 2 == 1:
      ans += bits(i).int
      for j in 0..<N:
        A[j].unset(i)
  A = gauss(A,B)
  var s = 0
  for a in A: s = (s xor a)
  ans += s.int * 2

  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  solve(N, A);
  return

main()
#}}}
