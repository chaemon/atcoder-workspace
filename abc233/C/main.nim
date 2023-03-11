import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL 
Please use Nim-ACL
Please use Nim-ACL

const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N, X = nextInt()
  var a:seq[seq[int]]
  for i in N:
    let L = nextInt()
    a.add Seq[L:nextInt()]
  var ans = 0
  proc dfs(v:var seq[int], P:int) =
    if v.len == N:
      if P == X:
        ans.inc
    else:
      let t = v.len
      for i in a[t].len:
        v.add i
        if X mod a[t][i] == 0:
          let u = X div a[t][i]
          if P <= u:
            dfs(v, P * a[t][i])
        discard v.pop
  var v = Seq[int]
  dfs(v, 1)
  echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

