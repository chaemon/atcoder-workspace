when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, u:seq[int], v:seq[int]):
  Pred u, v
  is_listed := N @ false
  ans := N @ -1
  while true:
    list := @(int)
    deg := N @ 0
    for i in u.len:
      if is_listed[u[i]] or is_listed[v[i]]: continue
      deg[u[i]].inc
      deg[v[i]].inc
    for u in N:
      if is_listed[u]: continue
      if deg[u] <= 1: list.add u
    if list.len == 0: break
    if list.len == 1:
      ans[list[0]] = list[0]
      break
    for i in list.len:
      let j = (i + 1) mod list.len
      ans[list[i]] = list[j]
    for u in list:
      is_listed[u] = true
  echo ans.succ.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, u, v)
else:
  discard

