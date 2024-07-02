when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, H:int, W:int, A:seq[int], B:seq[int]):
  var
    a = Seq[H, W: false]
    x = 0
    y = 0
    used = Seq[N: false]
    found = false
  when DEBUG:
    var ans:seq[(int, int)]
  proc f() =
    # 空いているマスを探す
    var
      x_prev = x
      y_prev = y
    while x < H and a[x][y]:
      y.inc
      if y == W:
        x.inc
        y = 0
    if x == H:
      found = true
      return
    # (x, y)を左上とするタイルを置く
    for j in N:
      if used[j]: continue
      used[j] = true
      var
        A = A[j]
        B = B[j]
      proc is_put():bool =
        for s in x ..< x + A:
          for t in y ..< y + B:
            if s notin 0 ..< H or t notin 0 ..< W or a[s][t]: return false
        return true
      proc put() =
        for s in x ..< x + A:
          for t in y ..< y + B:
            a[s][t] = true
      proc unput() =
        for s in x ..< x + A:
          for t in y ..< y + B:
            a[s][t] = false
      for _ in 2:
        if is_put():
          put()
          when DEBUG:
            ans.add (A, B)
          f()
          if found: return
          unput()
          when DEBUG:
            discard ans.pop
        swap A, B
      used[j] = false
    swap x, x_prev
    swap y, y_prev
  f()
  if found:
    echo YES
    when DEBUG:
      debug ans
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, H, W, A, B)
else:
  discard

