when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

var d = initTable[(int, int, seq[int]), bool]()

solveProc solve(N:int, M:int, A:seq[int]):
  var a = uint.inf
  var ct = initTable[int, int]()
  for a in A:
    ct[a].inc
  if M mod 2 == 0:
    let M2 = M div 2
    for k in A:
      let k2 = (k + M2) mod M
      if k2 notin ct: ct[k2] = 0
    s := 0
    for k, v in ct:
      let k2 = (k + M2) mod M
      if k2 < k: continue
      var v2 = if k2 in ct: ct[k2] else: 0
      let m = min(v, v2)
      s += m
      block:
        var
          v = v - m
          v2 = v2 - m
        if v mod 2 == 1 or v2 mod 2 == 1:
          echo "Alice";return
    if s mod 2 == 1:
      echo "Alice"
    else:
      echo "Bob"
  else:
    for k, v in ct:
      if v mod 2 != 0:
        echo "Alice";return
    echo "Bob"
  Naive:
    proc calc(a, b:int, A:seq[int]):bool =
      if (a, b, A) in d: return d[(a, b, A)]
      if A.len == 0:
        if a == b: result = false
        else: result = true
      elif A.len mod 2 == 0:
        result = false
        for i in A.len:
          let a2 = (a + A[i]) mod M
          var A = A
          A.delete(i)
          if not calc(a2, b, A): result = true
      else:
        result = false
        for i in A.len:
          let b2 = (b + A[i]) mod M
          var A = A
          A.delete(i)
          if not calc(a, b2, A): result = true
      d[(a, b, A)] = result
    if calc(0, 0, A):
      echo "Alice"
    else:
      echo "Bob"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(2*N, nextInt())
  solve(N, M, A)
else:
  for M in 2..8:
    debug M
    d = initTable[(int, int, seq[int]), bool]()
    for a in 0 ..< M:
      for b in 0 ..< M:
        for c in 0 ..< M:
          for d in 0 ..< M:
            for e in 0 ..< M:
              for f in 0 ..< M:
                let A = @[a, b, c, d, e, f]
                test(3, M, A)

  discard

