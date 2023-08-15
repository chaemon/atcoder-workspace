const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve():
  let N = nextInt()
  var f = @[0, 1, 1]
  while true:
    let u = f[^1] + f[^2]
    f.add u
    if u >= 1500: break
  let t = f.len - 1
  proc ask(i:int):int =
    if i in 1 .. N:
      echo "? " & $i
      flushFile(stdout)
      result = nextInt()
      if result == -1:
        quit(0)
      return
    elif i == 0:
      return -int.inf
    else:
      # f[t]が-int.inf
      return -int.inf + f[t] - i
  proc calc(l, i, j, lv, mv, rv:int):int =
    doAssert abs(i - j) == 1
    if i == 1 or j == 1:
      return max([lv, mv, rv])
    let
      m = l + f[i]
      r = m + f[j]
    #debug l, m, r
    #debug i, j, lv, mv, rv
    if i > j:
      # f[i]をf[i - 1] + f[i - 2]
      # f[i - 1], f[i - 2], f[j]
      let a = ask(l + f[i - 1])
      if a > mv:
        return calc(l, i - 1, i - 2, lv, a, mv)
      else:
        return calc(l + f[i - 1], i - 2, j, a, mv, rv)
    else:
      # f[j]をf[j - 2] + f[j - 1]
      # f[i], f[j - 2], f[j - 1]
      let a = ask(l + f[i] + f[j - 2])
      if mv > a:
        return calc(l, i, j - 2, lv, mv, a)
      else:
        return calc(l + f[i], j - 2, j - 1, mv, a, rv)
  let a = ask(f[t - 1])
  echo "! " & $calc(0, t - 1, t - 2, -int.inf, a, -int.inf)
  flushFile(stdout)
  return

when not DO_TEST:
  var T = nextInt()
  for _ in T:
    solve()
