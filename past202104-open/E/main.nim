include atcoder/extra/header/chaemon_header
import deques

const DEBUG = true

proc solve(N:int, S:string) =
  d := initDeque[int]()
  for i,s in S:
    if s == 'L': d.addFirst(i + 1)
    elif s == 'R': d.addLast(i + 1)
    elif s == 'A': 
      if d.len <= 0: echo "ERROR"
      else:
        echo d.popFirst()
    elif s == 'B':
      if d.len <= 1: echo "ERROR"
      else:
        swap(d[1], d[0])
        echo d.popFirst()
    elif s == 'C':
      if d.len <= 2: echo "ERROR"
      else:
        swap(d[2], d[1])
        swap(d[1], d[0])
        echo d.popFirst()
    elif s == 'D':
      if d.len <= 0: echo "ERROR"
      else:
        echo d.popLast()
    elif s == 'E':
      if d.len <= 1: echo "ERROR"
      else:
        swap(d[^2], d[^1])
        echo d.popLast()
    elif s == 'F':
      if d.len <= 2: echo "ERROR"
      else:
        swap(d[^3], d[^2])
        swap(d[^2], d[^1])
        echo d.popLast()
    else:
      assert false
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

