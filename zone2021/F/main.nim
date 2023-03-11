include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils


const DEBUG = true

proc assert2(b:bool) =
  if not b:
    while true:
      discard

solveProc solve(N:int, M:int, A:seq[int]):
  var s = A.toSet()
  var B = Seq[tuple[v, i:int]]
  var A2 = Seq[int]
  for b in N:
    if b in s: continue
    let i = B.len
    B.add((b, i))
    A2.add(b)
  var n = 1
  while true:
    if 2^n == N: break
    n.inc
  if N < n: echo -1;return
  var C = Seq[int]
  for i in n:
    var found = false
    for j in i..<B.len:
      if B[j].v[i]: found = true;swap B[i], B[j]; break
    if not found: echo -1;return
    C.add(A2[B[i].i])
    for j in i+1..<B.len:
      if B[j].v[i]: B[j].v.xor= B[i].v
  var S = initSet[int]()
  for b in 1..<N:
    var v = Seq[int]
    for i in n:
      if b[i]: v.add(i)
    var s = 0
    for i in v.len:
      s.xor=C[v[i]]
    assert2 s != 0 and s notin S
    S.incl(s)
    echo s, " ", s xor C[v[^1]]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt())
  solve(N, M, A)
#}}}

