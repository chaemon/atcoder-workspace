#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
import system, os, streams
when defined(MYDEBUG):
  import header

type Scanner = object
  f: File
proc nextString(s:Scanner): string =
  var get = false
  result = ""
  while true:
    var c = s.f.readChar
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break

proc nextInt(s:Scanner, base:int = 0): int = parseint(s.nextString) - base
proc nextFloat(s:Scanner): float = parsefloat(s.nextString)

proc newScanner(f:File): Scanner = Scanner(f:f)
proc newScanner(fname:string): Scanner = newScanner(open(fname, FileMode.fmRead))

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

let
  header_prefix = "Input                 Output\n----------------------------------"
  input_prefix  = "                      "

proc quitAC() =
  stderr.write "Judge: AC\n"
  quit(0)
proc quitWA(message:string = "") =
  stderr.write "Judge: WA ( " & message & " ) \n"
  quit(1)
proc input():string =
  result = stdin.readLine
  stderr.write(input_prefix & result & '\n')
proc output(s:string) =
  stderr.write(s & '\n')
  echo s

#{{{ Graph
type Edge[T] = object
  src,dst:int
  weight:T
  rev:int

proc newEdge[T](src,dst:int,weight:T,rev:int = -1):Edge[T] =
  var e:Edge[T]
  e.src = src
  e.dst = dst
  e.weight = weight
  e.rev = rev
  return e

type Graph[T] = seq[seq[Edge[T]]]

#proc newGraph[T](n:int):Graph[T]=
#  var g:Graph[T]
#  g = newSeqWith(n,newSeq[Edge[T]]())
#  return g
proc newGraph(n:int):Graph[int]=
  var g:Graph[int]
  g = newSeqWith(n,newSeq[Edge[int]]())
  return g

proc addBiEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,g[dst].len))
  g[dst].add(newEdge(dst,src,weight,g[src].len-1))

proc addEdge[T](g:var Graph[T],src,dst:int,weight:T=1):void =
  g[src].add(newEdge(src,dst,weight,-1))
#}}}

proc dist(G:Graph[int], u,v:int):int =
  proc dfs(u:int,prev = -1, h = 0):int =
    if u == v: return h
    for e in G[u]:
      if e.dst == prev: continue
      let d = dfs(e.dst,u,h+1)
      if d != -1: return d
    return -1
  return dfs(u, -1, 0)

proc output(n:int) =
  output($n)

proc main():void =
  stderr.write(header_prefix & '\n')
  output(open(os.commandLineParams()[0],fmRead).readAll())
  var
    s_in = newScanner(os.commandLineParams()[0])
    s_out = newScanner(os.commandLineParams()[1])
  let N, Q = s_in.nextInt()
  var G = newGraph(N)
  for i in 0..<N-1:
    let a,b = s_in.nextInt(1)
    G.addBiEdge(a,b)
  let home = s_out.nextInt(1)
  stderr.write("start query\n")
  var ct = 0
  while true:
    let line = input().split()
    if line[0] == "?":
      ct += 1
      if ct > Q:
        quitWA("too many queries")
      let
        u = parseint(line[1]) - 1
        v = parseint(line[2]) - 1
        du = G.dist(u,home)
        dv = G.dist(v,home)
      if du < dv: output(u + 1)
      elif du > dv: output(v + 1)
      else: output(0)
    elif line[0] == "!":
      let x = parseint(line[1]) - 1
      if x == home: quitAC()
      else: quitWA("incorrect output")
    else:
      quitWA("invalid format")

main()
