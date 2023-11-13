when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import std/heapqueue

solveProc solve(N:int, x:seq[int], y:seq[int]):
  var
    q = initHeapQueue[tuple[l, n:int]]() # l: スタート位置, n: 個数
    ans = int.inf
  for i in N:
    let py = if i == 0: 0 else: y[i - 1]
    if py <= y[i]:
      # 増える場合は直前 + 1を最初にする
      let l = if i == 0: -int.inf else: x[i - 1] + 1
      q.push((l, y[i] - py))
    else:
      # 減る場合はlが小さい順に
      # 終了はx[i] - 1
      var d = py - y[i]
      while d > 0:
        var (l, n) = q.pop
        if d >= n:
          d -= n
        else:
          # nをn - dにしてqに戻す
          n -= d
          d = 0
          q.push((l, n))
        ans.min=x[i] - 1 - l
  if ans == int.inf:
    echo -1
  else:
    echo ans

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var x = newSeqWith(N, nextInt())
  var y = newSeqWith(N, nextInt())
  solve(N, x, y)
else:
  discard

