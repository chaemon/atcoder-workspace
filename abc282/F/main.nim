when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve():
  let N = nextInt()
  var B = fastLog2(N)
  var x = Seq[tuple[l, r: int]] # 0-based, 半開区間
  for l in N:
    for d in 0 .. B:
      let r = min(l + 2^d, N)
      x.add((l, r))
  # サイズはN * (B + 1)
  echo x.len
  for (l, r) in x:
    echo l + 1, " ", r
  proc query(L, R: int) =
    let d = fastLog2(R - L)
    # L ..< L + 2^dと R - 2^d ..< R
    let
      a = L * (B + 1) + d
      b = (R - 2^d) * (B + 1) + d
    echo a + 1, " ", b + 1
    doAssert x[a].l == L and x[b].r == R
    doAssert L <= x[b].l and x[a].r <= R
    doAssert x[b].l <= x[a].r
  let Q = nextInt()
  for _ in Q:
    var L, R = nextInt()
    L.dec
    query(L, R)
  #for L in 0 ..< N:
  #  for R in L + 1 .. N:
  #    query(L, R)
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

