include atcoder/extra/header/chaemon_header


const DEBUG = true

proc calc(x, y:int):seq[int] =
  var (x, y) = (x, y)
  while true:
    if x == 0 or y == 0:
      if x == 1:
        result.add(1)
      else:
        result.add(2)
      return
    if x >= y:
      x -= y
      result.add(3)
    else:
      y -= x
      result.add(4)


proc solve(N:int) =
  var
    x = N
    y0 = (N / ((1.0 + sqrt(5.0)) / 2.0)).int
    ct = 0
  proc check(ans:seq[int]) =
    var x, y = 0
    for a in ans:
      case a:
        of 1: x.inc
        of 2: y.inc
        of 3: x += y
        of 4: y += x
        else: assert false
    doAssert x == N
  for y in y0 - 100..y0+100:
    if y <= 0: continue
    if gcd(x, y) != 1: continue
    var v = calc(x, y)
    if v.len <= 130:
      v.reverse
      echo v.len
      echo v.join("\n")
      check(v)
      return
  doAssert(false)
  return

when false:
  for N in 10^18-1000000..10^18:
    echo "=================================================="
    echo "test: ", N
    solve(N)


# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

