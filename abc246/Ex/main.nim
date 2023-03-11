const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type P = object
  set: bool
  all: array[2, bool] # すべて1かすべて0か
  a:array[2, array[2, mint]] # i: 最初の文字, j: 最後に探す文字
  sum: array[2, mint] # iからはじめた文字列の種類数


proc op(l, r:P):P = 
  if not r.set: return l
  result.set = true
  for i in 0..1:
    result.all[i] = l.all[i] and r.all[i]
  # 初期化
  for i in 0..1:
    result.sum[i] = 0
    for j in 0..1:
      result.a[i][j] = 0
  # lのみ
  for i in 0..1:
    # iで始まる
    for j in 0..1:
      # jを探して終わる = rの側は全部1 - j
      if not r.all[1 - j]: continue
      result.a[i][j] += l.a[i][j]
    result.sum[i] += l.sum[i]
  # rのみ
  for i in 0..1:
    # iで始まる = lの側は全部1 - i
    if not l.all[1 - i]: continue
    for j in 0..1:
      result.a[i][j] += r.a[i][j]
    result.sum[i] += r.sum[i]
  # 両方
  for i in 0..1:
    # lの側がiで始まる
    for j in 0..1:
      # rの側のjへ行く
      result.sum[i] += l.a[i][j] * r.sum[j]
      for k in 0..1:
        result.a[i][k] += l.a[i][j] * r.a[j][k]

proc e():P =
  return P(set: false)

var
  zero     = P(set: true, all: [true, false], a:[[mint(1), mint(1)], [mint(0), mint(0)]], sum: [mint(1), mint(0)])
  one      = P(set: true, all: [false, true], a:[[mint(0), mint(0)], [mint(1), mint(1)]], sum: [mint(0), mint(1)])
  question = P(set: true, all: [false, false], a:[[mint(1), mint(1)], [mint(1), mint(1)]], sum: [mint(1), mint(1)])

solveProc solve(N:int, Q:int, S:string, x:seq[int], c:seq[string]):
  var st = initSegTree[P](N, op, e)
  for i in 0..<N:
    if S[i] == '0':
      st[i] = zero
    elif S[i] == '1':
      st[i] = one
    elif S[i] == '?':
      st[i] = question
    else:
      doAssert false
  for q in Q:
    let
      x = x[q]
      c = c[q][0]
    case c:
      of '0':
        st[x] = zero
      of '1':
        st[x] = one
      of '?':
        st[x] = question
      else:
        doAssert false
    echo st.allProd.sum.sum
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var S = nextString()
  var x = newSeqWith(Q, 0)
  var c = newSeqWith(Q, "")
  for i in 0..<Q:
    x[i] = nextInt() - 1
    c[i] = nextString()
  solve(N, Q, S, x, c)
else:
  discard

