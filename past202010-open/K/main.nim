include atcoder/extra/header/chaemon_header

import atcoder/segtree
const MOD = 10^9

const DEBUG = true

const B = 20

# Failed to predict input format
block main:
  let K = nextInt()
  cts := Seq[Array[B:int]]
  t := Seq[int]
  for i in 0..<K:
    ct := Array[B: 0]
    let n = nextInt()
    let a = Seq[n: nextInt() - 1]
    var st = initSegTree(20, (a, b:int)=>a+b, ()=>0)
    s := 0
    for a in a:
      ct[a].inc
      s += st[a+1..<B]
      st[a] = st[a] + 1
      s.mod= MOD
    cts.add(ct)
    t.add(s)
  var ans = 0
  var st = initSegTree(20, (a, b:int)=>a+b, ()=>0)
  let Q = nextInt()
  for i in 0..<Q:
    let b = nextInt() - 1
    ans += t[b]
    ans.mod= MOD
    for n in 0..<B:
      ans += st[n+1..<B] * cts[b][n]
      ans.mod=MOD
    for n in 0..<B:
      st[n] = st[n] + cts[b][n]
  echo ans
  discard

