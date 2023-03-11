import strutils
import sequtils
import math

var Q = parseInt(readLine(stdin))

proc sqrt_int(a:int64):int64 =
  var
    l = 0'i64
    r = 2000000000'i64
  while r - l > 1:
    var m = (l + r) div 2
    if a >= m * m:
      l = m
    else:
      r = m
  return l

for i in 1..Q:
  var v = readLine(stdin).split().map(parseInt)
  var A = int64(v[0])
  var B = int64(v[1])
  if A==B:
    echo A*2-2
  else:
    if A>B:
      swap(A,B)
#    var t = int64(floor(sqrt(float64(A*B-1))+1e-13))
    var t = sqrt_int(A * B - 1)
    if t*(t+1)>=A*B:
      echo t*2-2
    else:
      echo t*2-1
