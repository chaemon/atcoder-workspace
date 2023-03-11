include atcoder/extra/header/chaemon_header

proc test(K:int, n:int):seq[int] =
  for X in 0..n:
    var
      m = X div K
      s = initHashSet[int]()
    for t in 1..m:
      var
        X2 = X - t
      if X2 < 0: break
      s.incl(result[X2])
    var g = 0
    while g in s:
      g += 1
    result.add(g)
#    echo X, " ", g

type P = object
  found:bool
  v:int

proc `ceilDiv`*[T](x, y: T): T =
  result = floorDiv(x, y)
  if x mod y != 0: result.inc

proc calc(A, K:int):int =
  if A == 0: return 0
  elif K == 1: return A
  proc rec(l, r, s, q:int):P =
    debug l, r, s, q
    var (q, r) = (q, r)
    assert r >= 0
    if r > l:
      var d = r div l
#      echo "repeat"
      debug d
      if q < d * l:
        return P(found:false, v:q mod l)
      r -= d * l
      q -= d * l
      assert r >= 0
      return rec(l, r, s, q)
#      echo "result: ", result
    else:
      # r, r + K, ...,  r + K * (t - 1)
      # r + (K - 1) * t >= l
      let t = ceilDiv(l - r, K - 1)
      assert r + (K - 1) * t >= l
#      echo "insert"
#      echo "t = ", t
      if q >= l + t:
        var r2 = r + K * t - (l + t) # Dummy
        assert r2 >= 0
        let p = rec(l + t, r2, s + t, q - (l + t))
        if p.found: return p
        else: q = p.v
      assert q < l + t
      # r + K * x
      let d = floorDiv(q - r, K)
      if (q - r) mod K == 0:
#        echo "found: ", s, " ", d
        return P(found:true, v:s + d)
      else:
#        echo "not found: ", q, " ", d
        return P(found:false, v:q - d - 1)
    discard
  let t = rec(1, K - 1, 1, A - 1)
  if not t.found: return 0
  return t.v


proc main():void =
  let N = nextInt()
  var a = 0
  for i in 0..<N:
    let A, K = nextInt()
    a = a xor calc(A, K)
  if a != 0:
    echo "Takahashi"
  else:
    echo "Aoki"

main()
