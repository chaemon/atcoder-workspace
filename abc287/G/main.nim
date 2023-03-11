when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

type S = tuple[s, n: int] # スコアの合計, カードの累積枚数
proc op(a, b:S):S = (a.s + b.s, a.n + b.n)
proc e():S = (0, 0)

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var
    a = Seq[N: int]
    b = Seq[N: int]
    scores = Seq[int]
  for i in N:
    a[i] = nextInt()
    b[i] = nextInt()
    scores.add a[i]
  var q = Seq[seq[int]]
  let Q = nextInt()
  for i in Q:
    let t = nextInt()
    if t == 1:
      var x, y = nextInt()
      x.dec
      q.add @[t, x, y]
      scores.add y
    elif t == 2:
      var x, y = nextInt()
      x.dec
      q.add @[t, x, y]
    elif t == 3:
      let x = nextInt()
      q.add @[t, x]
    else: doAssert false
  scores.sort
  scores = scores.deduplicate(isSorted = true)
  let SL = scores.len
  var st = initSegTree[S](SL, op, e)
  for i in N:
    # 得点a[i], 枚数b[i]
    var ai = scores.lower_bound(a[i])
    doAssert scores[ai] == a[i]
    let (s, n) = st[ai]
    st[ai] = (s + b[i] * a[i], n + b[i])
  for i in Q:
    let q = q[i]
    let t = q[0]
    if t == 1:
      let
        x = q[1]
        y = q[2]
      # 今の得点a[x]を引く
      block:
        let ai = scores.lower_bound(a[x])
        doAssert scores[ai] == a[x]
        let (s, n) = st[ai]
        st[ai] = (s - a[x] * b[x], n - b[x])
      a[x] = y
      # 新しい得点yにする
      block:
        let ai = scores.lower_bound(y)
        let (s, n) = st[ai]
        st[ai] = (s + a[x] * b[x], n + b[x])
    elif t == 2:
      let
        x = q[1]
        y = q[2]
        d = y - b[x]
      let ai = scores.lower_bound(a[x])
      let (s, n) = st[ai]
      st[ai] = (s + a[x] * d, n + d)
      b[x] = y
    else:
      let x = q[1]
      proc f(s:S):bool = s.n <= x
      # l ..< q.lenのopの値がtrueになる
      let
        l = st.minLeft(SL, f)
        e = st[l ..< SL]
      if l == 0:
        if e.n < x: echo -1
        else: echo e.s
      else:
        let d = x - e.n
        # l - 1からd個取る
        echo e.s + d * scores[l - 1]
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

