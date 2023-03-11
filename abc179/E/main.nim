include atcoder/extra/header/chaemon_header

var N:int
var X:int
var M:int

# input part {{{
proc main()
block:
  N = nextInt()
  X = nextInt()
  M = nextInt()
#}}}

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  pos:int
  data: seq[T]

proc initCumulativeSum[T](n = 1):CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(n, T(0)), pos:0)
proc `[]=`[T](self: var CumulativeSum[T], k:int, x:T) =
  if k < self.pos: doAssert(false)
  if self.data.len < k + 2: self.data.setLen(k + 2)
  self.data[k + 1] = x

proc propagate[T](self: var CumulativeSum[T]) =
  while self.data.len < self.pos + 2: self.data.setLen(self.pos + 2)
  self.data[self.pos + 1] += self.data[self.pos]
  self.pos.inc

proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = initCumulativeSum[T]()
  for i,d in data: result[i] = d

proc sum[T](self: var CumulativeSum[T], k:int):T =
  if k < 0: return T(0)
  while self.pos <= k: self.propagate()
  return self.data[k]
proc `[]`[T](self: var CumulativeSum[T], s:Slice[int]):T =
  if s.a > s.b: return T(0)
  return self.sum(s.b + 1) - self.sum(s.a)
#}}}

proc main() =
  var
    vis = newSeqWith(M, -1)
    v = newSeq[int]()
  var i = 0
  while true:
    if vis[X] != -1:
      let d = i - vis[X]
      var cs = initCumulativeSum(v)
      # 0 ..< vis[X]  and vis[X] ..< i
      if N < i:
        echo cs[0..<N]
        return
      let q = (N - vis[X]) div d
      let r = N - vis[X] - q * d
      echo cs[0..<vis[X]] + cs[vis[X]..<i] * q + cs[vis[X]..<vis[X] + r]
      return
    vis[X] = i
    v.add(X)

    X = X * X mod M
    i.inc

  return

main()

