when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A # 0 <= A[i] < N
  var a = Seq[N: seq[int]]
  for i in N:
    a[A[i]].add i
  var ans = 0
  for p in N:
    # pが選ばれて、p - 1が選ばれないような区間を数える
    var v = newSeq[tuple[i, t: int]]()
    for i in a[p]:
      v.add (i, 1)
    if p - 1 >= 0:
      for i in a[p - 1]:
        v.add (i, 0)
    v.add (-1, 0)
    v.add (N, 0)
    v.sort
    var left = -1
    #debug v
    for i in v.len:
      case v[i].t
      of 0:
        left = v[i].i + 1
      of 1:
        # v[i].iが一番右のpになるように
        let right = v[i + 1].i
        # left ..< rightが有効な区間
        # 開始位置: left .. v[i].i
        # 終了位置: v[i].i + 1 .. right
        ans += (v[i].i - left + 1) * (right - v[i].i)
      else:
        doAssert false
    #debug p, ans
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

