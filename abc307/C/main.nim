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
solveProc solve(H_A:int, W_A:int, A:seq[string], H_B:int, W_B:int, B:seq[string], H_X:int, W_X:int, X:seq[string]):
  var
    ax_min = int.inf
    ay_min = int.inf
    ax_max = -int.inf
    ay_max = -int.inf
  for i in H_A:
    for j in W_A:
      if A[i][j] == '#':
        ax_min.min=i
        ay_min.min=j
        ax_max.max=i
        ay_max.max=j
  var
    bx_min = int.inf
    by_min = int.inf
    bx_max = -int.inf
    by_max = -int.inf
  for i in H_B:
    for j in W_B:
      if B[i][j] == '#':
        bx_min.min=i
        by_min.min=j
        bx_max.max=i
        by_max.max=j
  # ax_min .. ax_maxがすべて0 .. H_Xに含まれる
  # Xは(0, 0)から(H_X - 1, W_X - 1)に固定
  # Aの左上は(-H_A, -W_A)と(H_X - 1, W_X - 1)がありうる
  for x_a in -ax_min ..< H_X - ax_max:
    for y_a in -ay_min ..< W_X - ay_max:
      for x_b in -bx_min ..< H_X - bx_max:
        for y_b in -by_min ..< W_X - by_max:
          var ok = true
          for i in H_X:
            for j in W_X:
              let
                ta = i - x_a
                tb = i - x_b
                ua = j - y_a
                ub = j - y_b
              var
                U, V = false
              block:
                if ta notin 0 ..< H_A: break
                if ua notin 0 ..< W_A: break
                if A[ta][ua] == '#': U = true
              block:
                if tb notin 0 ..< H_B: break
                if ub notin 0 ..< W_B: break
                if B[tb][ub] == '#': V = true
              var C = if U or V: '#' else: '.'
              if X[i][j] != C: ok = false
          if ok:
            echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var H_A = nextInt()
  var W_A = nextInt()
  var A = newSeqWith(H_A, nextString())
  var H_B = nextInt()
  var W_B = nextInt()
  var B = newSeqWith(H_B, nextString())
  var H_X = nextInt()
  var W_X = nextInt()
  var X = newSeqWith(H_X, nextString())
  solve(H_A, W_A, A, H_B, W_B, B, H_X, W_X, X)
else:
  discard

