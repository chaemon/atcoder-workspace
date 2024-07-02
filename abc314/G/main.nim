when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/segtree

type P = tuple[n, s:int] # n: お守りの総数, s: 攻撃力Aの和
op(a, b:P) => (a.n + b.n, a.s + b.s)
e() => (0, 0)

solveProc solve(N:int, M:int, H:int, A:seq[int], B:seq[int]):
  let H = H - 1
  Pred B
  var
    As = Seq[M: 0]
    v:seq[int]
  for i in N:
    As[B[i]] += A[i]
    v.add As[B[i]]
  v.sort
  v = v.deduplicate(isSorted = true)
  var
    st = initSegTree[P](v.len, op, e)
    S = 0
  st[0] = (N, 0)
  As = Seq[M: 0]
  var ans0 = Seq[N: int]
  for i in N:
    # 0 .. iを倒すためのお守りの数の最小値を求める
    # s[B[i]]の値を削除
    block:
      let j = v.lowerBound(As[B[i]])
      let (n, s) = st[j]
      st[j] = (n - 1, s - As[B[i]])
    S += A[i]
    As[B[i]] += A[i]
    # s[B[i]]の値を追加
    block:
      let j = v.lowerBound(As[B[i]])
      let (n, s) = st[j]
      st[j] = (n + 1, s + As[B[i]])
    let d = S - H # Sの値をd以上下げたい
    if d <= 0:
      # お守りなしでいける
      ans0[i] = 0
    else:
      # st[j .. ^1]
      proc f(a:P):bool = a.s < d # falseになる最大値を求めたい
      let
        j = st.minLeft(st.len, f) # dを下回る最小値
        # j - 1であれば a.s >= dである
        (n, s) = st[j .. ^1]
      # s + k * v[j - 1] >= dとなる最小のk
      let k = ceilDiv(d - s, v[j - 1])
      ans0[i] = n + k
  var
    ans = Seq[M + 1: int]
    t = 0
  for i in 0 .. M:
    while t < N and ans0[t] <= i: t.inc
    ans[i] = t
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var H = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, H, A, B)
else:
  discard

