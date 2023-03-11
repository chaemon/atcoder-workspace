import strformat, sequtils, macros

macro `[]`(a: untyped, p: tuple): untyped =
  var strBody = fmt"{a.repr}"
  for i, _ in p.getTypeInst:
    strBody &= fmt"[{p.repr}[{i}]]"
  parseStmt(strBody)

proc dijkstra_custom():int =
  type P = tuple[x, y, dir:int]

  var
    vis = newSeqWith(10, newSeqWith(10, newSeqWith(10, false)))

  proc set_push(p:P, d:int) =
    if vis[p]:
      return

  return 42

var ans = dijkstra_custom()
echo ans
