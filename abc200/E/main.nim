const DO_CHECK = true
const DEBUG = true

include atcoder/extra/header/chaemon_header
import lib/structure/set_map

sum(n:int) => n * (n + 1) div 2
sum(a, b:int) => (a + b) * (b - a + 1) div 2

proc solve(N:int, K:int) =
  proc calc(s:int):int =
    if s <= N - 1:
      # a = 0 .. s
      # b = 0 .. s - a
      # c = s - a - b
      return (s + 1)^2 - sum(s)
    elif s <= (N - 1) * 2:
      # a = 0 .. N - 1
      # b = s - (N - 1) - a .. N - 1 (a <= s - (N - 1))
      # b = 0 .. s - a (a > s - (N - 1))
      # c = s - a - b
      return (2 * (N - 1) - s + 1) * (s - (N - 1) + 1) + sum(s - (N - 1)) +
          (s + 1) * (2 * (N - 1) - s) - (s + 1) * (2 * (N - 1) - s) div 2
    elif s <= (N - 1) * 3:
      # a = s - (N - 1) * 2 .. N - 1
      # b = s - (N - 1) - a .. N - 1
      # c = s - a - b
      return (2 * (N - 1) - s + 1) * ((N - 1) * 3 - s + 1) + sum(s - (N - 1) * 2, N - 1)
    else:
      assert false
    return 0
  proc calc_a(s, a:int):int =
    if s <= N - 1:
      # a = 0 .. s
      # b = 0 .. s - a
      # c = s - a - b
      assert a in 0 .. s
      return s - a + 1
    elif s <= (N - 1) * 2:
      # a = 0 .. N - 1
      # b = s - (N - 1) - a .. N - 1 (a <= s - (N - 1))
      # b = 0 .. s - a (a > s - (N - 1))
      # c = s - a - b
      assert a in 0 .. N - 1
      if a <= s - (N - 1):
        return (N - 1) - (s - (N - 1) - a) + 1
      else:
        return s - a + 1
    elif s <= (N - 1) * 3:
      # a = s - (N - 1) * 2 .. N - 1
      # b = s - (N - 1) - a .. N - 1
      # c = s - a - b
      return (N - 1) - (s - (N - 1) - a) + 1
    else:
      assert false
    return 0

  var K = K - 1
  for s in 0..(N - 1) * 3:
    let d = calc(s)
    if K < d:
      if s <= N - 1:
        for a in 0 .. s:
          let d = calc_a(s, a)
          if K < d:
            let
              b = K
              c = s - a - b
            echo a + 1, " ", b + 1, " ", c + 1; return
          else:
            K -= d
      elif s <= (N - 1) * 2:
        for a in 0 .. N - 1:
          let d = calc_a(s, a)
          if K < d:
            var b:int
            if a <= s - (N - 1):
              b = K + s - (N - 1) - a
            else:
              b = K
            let c = s - a - b
            echo a + 1, " ", b + 1, " ", c + 1; return
          else:
            K -= d
      else:
        for a in s - (N - 1) * 2 .. N - 1:
          let d = calc_a(s, a)
          if K < d:
            let b = K + s - (N - 1) - a
            let c = s - a - b
            echo a + 1, " ", b + 1, " ", c + 1; return
          else:
            K -= d
    else:
      K -= d
  assert false

  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

