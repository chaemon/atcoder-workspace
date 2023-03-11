const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

const BS = 18

type Node = ref object
  level:int
  ca, cb:array[2, array[2, array[BS, array[2, int32]]]] # a-digit, b-digit, index, 0 or 1
  next:array[2, Node] # based on A[i][d] xor B[i][d]
  ct: array[BS, array[2, int32]]

var root = Node(level: 0)

solveProc solve(N:int, A:seq[int], B:seq[int]):
  for i in 0..<N:
    var cur = root
    for t in countdown(BS - 1, 0):
      let
        ai = A[i][t]
        bi = B[i][t]
      for u in BS:
        cur.ca[ai][bi][u][A[i][u]].inc
        cur.cb[ai][bi][u][B[i][u]].inc
      let j = ai xor bi
      if cur.next[j] == nil:
        cur.next[j] = Node(level: BS - 1 - t + 1)
      cur = cur.next[j]
    assert cur.level == BS
    for u in BS:
      cur.ct[u][A[i][u]].inc
  var ans = 0
  proc dfs(cur: var Node) =
    if cur == nil: return
    let l = cur.level
    if l < BS:
      for j in 0 ..< 2:
        dfs(cur.next[j])
      for t in 0..1:
        for a in 0..1:
          let
            b = 1 - a
          # (t, t) vs (a, b)
          var
            da = t xor a
            db = t xor b
          doAssert da != db
          if da < db: # A
            for i in BS:
              let c = cur.ca[t][t][i][0].int * cur.ca[a][b][i][1].int + cur.ca[t][t][i][1].int * cur.ca[a][b][i][0].int
              ans += c * (1 shl i)
          else: # B
            for i in BS:
              let c = cur.cb[t][t][i][0].int * cur.cb[a][b][i][1].int + cur.cb[t][t][i][1].int * cur.cb[a][b][i][0].int
              ans += c * (1 shl i)
    else:
      for i in BS:
        let c = cur.ct[i][0].int * cur.ct[i][1].int
        ans += c * (1 shl i)
  dfs(root)
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

