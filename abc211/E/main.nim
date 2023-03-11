const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include "lib/header/chaemon_header"

import lib/structure/set_map
import lib/other/bitutils
import lib/other/direction

#proc test(N:int, s:static[bool] = false) =
#  discard
#
#macro testProc(head, body:untyped):untyped =
#  result = newStmtList()
#  var identDefs = newNimNode(nnkIdentDefs).add(ident"output_stdout").add(newNimNode(nnkBracketExpr).add(ident"static").add(ident"bool")).add(ident"true")
#  var params:seq[NimNode]
#  params.add(identDefs)
#  result.add(newNimNode(nnkProcDef).add(ident"solve2").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(ident"void").add(params)).add(newEmptyNode()).add(newEmptyNode()).add(parseStmt("discard")))
#  echo result.repr
#
#testProc solve2(N:int, K:int):
#  discard
#
#solve2()
#

#var N2:int
#id(i, j:int) => i * N2 + j

const output_stdout = true

#solveProc solve(N:int, K:int, S:seq[string]):
proc solve(N:int, K:int, S:seq[string]) =
#  N2 = N
  var a = initSortedSet(uint)
  proc id(i, j:int):int = i * N + j
  for i in N:
    for j in N:
      if S[i][j] == '#': continue
      a.incl(0u | [id(i, j)])
  for _ in K - 1:
    var a2 = initSortedSet(uint)
    for b in a:
      var t = Seq[N, N: false]
      for i in N:
        for j in N:
          if b[id(i, j)]: t[i][j] = true
      for i in N:
        for j in N:
          if S[i][j] == '#' or t[i][j]: continue
          var found = false
          for (i2, j2) in (i, j).neighbor(dir4, (0..<N, 0..<N)):
            if t[i2][j2]: found = true; break
          if found:
            a2.incl(b or [id(i, j)])
    swap(a, a2)
  echo a.len
  a.excl(0u)
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, K, S)


