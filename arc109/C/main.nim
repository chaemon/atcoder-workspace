include atcoder/extra/header/chaemon_header

let T = "RPS"

proc solve(n:int, k:int, s:string) =
  proc win(a, b:int):int =
    if a == b: return a
    else:
      if (a + 1) mod 3 == b: return b
      else: return a
  var v = newSeq[int]()
  for s in s:
    if s == 'R': v.add(0)
    elif s == 'P': v.add(1)
    elif s == 'S': v.add(2)
    else: assert false
  var l = 1
  for _ in 0..<k:
    var v2 = newSeq[int]()
    for i in 0..<s.len:
      v2.add(win(v[i], v[(i + l) mod s.len]))
    l *= 2
    l = l mod s.len
    swap(v, v2)
  echo T[v[0]]
  return

# input part {{{
block:
  var n = nextInt()
  var k = nextInt()
  var s = nextString()
  solve(n, k, s)
#}}}
