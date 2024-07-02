when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

type P = array[2, tuple[v, c:int]]

proc merge(a, b:tuple[v, c:int])

proc op(a, b:P):P =
  var
    i = 0
    j = 0
    k = 0
  while k < 2:
    if a[i].v > a[j].v
      result[k].

      i.cin
    elif a[i].v < a[j].v
    else:
      result[k].v = a[i].v
      result[k].c = a[i].c + b[j].c
  for i in 
  if a[0] == b[0]:
    result[0] = a[0]
    result[0].c += b[0].c
    if 

proc e()

var st = initSegTree[P]()

# Failed to predict input format
solveProc solve():
  discard

when not DO_TEST:
  solve()
else:
  discard

