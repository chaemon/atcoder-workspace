include atcoder/extra/header/chaemon_header

const DEBUG = true

let N = nextInt()
let a = Seq(N, nextInt() - 1)
var vis = Seq(N, false)

ans := 0

for u in 0..<N:
  if vis[u]: continue
  var u0 = u
  var u = u
  var ct = 0
  if a[u] == u: continue
  while true:
    vis[u] = true
    u = a[u]
    ct.inc
    if u == u0: break
  ans += ct - 1

if ans mod 2 != N mod 2:
  echo "NO"
elif ans > N:
  echo "NO"
else:
  echo "YES"
