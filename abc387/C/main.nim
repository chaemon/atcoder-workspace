when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(L:int, R:int):
  proc calc(n:int):int =
    if n < 10: return 0
    # n以下のヘビ数
    var d:seq[int]
    block:
      var n = n
      while n > 0:
        d.add n mod 10
        n.div=10
      d.reverse
    result = 0
    for k in 2 ..< d.len:
      # k桁
      for x in 1 .. 9:
        # 最高位がx
        result += x^(k - 1)
    for x in 1 .. d[0]:
      if d[0] > x:
        result += x^(d.len - 1)
      elif d[0] == x:
        for i in 1 ..< d.len:
          # d[i - 1]まで追従
          if d[i] >= 1:
            for di in 0 ..< x:
              if di >= d[i]: break
              result += x^(d.len - 1 - i)
          if d[i] >= x:
            # 追従不可
            break
          if i == d.len - 1:
            result.inc
      else:
        doAssert false
  echo calc(R) - calc(L - 1)
  discard

when not defined(DO_TEST):
  var L = nextInt()
  var R = nextInt()
  solve(L, R)
else:
  discard

