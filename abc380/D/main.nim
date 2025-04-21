when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

proc calc(i, b:int):int =
  if b == 1:
    return 0
  let b2 = b shr 1
  if i < b2:
    return calc(i, b2)
  else:
    return 1 xor calc(i - b2, b2)
  

proc calc(i:int):int =
  var b = 1
  while not (i < b): b.shl= 1
  return calc(i, b)

proc flip(c:char):char =
  if c in 'a' .. 'z':
    return 'A' + (c - 'a')
  elif c in 'A' .. 'Z':
    return 'a' + (c - 'A')
  else:
    doAssert false

solveProc solve(S:string, Q:int, K:seq[int]):
  Pred K
  var
    ans:seq[char]
  for q in Q:
    let K = K[q]
    var
      r = K mod S.len
      u = calc(K div S.len)
    if u == 0:
      ans.add S[r]
    else:
      ans.add flip(S[r])
  echo ans.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var S = nextString()
  var Q = nextInt()
  var K = newSeqWith(Q, nextInt())
  solve(S, Q, K)
else:
  discard

