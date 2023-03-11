const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/modint
type mint = modint
const B = 10000

solveProc solve(K:int):
  var K = K
  if K mod 4 == 0 or K mod 5 == 0:
    echo -1;return
  if K mod 2 == 0: K.div=2
  mint.setMod(K)
  let p = mint(10)^B
  var c = mint(0)
  var t = initTable[int, seq[int]]()
  for i in B:
    if c notin t:
      t[c] = newSeq[int]()
    t[c].add i
    c *= 10
    c += 2
  # c = 22..2(B)
  For (var i = 0;var s = mint(0);var q = mint(1)), true, (i.inc;s *= p;s += c;q *= p):
    # s + q * x == 0
    var x = (-s) / q
    if x in t:
      for j in t[x]:
        let u = i * B + j
        if u > 0: echo u;return
    discard

block main:
  let T = nextInt()
  for _ in T:
    let K = nextInt()
    solve(K)
  discard

