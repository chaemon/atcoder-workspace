#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
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

proc generate(N,M:int,D:seq[int]):seq[(int,int)] = 
  result = newSeq[(int,int)]()
  var
    D = D
  for i in 0..<D.len:
    if D[i] mod 4 == 0:
      swap(D[0],D[i])
      break
  if D[0] mod 4 != 0:
    for x in countup(0,N - 1,2):
      for y in countup(0,M - 1,2):
        result.add((x,y)) 
  else:
    let
      N1 = N div 2
      N0 = N - N1
      M1 = M div 2
      M0 = M - M1
    var
      D2 = newSeq[int]()
    D2.add(D[0] div 4)
    if D.len == 2 and (D[1] mod 4 == 0): D2.add(D[1] div 4)

    if D.len == 1 or (D[1] mod 4 != 2):
      let
        v1 = generate(N0,M0,D2)
        v2 = generate(N1,M1,D2)
      for p in v1: result.add((p[0]*2,p[1]*2))
      for p in v2: result.add((p[0]*2+1,p[1]*2+1))
    else:
      let
        v1 = generate(N0,M0,D2)
        v2 = generate(N1,M0,D2)
      for p in v1: result.add((p[0]*2,p[1]*2))
      for p in v2: result.add((p[0]*2+1,p[1]*2))

proc solve(N:int, D:seq[int]) =
  proc test(v:seq[(int,int)]) =
    assert v.len == N*N
    for p in v:
      assert 0 <= p[0] and 0 <= p[1] and p[0] < N*2 and p[1] < N*2
    var s:HashSet[(int,int)]
    s.init
    for p in v:
      assert p notin s
      s.incl(p)
    for i in 0..<v.len:
      for j in i+1..<v.len:
        let
          dx = v[i][0] - v[j][0]
          dy = v[i][1] - v[j][1]
          d = dx * dx + dy * dy
        assert d != D[0]
        assert d != D[1]

  var v = generate(N*2,N*2,D)
  v.setLen(N*N)
  for p in v:
    echo p[0]," ",p[1]
#  test(v)
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var D = newSeqWith(2, 0)
  for i in 0..<2:
    D[i] = nextInt()
  solve(N, D);
  return

main()
#}}}
