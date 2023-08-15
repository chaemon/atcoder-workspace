when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

#const B = 4
const B = 480

proc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, T:seq[int], x:seq[int]):void =
  Pred a, b, x
  var g = initGraph(N)
  for i in M:
    g.addBiEdge a[i], b[i]
  # 次数B以上の頂点をSpecial Nodeとする
  var
    special_ct = 0
    isSpecial = N @ -1
    recv = N @ 0 # recv[u]: uが受け取った個数
    recv_special:seq[seq[int]] # recv_special[i][u]: special id i から uが受け取った回数
    send:seq[int] # send[i]: special id iが送った回数
    has_edge: seq[seq[bool]]
  for u in N:
    if g[u].len >= B:
      isSpecial[u] = special_ct
      var edge = N @ false
      for e in g[u]:
        edge[e.dst] = true
      has_edge.add edge
      send.add 0
      recv_special.add N @ 0
      special_ct.inc

  for q in Q:
    let (x, T) = (x[q], T[q])
    case T:
      of 1:
        let i = isSpecial[x]
        if i == -1:
          for e in g[x]:
            recv[e.dst].inc
        else:
          send[i].inc
      of 2:
        var ans = recv[x]
        recv[x] = 0
        for i in special_ct:
          if not has_edge[i][x]: continue
          let d = send[i] - recv_special[i][x]
          ans += d
          recv_special[i][x] = send[i]
        echo ans
      else:
        doAssert false
  discard

proc main():void =
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    x[i] = nextInt()
  solve(N, M, a, b, Q, T, x);
  return

main()
