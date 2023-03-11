include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(a:int, b:int, c:int) =
  if a == b: echo c
  elif b == c: echo a
  elif c == a: echo b
  else: echo 0
  return

# input part {{{
block:
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  solve(a, b, c)
#}}}

