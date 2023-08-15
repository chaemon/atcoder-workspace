when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import std/heapqueue

solveProc solve(N:int, M:int, A:seq[int]):
  Pred A
  # 最も左と最も右
  var
    e = M @ -int.inf
    selected = M @ false
    f = -1
  for i in N:
    e[A[i]].max=i
  # 選択可能なインデックス
  var
    qe = initHeapQueue[tuple[i, v:int]]() # 残ったインデックスの終了位置の早い順
    qi = initHeapQueue[tuple[v, i:int]]() # 値, インデックスで早い順
  for i in M:
    qe.push((e[i], i))
  var
    fi = 0
    ans:seq[int]
    p = -1
  for t in M:
    # 終了位置の最小値を取得
    var i, v:int
    while true:
      doAssert qe.len > 0
      (i, v) = qe.pop()
      if selected[v]: continue
      qe.push((i, v))
      break
    # 終了位置が動いた分をqiにプッシュする
    for j in p + 1 .. i:
      qi.push (A[j], j)
    p = i
    # qiから一つとる
    while true:
      doAssert qi.len > 0
      let (a, i) = qi.pop
      if selected[a] or i < f: continue
      f = i
      ans.add a
      selected[a] = true
      break
  echo ans.succ.join(" ")

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

