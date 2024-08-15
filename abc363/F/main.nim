when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/convert_base

proc is_nonzerodig(n:int):bool = 0 notin n.toSeq(10)

proc is_palindrome(n:int):bool =
  var v = n.toSeq(10)
  return v == v.reversed

solveProc solve(N:int):
  var d:seq[int]
  for x in 1 .. N:
    if x * x > N: break
    if N mod x != 0: continue
    d.add x
    if x * x < N:
      d.add N div x
  d.sort
  var
    dp = Seq[d.len: string]
    s = d.toSet
  for i in dp.len:
    let v = d[i].toSeq(10)
    if is_nonzerodig(d[i]) and isPalindrome(d[i]):
      dp[i] = $d[i]
    else:
      # dp[i]の値を決める
      for j in 0 ..< i:
        if not is_nonzerodig(d[j]) or d[i] mod d[j] != 0: continue
        var q = d[i] div d[j]
        let u = d[j].toSeq(10).reversed.toInt(10)
        if q mod u != 0: continue
        q.div=u
        let k = d.lowerBound(q)
        if k == d.len or d[k] != q or dp[k].len == 0: continue
        dp[i] = $d[j] & '*' & dp[k] & '*' & $u
  if dp[^1].len == 0:
    echo -1
  else:
    echo dp[^1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

