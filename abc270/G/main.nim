when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/modint

type mint = modint

# Failed to predict input format
solveProc solve(P, A, B, S, G:int):
  mint.setMod(P)
  if G == S:
    echo 0;return
  elif A == 0:
    # SとBしかとらない
    if B == G:
      echo 1;return
    else:
      echo -1;return
  elif A == 1:
    # B足すだけ
    if B == 0:
      # ずっとS
      echo -1;return
    else:
      let u = mint(G - S) / B
      echo u;return
  doAssert A >= 2
  let a = mint(B) / (1 - A)
  # Y - a = A(X - a)
  if mint(S) - a == 0:
    if mint(G) - a != 0:
      echo -1;return
    else:
      doAssert false
  elif mint(G) - a == 0:
    echo -1;return
  let
    s = mint(S) - a
    g = mint(G) - a
  var
    T = g / s
    T0 = T
  let MX = 32000
  var
    tb = initTable[int, int]() # A^i => iを i in 0 ..< MXで
    loop = false
  block:
    p := mint(1)
    for i in MX:
      if p.val notin tb:
        tb[p.val] = i
      else:
        loop = true
      p *= A
  if loop:
    if T.val in tb:
      echo tb[T.val]
    else:
      echo -1
    return
  var
    ans = 0
    q = mint(A)^(-MX)
  for i in 0 .. MX:
    if T.val in tb:
      ans += tb[T.val]
      doAssert T0 == mint(A)^ans
      echo ans;return
    ans += MX
    T *= q
  echo -1
  Naive:
    var
      vis = initSet[int]()
      i = 0
      X = S
    while true:
      if X in vis:
        echo -1;return
      if X == G:
        echo i;return
      vis.incl X
      X = (A * X + B) mod P
      i.inc
    echo -1
    discard
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let P, A, B, S, G = nextInt()
    solve(P, A, B, S, G)
else:
  #let P = 100000007
  for P in [2, 999983]:
    let M = min(P - 1, 5)
    for A in 0 .. M:
      for B in 0 .. M:
        for S in 0 .. M:
          for G in 0 .. M:
            debug P, A, B, S, G
            test(P, A, B, S, G)
            echo "done"
  echo "OK"
  #test(998244353, 3, 4, 12, 19)
  discard

