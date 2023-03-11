include atcoder/extra/header/chaemon_header

var N:int
var M:int
var S:string
var T:string

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  S = nextString()
  T = nextString()
#}}}

proc main() =
  let L = lcm(N, M)
  var tb = initTable[int, char]()
  for i in 0..<N:
    let id = (L div N) * i
    tb[id] = S[i]
  for i in 0..<M:
    let id = (L div M) * i
    if id in tb and tb[id] != T[i]:
      echo -1;return
  echo L
  return

main()

