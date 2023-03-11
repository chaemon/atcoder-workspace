import sequtils, tables

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

let
  N = nextInt()
  D = nextInt()

proc sqrt_int(a:int):int =
  var
    l = 0
    r = 2000000000
  while r - l > 1:
    var m = (l + r) div 2
    if a >= m * m:
      l = m
    else:
      r = m
  return l


var x = newSeq[seq[int]](N)

for i in 0..N-1:
  x[i] = newSeq[int](D)
  for j in 0..D-1:
    x[i][j] = nextInt()

var ans = 0

for i in 0..N-1:
  for j in i+1..N-1:
    var s = 0
    for d in 0..D-1:
      s += (x[i][d] - x[j][d])*(x[i][d] - x[j][d])
    let t = sqrt_int(s)
    if t*t == s:
      ans+=1

echo ans
