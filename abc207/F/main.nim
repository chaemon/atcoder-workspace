const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

let N = nextInt()

var (u, v) = unzip(N - 1, (nextInt() - 1, nextInt() - 1))

var g = initUndirectedGraph(N, u, v)

type P = (seq[mint], seq[mint], seq[mint])

proc merge0(a:(seq[mint], seq[mint]), b:P):(seq[mint], seq[mint]) =
  let l = a[0].len
  let r = b[0].len
  var L = l + r - 1
  result = (Seq[L: mint], Seq[L: mint])
  # T を配置しない
  for i in 0..<l:
    for j in 0..<r:
      # no T
      result[0][i + j] += a[0][i] * (b[0][j] + b[2][j])
      # with T
      result[1][i + j] += a[1][i] * (b[0][j] + b[1][j] + b[2][j]) + a[0][i] * b[1][j]

proc merge1(a:(seq[mint], seq[mint]), b:P):(seq[mint], seq[mint]) =
  let l = a[0].len
  let r = b[0].len
  var L = l + r - 1
  result = (Seq[L: mint], Seq[L: mint])
  # T を配置しない
  for i in 0..<l:
    for j in 0..<r:
      # no T
      if i + j + 1 < L:
        result[0][i + j + 1] += a[0][i] * b[0][j]
      result[0][i + j] += a[0][i] * b[2][j]
      # with T
      if i + j + 1 < L:
        result[1][i + j + 1] += a[1][i] * b[0][j]
      result[1][i + j] += a[1][i] * (b[1][j] + b[2][j]) + a[0][i] * b[1][j]



proc dfs(u, p:int):P =
  var
    r0 = (@[mint(1)], @[mint(0)])
    r1 = (@[mint(1)], @[mint(0)])
  for e in g[u]:
    if e.dst == p: continue
    let t = dfs(e.dst, u)
    r0 = merge0(r0, t)
    r1 = merge1(r1, t)
  let L = r0[0].len
  result = (Seq[L + 1: mint], Seq[L + 1: mint], Seq[L + 1: mint])
  for i in 0..<L:
    result[0][i] += r0[0][i]
    result[2][i + 1] += r0[1][i]
    result[1][i + 1] += r1[0][i]
    result[1][i + 1] += r1[1][i]


let p = dfs(0, -1)

let L = p[0].len
var ans = Seq[L:mint(0)]
for i in p[0].len: ans[i] += p[0][i]
for i in p[1].len: ans[i] += p[1][i]
for i in p[2].len: ans[i] += p[2][i]

echo ans.join("\n")
