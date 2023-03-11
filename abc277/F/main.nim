when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/cycle_detection

const YES = "Yes"
const NO = "No"

solveProc solve(H: int, W: int, A: seq[seq[int]]):
  block:
    var v = Seq[tuple[l, r: int]]
    for i in H:
      var a = Seq[int]
      for j in W:
        if A[i][j] > 0: a.add A[i][j]
      if a.len > 0:
        v.add (a.min, a.max)
    v.sort()
    for i in v.len - 1:
      if v[i].r > v[i + 1].l:
        echo NO; return
  var
    c = H
    e = Seq[(int, int)]
  for i in H:
    var t = initTable[int, seq[int]]()
    for j in W:
      t[A[i][j]].add j
    var k = collect(newSeq):
      for key in t.keys: key
    k.sort
    for ki in 0 .. k.len - 2:
      if k[ki] > 0:
        for j in t[k[ki]]:
          e.add (j, c)
      for j in t[k[ki + 1]]:
        e.add (c, j)
      c.inc
  var g = initGraph[int](c)
  for (x, y) in e:
    g.addEdge(x, y)
  var cd = g.cycleDetection()
  if cd.isSome:
    echo NO
  else:
    echo YES
  discard

import random

when not defined(DO_TEST):
#if not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
else:
  for _ in 10000:
    let H, W = 10
    var v = Seq[H * W: random.rand(0 .. H * W)]
    #v.sort
    var A = Seq[H, W: int]
    for i in H:
      for j in W:
        A[i][j] = v[i * W + j]
    proc swap_row(i, j: int) =
      for k in W:
        swap A[i][k], A[j][k]
    proc swap_col(i, j: int) =
      for k in H:
        swap A[k][i], A[k][j]
    for _ in 100:
      let t = random.rand(0..1)
      if t == 0:
        var i = random.rand(0 ..< H)
        var j: int
        while true:
          j = random.rand(0 ..< H)
          if i != j: break
        if i > j: swap i, j
        swap_row(i, j)
      else:
        var i = random.rand(0 ..< W)
        var j: int
        while true:
          j = random.rand(0 ..< W)
          if i != j: break
        if i > j: swap i, j
        swap_col(i, j)
    debug H, W, A
    solve(H, W, A)
