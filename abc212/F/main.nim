const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

const MX = 32

proc OLEAssert(b:bool) =
  if not b:
    while true:
      stdout.write "OLEOLEOLEOLEOLEOLEOLEOLEOLE"
proc TLEAssert(b:bool) =
  if not b:
    var a = 0
    while true:
      a.inc

solveProc solve(N, M, Q:int, A, B, S, T, X, Y, Z:seq[int]):
  Pred A, B, Y
  var
    next = M @ int # バスbの次のバス。-1だったら次はない
    city = Seq[N: seq[tuple[t, b:int]]] # 発車時刻, バス
  block:
    for b in M:
      city[A[b]].add (S[b], b)
    for c in N:
      city[c].sort
    for b in M:
      # バスbの次を探す
      # つまり都市B[b]から時刻T[b] + 1以降に出発のバスを探す
      var u = city[B[b]].lowerBound((T[b], 0))
      if u == city[B[b]].len:
        next[b] = -1
      else:
        next[b] = city[B[b]][u].b
  # 各バスbについて
  # 前のバスをb'とする
  # T[b'] + 1〜T[b]までをバスbにいると解釈

  # dp[b][ti]: バスbから初めて時刻S[b] + 2^tiのときにどのバスに乗っているか?
  var dp = [M, MX] @ Option[int]
  proc query(b, t, ti:int):int
  proc calc(b, ti:int):int =
    r =& dp[b][ti]
    if r.isSome: return r.get
    if ti == 0:
      # バスbから時刻1だけ動く
      # S[b] + 1 <= T[i]なのでbのままのはずだ
      r = b.some
    else:
      let t = 1 shl ti
      if next[b] == -1 or S[b] + t <= T[b]:
        r = b.some
      else:
        r = query(b, t, ti).some
    return r.get
  proc query(b, t, ti:int):int =
    #doAssert t <= (1 shl ti)
    if t <= 0 or ti == 0 or next[b] == -1: return b
    let t0 = 1 shl (ti - 1)
    if t <= t0:
      return query(b, t, ti - 1)
    else:
      # 2^(ti - 1)動かす
      let
        b2 = calc(b, ti - 1)
        t2 = S[b] + t - S[b2]
        # b2から時刻t2後を計算する問題になる
        #bにすればよい
      let nb = next[b2]
      if nb == -1: return b2
      let nt = S[b2] + t2 - S[nb]
      TLEAssert t >= t2
      OLEAssert t2 >= nt
      if nb == -1: return b2
      elif nt <= T[nb] - S[nb]: return nb
      else:
        doAssert nt <= (1 shl (ti - 1))
        return query(nb, nt, ti - 1)
  for q in Q:
    let i = city[Y[q]].lowerBound((X[q], 0))
    if i == city[Y[q]].len:
      echo Y[q] + 1
    else:
      let
        b = city[Y[q]][i].b
        t = Z[q] - S[b]
        ai = query(b, t, MX - 1)
      #debug ai
      if Z[q] <= S[ai]:
        echo A[ai] + 1
      elif Z[q] <= T[ai]:
      #if Z[q] in S[ai] + 1 .. T[ai]:
        echo A[ai] + 1, " ", B[ai] + 1
      else:
        echo B[ai] + 1
  discard

when not defined(DO_TEST):
  let N, M, Q = nextInt()
  var
    A, B, S, T = newSeq[int](M)
    X, Y, Z = newSeq[int](Q)
  for i in M:
    A[i] = nextInt()
    B[i] = nextInt()
    S[i] = nextInt()
    T[i] = nextInt()
  for i in Q:
    X[i] = nextInt()
    Y[i] = nextInt()
    Z[i] = nextInt()
  solve(N, M, Q, A, B, S, T, X, Y, Z)
