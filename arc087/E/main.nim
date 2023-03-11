include atcoder/extra/header/chaemon_header
import bitops

type Node = ref object
  next:array[2, Node]

proc solve(N:int, L:int, s:seq[string]) =
  var root = Node()
  for s in s:
    var p = root
    for d in s:
      var d = d.ord - '0'.ord
      if p.next[d] == nil:
        p.next[d] = Node()
      p = p.next[d]
  var v = newSeqWith(min(10^5 + 10, L + 1), 0)
  proc dfs(p:Node, level:int) =
    if p.next[0] == nil and p.next[1] != nil:
      v[level].inc
    elif p.next[0] != nil and p.next[1] == nil:
      v[level].inc
    for d in 0..1:
      if p.next[d] != nil: dfs(p.next[d], level + 1)
  dfs(root, 0)
  var ans = 0
  for i in 0..<v.len:
    if i >= L: break
    if v[i] mod 2 == 0: continue
    ans = ans xor (1 shl countTrailingZeroBits(L - i))
  echo if ans != 0:
      "Alice"
    else:
      "Bob"
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var L = 0
  L = nextInt()
  var s = newSeqWith(N, "")
  for i in 0..<N:
    s[i] = nextString()
  solve(N, L, s);
  return

main()
#}}}
