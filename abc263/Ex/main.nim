const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/geometry/geometry_template
import lib/structure/universal_segtree
import complex, random
import lib/other/binary_search_float

randomize()

const EPS = 1e-9

proc OLE() =
  while true:
    echo "Hello World"

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int]):
  let Origin = initPoint[float](0, 0)
  var K = K
  var L:seq[Line[float]]
  for i in N:
    L.add initLine[float](A[i].float, B[i].float, (-C[i]).float)
  proc count(r:float):int =
    var
      c = initCircle[float](Origin, r)
      ranges = Seq[(float, float)]
      v = Seq[float]
    for i in N:
      if intersect(c, L[i]):
        var p, q: Point[float]
        try:
          (p, q) = crosspoint(c, L[i])
        except:
          OLE()
        var
          a1 = p.phase
          a2 = q.phase
        if a1 > a2:
          swap a1, a2
        ranges.add((a1, a2))
        v.add a1;v.add a2
    ranges.sort
    v.sort
    if v.len == 0: return 0
    result = 0
    var st = initDualSegTree[uint16](v.len + 1, proc(a, b:uint16):uint16 = a + b, ()=>uint16(0))
    for (l, r) in ranges:
      var
        li = v.lower_bound(l)
        ri = v.lower_bound(r) + 1
      doAssert li in 0 ..< v.len and v[li] =~ l
      doAssert ri - 1 in 0 ..< v.len and v[ri - 1] =~ r
      result += int(st[li] - st[ri])
      st.apply(li ..< ri, 1.uint16)
  proc f(r:float):bool = count(r) >= K
  echo f.minLeft(0.0 .. 1e+7)

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, K, A, B, C)
else:
  discard

