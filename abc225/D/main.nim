const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

# Failed to predict input format

solveProc solve():
  let N, Q = nextInt()
  var prev, next = Seq[N: -1]
  for _ in Q:
    let q = nextInt()
    if q == 1:
      let x, y = nextInt() - 1
      next[x] = y
      prev[y] = x
    elif q == 2:
      let x, y = nextInt() - 1
      next[x] = -1
      prev[y] = -1
    else:
      var x = nextInt() - 1
      while prev[x] != -1:
        x = prev[x]
      var a = newSeq[int]()
      while true:
        a.add(x + 1)
        x = next[x]
        if x == -1: break
      stdout.write a.len
      echo " " & a.join(" ")
  discard

block main:
  solve()
  discard

