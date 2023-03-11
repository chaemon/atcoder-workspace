include lib/header/chaemon_header

const YES = "YES"
const NO = "NO"
var N:int
var D:seq[int]
var M:int
var T:seq[int]

import lib/structure/set_map

# input part {{{
proc main()
block:
  N = nextInt()
  D = newSeqWith(N, nextInt())
  M = nextInt()
  T = newSeqWith(M, nextInt())
#}}}

proc main() =
  var a = initSortedMap(int, int)
  for i in 0..<N:a[D[i]].inc
  for i in 0..<M:
    if T[i] notin a:
      echo NO
      return
    else:
      a[T[i]].dec
      if a[T[i]] == 0: a.erase(T[i])
  echo YES
  return

main()

