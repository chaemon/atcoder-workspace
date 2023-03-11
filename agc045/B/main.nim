const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(S:string):
  proc to_non_negative(a:var int) =
    while a < 0: a += 2
  var ans = int.inf
  for parity in [0, 1]:
    var left, right:seq[tuple[odd, even:tuple[a, b:int]]]
    var left_M, right_M:seq[tuple[odd, even:int]]
    var odd, even: tuple[a, b:int]
    if parity == 0:
      odd = (1, 1)
      even = (0, 0)
    elif parity == 1:
      odd = (1, 0)
      even = (0, 1)
    else: assert false
    block:
      var (odd, even) = (odd, even)
      var odd_M, even_M = -int.inf
      left.add((odd, even))
      odd_M.max= odd.a + odd.b
      even_M.max= even.a + even.b
      left_M.add((odd_M, even_M))
      for i in 0..<S.len:
        case S[i]:
          of '0':
            odd.a.dec
            even.a.dec
            odd.b.inc
            even.b.inc
          of '1':
            odd.a.inc
            even.a.inc
            odd.b.dec
            even.b.dec
          of '?':
            odd.a.dec
            even.a.dec
            odd.b.dec
            even.b.dec
          else:
            assert false
        to_non_negative(odd.a)
        to_non_negative(odd.b)
        to_non_negative(even.a)
        to_non_negative(even.b)
        left.add((odd, even))
        odd_M.max= odd.a + odd.b
        even_M.max= even.a + even.b
        left_M.add((odd_M, even_M))
    block:
      var (odd, even) = (odd, even)
      var odd_M, even_M = -int.inf
      right.add((odd, even))
      odd_M.max= odd.a + odd.b
      even_M.max= even.a + even.b
      right_M.add((odd_M, even_M))
      for i in (0..<S.len) << 1:
        case S[i]:
          of '1':
            odd.a.dec
            even.a.dec
            odd.b.inc
            even.b.inc
          of '0':
            odd.a.inc
            even.a.inc
            odd.b.dec
            even.b.dec
          of '?':
            odd.a.dec
            even.a.dec
            odd.b.dec
            even.b.dec
          else:
            assert false
        to_non_negative(odd.a)
        to_non_negative(odd.b)
        to_non_negative(even.a)
        to_non_negative(even.b)
        right.add((odd, even))
        odd_M.max= odd.a + odd.b
        even_M.max= even.a + even.b
        right_M.add((odd_M, even_M))
      right.reverse
      right_M.reverse
    for i in 0..S.len:
      var M = -int.inf
      var ok = true
      if left[i].odd.a mod 2 == 0:
        if left[i].odd.a == 0:
          M.max=left_M[i].odd
        else:
          ok = false
      else:
        if left[i].even.a == 0:
          M.max=left_M[i].even
        else:
          ok = false
      if right[i].odd.a mod 2 == 0:
        if right[i].odd.a == 0:
          M.max=right_M[i].odd
        else:
          ok = false
      else:
        if right[i].even.a == 0:
          M.max=right_M[i].even
        else:
          ok = false
      if not ok: continue
      ans.min=M
  echo ans
  Naive:
    var ans0 = int.inf
    var v = Seq[int]
    for i in S.len:
      if S[i] == '?':
        v.add i
    for b in 2^v.len:
      var ans = -int.inf
      var S = S
      for i in 0..<v.len:
        if (b and (1 shl i)) != 0:
          S[v[i]] = '1'
        else:
          S[v[i]] = '0'
      for l in 0..<S.len:
        for r in l..<S.len:
          let s = S[l..r]
          ans.max=abs(s.count('0') - s.count('1'))
      ans0.min=ans
    echo ans0
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
  #test(S)
else:
  import random
  for ct in 10000:
    let N = 20
    var S:string
    for i in N:
      let r = random.rand(0..<3)
      if r == 0:
        S.add '0'
      elif r == 1:
        S.add '1'
      else:
        S.add '?'
    test(S)
