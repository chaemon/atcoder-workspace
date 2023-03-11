include atcoder/extra/header/chaemon_header
import atcoder/modint
import atcoder/fenwicktree

# dump {{{
import macros, strformat

macro dump*(n: varargs[untyped]): untyped =
  var a = "stderr.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

const MOD = 1000000007
var N:int
var M:int
var x:seq[int]
var y:seq[int]

type mint = modint1000000007

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
  x = newSeqWith(N, nextInt())
  y = newSeqWith(M, nextInt())
#}}}

#import complex
import rationals

converter toRational[T](a:T):Rational[T] = initRational(a, T(1))

type SomeFloat = SomeFloat or int

proc main() =
  var p = newSeq[(int,int)]()
  for i in 0..<N:
    var j = y.lower_bound(x[i]) - 1
    if j == -1 or j == M - 1: continue
    p.add((x[i] - y[j], y[j + 1] - x[i]))
  p = p.toSet.toSeq.sorted
  var ps = @[0]
  for i in 0..<p.len:
    ps.add(p[i][1])
  ps = ps.toSet.toSeq.sorted
  for i in 0..<p.len:
    let j = ps.binarySearch(p[i][1])
    assert j != -1
    p[i][1] = j
  var ft = initFenwickTree[mint](ps.len)
  ft.add(0, mint(1))
  var i = 0
  while i < p.len:
    var j = i
    while j < p.len and p[j][0] == p[i][0]: j.inc
    var v = newSeq[(int, mint)]()
    for k in i..<j:
      let s = ft.sum(0..<p[k][1])
      v.add((p[k][1], s))
    for (k, s) in v:
      ft.add(k, s)
    i = j
  echo ft.sum(0..<ps.len)
  return

main()
