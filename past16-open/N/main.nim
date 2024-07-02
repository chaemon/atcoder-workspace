when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/structure/randomized_binary_search_tree_with_parent

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

var p:seq[mint] # p[i] = K^i

type D = tuple[a, n:int, s:mint]
proc op(a, b:D):D =
  return (0, a.n + b.n, a.s + p[a.n] * b.s)

proc lowerBound[ST:SomeRBST](self:ST, x:int):int =
  proc lowerBoundImpl(t:ST.Node):int =
    if t == self.leaf: return 0
    if x <= t.key.a:
      return lowerBoundImpl(t.l)
    else:
      return lowerBoundImpl(t.r) + t.l.cnt + 1
    discard
  return lowerBoundImpl(self.root)

# Failed to predict input format
solveProc solve():
  let Q, K = nextInt()
  block:
    P := mint(1)
    for i in Q + 1:
      p.add P
      P *= K
  st := initRandomizedBinarySearchTree[D](op, (0, 0, mint(0)))
  for _ in Q:
    let t = nextString()
    case t[0]
    of '+':
      let
        x = nextInt()
        k = st.lowerBound(x)
      st.insert_index(st.root, k, (x, 1, mint(x)))
    of '-':
      let
        x = nextInt()
        k = st.lowerBound(x)
      st.erase_index(st.root, k)
    else:
      doAssert false
    echo st.root.sum.s
  doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

