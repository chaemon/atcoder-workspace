include atcoder/header
#var N,X,Y = nextInt()
var
  N = 200000
  X = 0
  Y = N - 1
var G = newSeq[seq[int]](N)
for i in 0 ..< N - 1:
  #var U,V = nextInt()-1
  G[i].add(i + 1)
  G[i + 1].add(i)
  #G[U].add(V)
  #G[V].add(U)
var frm = newSeqWith(N,-1)
var
  now : seq[int]
  ended = false
proc dfs(x:int)=
  now.add(x+1)
  if x == Y:
    ended= true
    echo now.join(" ")
    return
    #quit()
  for i in G[x]:
    if frm[i] == -1:
      frm[i] = x
      dfs(i)
      if ended: return
  discard now.pop()
frm[X] = X
dfs(X)
echo now.join(" ")
