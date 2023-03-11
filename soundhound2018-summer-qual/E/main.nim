#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc infinity[T]():T =
  return (T(1) shl T(sizeof(T)*8-2))-1
#}}}

#{{{ Graph
type Edge = object
  src,dst:int
  weight:int
  rev:int

proc newEdge(src,dst,weight,rev:int):Edge =
  var e:Edge
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

type Graph = seq[seq[Edge]]

proc newGraph(n:int):Graph=
  var g:Graph
  g = newSeqWith(n,newSeq[Edge]())
  return g

proc addBiEdge(g:var Graph,src,dst:int,weight:int=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge(g:var Graph,src,dst:int,weight:int=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

proc main():void =
  var
    n = nextInt()
    m = nextInt()
    u = newSeq[int](m)
    v = newSeq[int](m)
    s = newSeq[int](m)
    G = newGraph(n)
  for i in 0..<m:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    s[i] = nextInt()
    G.addBiEdge(u[i],v[i],s[i])
  var
    eval = [infinity[int](),infinity[int]()]
    vis = newSeq[bool](n)
    col = newSeq[int](n)
    val = newSeq[int](n)
    valid = true
    found = false
    found_val = 0
  proc dfs(u,prev,color,value:int):void =
    vis[u] = true
    col[u] = color
    val[u] = value
    eval[color] = min(eval[color],value)
    for e in G[u]:
      var v = e.dst
      if v == prev: continue
      if vis[v]:
        if col[v] != col[u]:
          if val[u] + val[v] != e.weight:
            valid = false
        else:
          var s:int
          if col[u] == 0:
            s = e.weight - val[u] - val[v]
          else:
            s = val[u] + val[v] - e.weight
          if s mod 2 != 0:
            valid = false
          else:
            s = s div 2
            if found:
              if found_val != s:
                valid = false
            else:
              found = true
              found_val = s
      else:
        dfs(e.dst,u,1 - color,e.weight - value)
  dfs(0,-1,0,0)
  if not valid:
    echo 0
  elif found:
    if eval[0] + found_val <= 0 or eval[1] - found_val <= 0:
      echo 0
    else:
      echo 1
  else:
    var
      smin = 1 - eval[0]
      smax = eval[1] - 1
    echo max(0,smax - smin + 1)

main()

