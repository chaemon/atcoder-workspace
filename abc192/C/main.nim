include atcoder/extra/header/chaemon_header


const DEBUG = false

proc f(x:int):int = 
  var x = x
  var d = newSeq[int]()
  while x > 0:
    d.add(x mod 10)
    x = x div 10
  d.sort()
  x = 0
  p := 1
  for i in d.len:
    x += (d[i] - d[d.len - 1 - i]) * p
    p *= 10
  return x


proc solve(N:int, K:int) =
  var K = K
  i := 0
  x := N
  tb := initTable[int,int]()
  found := false
  var v = newSeq[int]()
  while true:
    debug i, x
    v.add(x)
    if i == K:
      echo x;break
    if not found and x in tb:
      debug x, tb[x]
      found = true
      K -= tb[x]
      K = K mod (i - tb[x])
      K += tb[x]
      debug K
      echo v[K]
      break
    tb[x] = i
    x = f(x)
    i.inc
  return


# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

