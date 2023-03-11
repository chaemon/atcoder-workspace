include atcoder/extra/header/chaemon_header

var dp = Array(100, 100, 100, float)
var vis = Array(100, 100, 100, false)

proc calc(a, b, c:int):float =
  if a >= 100 or b >= 100 or c >= 100: return 0.0
  if vis[a][b][c]: return dp[a][b][c]
  vis[a][b][c] = true
  var ans = 1.0
  let s = a + b + c
  ans += a.float / s.float * calc(a + 1, b, c)
  ans += b.float / s.float * calc(a, b + 1, c)
  ans += c.float / s.float * calc(a, b, c + 1)
  dp[a][b][c] = ans
  return ans

proc solve(A:int, B:int, C:int) =
  echo calc(A, B, C)
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
