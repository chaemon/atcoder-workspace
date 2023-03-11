include atcoder/extra/header/chaemon_header

const DEBUG = true

proc factpow3(n:int):int =
  var n = n
  result = 0
  while n > 0:
    result += n div 3
    n.div=3

const B = 1000000
var fact3 = Array[B: int]

proc comb3(n:int, r:int):int =
  block:
    let a = factpow3(n)
    let b = factpow3(n - r) + factpow3(r)
    if a > b: return 0
  block:
    var a = fact3[n]
    let b = (fact3[n - r] * fact3[r]) mod 3
    a *= b
    a.mod=3
    return a

proc solve(N:int, c:string) =
  fact3[0] = 1
  for i in 1..<B:
    assert fact3[i - 1] != 0
    fact3[i] = fact3[i - 1] * i
    while fact3[i] mod 3 == 0:
      fact3[i].div=3
    fact3[i].mod=3
  ans := 0
  for i in 0..<N:
    var t:int
    let c = c[i]
    if c == 'W': t = 0
    elif c == 'B': t = 1
    elif c == 'R': t = 2
    else: assert false
    ans += t * comb3(N - 1, i)
    ans.mod= 3
  if (N - 1) mod 2 == 1:
    ans *= 2 # -1
    ans.mod=3
  if ans == 0: echo "W"
  elif ans == 1: echo "B"
  elif ans == 2: echo "R"
  else: assert false
  return

# input part {{{
block:
  var N = nextInt()
  var c = nextString()
  solve(N, c)
#}}}

