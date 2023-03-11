import lib/other/algorithmutils

import random

const N = 1000000

var a = newSeq[(int, int)](N)
for i in 0 ..< N: a[i] = (random.rand(0..10000), random.rand(0..100))

for ct in 0..<1000:
  var a = a
  proc check(r:int) =
    for i in 0 ..< r:
      doAssert a[i] <= a[r]
    for i in r+1 ..< N:
      doAssert a[r] <= a[i]
  var r = random.rand(0 ..< N)
  echo "test: ", ct, " ", r
  a.nth_element(r)
  check(r)
