when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header


type RollbackDSU* = object
  data:seq[int]
  history:seq[(int, int)]
  inner_snap:int

proc initRollbackDSU*(sz:int):RollbackDSU =
  RollbackDSU(inner_snap: 0, data: newSeqWith(sz, -1))

proc leader(self: RollbackDSU, k:int):int =
  if self.data[k] < 0: return k
  return self.leader(self.data[k])

proc merge(self: var RollbackDSU, x, y:int):bool {.discardable.} =
  var
    x = self.leader(x)
    y = self.leader(y)
  self.history.add (x, self.data[x])
  self.history.add (y, self.data[y])
  if x == y: return false
  if self.data[x] > self.data[y]: swap(x, y)
  self.data[x] += self.data[y]
  self.data[y] = x
  return true

proc same(self: RollbackDSU, x, y:int):bool = self.leader(x) == self.leader(y)
proc size(self: RollbackDSU, k:int):int =  -self.data[self.leader(k)]

proc undo(self: var RollbackDSU) =
  for _ in 0 .. 1:
    self.data[self.history[^1][0]] = self.history[^1][1]
    discard self.history.pop()

proc snapshot(self: var RollbackDSU) =
  self.inner_snap = self.history.len shr 1

proc get_state(self: RollbackDSU):int = self.history.len shr 1

proc rollback(self: var RollbackDSU, state = -1) =
  var state = state
  if state == -1: state = self.inner_snap
  state = state shl 1
  doAssert state <= self.history.len
  while state < self.history.len: self.undo()

import lib/graph/graph_template

solveProc solve(N:int, A:seq[int], B:seq[int], U:seq[int], V:seq[int]):
  Pred A, B, U, V
  var g = initGraph[int](N)
  for i in U.len:
    g.addBiEdge(U[i], V[i])
  var
    ans = 0
    d = initRollbackDSU(N)
    es = newSeq[int](N)
    ans0 = newSeq[int](N - 1)
  proc get(u:int):int =
    let
      u = d.leader(u)
      sz = d.size(u)
    if es[u] == sz - 1: return sz - 1
    else: return sz
  proc dfs(u:int, p = -1) =
    # A[u], B[u]を追加
    var
      old_ans = ans
      update = false
      L, R: int
      Lv, Rv: int
    if d.leader(A[u]) != d.leader(B[u]):
      L = d.leader(A[u])
      R = d.leader(B[u])
      ans -= get(L) + get(R)
      Lv = es[L]
      Rv = es[R]
      d.merge(L, R)
      let M = d.leader(L)
      es[M] = Lv + Rv + 1
      ans += get(M)
      update = true
    else:
      ans -= get(A[u])
      es[d.leader(A[u])].inc
      ans += get(A[u])
    if u > 0:
      ans0[u - 1] = ans
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
    # A[u], B[u]を追加を戻す
    ans = old_ans
    if update:
      d.undo
      es[L] = Lv
      es[R] = Rv
    else:
      es[d.leader(A[u])].dec
  dfs(0)
  echo ans0.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, A, B, U, V)
else:
  discard

