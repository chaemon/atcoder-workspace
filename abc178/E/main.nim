include atcoder/extra/header/chaemon_header

var N:int
var x:seq[int]
var y:seq[int]

# input part {{{
block:
  N = nextInt()
  x = newSeqWith(N, 0)
  y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
#}}}

block main:
  var z, w = newSeq[int]()
  for i in 0..<N:
    z.add x[i] + y[i]
    w.add x[i] - y[i]
  print max(z.max - z.min, w.max - w.min)
  break
