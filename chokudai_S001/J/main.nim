include atcoder/extra/header/chaemon_header

import atcoder/extra/structure/set_map

const DEBUG = true

type C = object
  b:int

proc `{}`(self:C, a:int):int = a
proc `{}=`(self:var C, a:int, b:int):void = self.b = b

var c = C()

echo c{10}
c{10} = 12


block:
  var s = initSortedSet[int]()
  let N = nextInt()
  var ans = 0
  for i in 0..<N:
    let a = nextInt()
    ans += s.lower_bound(a)
    s.insert(a)
  echo N * (N - 1) div 2 - ans
