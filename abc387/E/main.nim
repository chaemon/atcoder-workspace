when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:string):
  # 11...000
  # 17...000
  # 26...000
  # 35...000
  # 44
  # 53
  # 62
  # 71
  # 80...000
  if N.len < 5:
    proc sumd(n:int):int =
      result = 0
      var n = n
      while n > 0:
        result += n mod 10
        n.div=10
    proc is_good(a:int):bool =
      return a mod sumd(a) == 0 and (a + 1) mod sumd(a + 1) == 0
    let N = N.parseInt
    for a in N .. 2 * N - 1:
      if is_good(a):
        echo a;return
    echo -1
  else:
    var
      a = [11, 17, 26, 35, 44, 53, 62, 71, 80, 110]
      d = 2
      s = N[0..<2].parseInt
    if s == 10:
      d = 3
      s = N[0..<3].parseInt
    var t = a[a.upper_bound(s)]
    echo $t & '0'.repeat(N.len - d)
  discard

when not defined(DO_TEST):
  var N = nextString()
  solve(N)
else:
  discard

