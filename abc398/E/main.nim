when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

let N = nextInt()
var
  g = initGraph(N)
  color = Seq[N: -1]
  edges = Seq[(int, int)]
for i in N - 1:
  let U, V = nextInt() - 1
  g.addBiEdge(U, V)
  edges.add (U, V)

proc dfs(u, p, c:int) =
  color[u] = c
  for e in g[u]:
    if e.dst == p: continue
    dfs(e.dst, u, c xor 1)

dfs(0, -1, 0)

var
  zero, one = Seq[int]

for u in N:
  if color[u] == 0:
    zero.add u
  else:
    one.add u

var
  a = Seq[N, N: false]
  rest = Seq[(int, int)]

for (U, V) in edges:
  a[U][V] = true
  a[V][U] = true

for U in zero:
  for V in one:
    if a[U][V]: continue
    rest.add (U, V)

var t = 0

if rest.len mod 2 == 0:
  t = 0
  echo "Second"
else:
  t = 1
  echo "First"

while true:
  if t == 0: # 高橋くん
    var i, j = nextInt()
    if i == -1 and j == -1:
      break
    i.dec;j.dec
    a[i][j] = true
    a[j][i] = true
  else:
    # 1のとき自分
    var i, j:int
    while true:
      var (i0, j0) = rest.pop()
      if not a[i0][j0]:
        i = i0
        j = j0
        if i > j: swap(i, j)
        break
    echo i + 1, " ", j + 1
    a[i][j] = true
    a[j][i] = true
  t = t xor 1


