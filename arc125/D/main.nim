const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import lib/other/bitutils
import atcoder/segtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc test(A:seq[int]):int =
  debug A
  var t = initTable[string, int]()
  for b in 1..<(2^A.len):
    var s = ""
    for i in 0..<A.len:
      if b[i]: s &= (A[i] + '0'.ord).chr
    if s notin t: t[s] = 0
    t[s].inc
  for s, n in t:
    if n == 1:
      if A[0] == s[0].ord - '0'.ord:
        #echo s
        result.inc

solveProc solve(N:int, A:seq[int]):
  var st = initSegTree[mint](N, (a, b:mint)=>a+b, ()=>mint(0))
  var prev = initTable[int, int]()
  for i in countdown(N - 1, 0):
    if A[i] notin prev:
      prev[A[i]] = i
      st[i] = st[i + 1 .. ^1] + 1
    else:
      let p = prev[A[i]]
      var s = st[i + 1 .. p]
      st[i] = s
      st[p] = 0
      prev[A[i]] = i
    #block:
    #  let t = test(A[i..<A.len])
    #  debug i, t
  echo st.allProd
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)

