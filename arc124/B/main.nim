const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

solveProc solve(N:int, a:seq[int], b:seq[int]):
  var ans = Seq[int]
  for i in 0..<N:
    let x = a[0] xor b[i]
    var v = initTable[int, int]()
    for j in 0..<N:
      let t = a[j] xor x
      if t notin v: v[t] = 0
      v[t].inc
    var valid = true
    for j in 0..<N:
      if b[j] notin v:
        valid = false
        break
      else:
        v[b[j]].dec
      if v[b[j]] == 0: v.del(b[j])
    if valid: ans.add x
  ans.sort
  ans = ans.deduplicate(true)
  echo ans.len
  if ans.len > 0:
    echo ans.join("\n")
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  solve(N, a, b)

