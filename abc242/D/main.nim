const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

when not DO_TEST:
  let
    S = nextString()
    Q = nextInt()
  var
    v = newSeq[int]()
  for s in S:
    if s == 'A': v.add 0
    elif s == 'B': v.add 1
    elif s == 'C': v.add 2
    else: assert false
  proc calc(t, k:int):int =
    if t == 0: return v[k]
    var t = t
    if t >= 100:
      let
        r = t mod 3
        q = t div 3
      t -= (q - 33) * 3
    let i = calc(t - 1, k div 2)
    let r = k mod 2
    return (i + r + 1) mod 3
  for i in Q:
    var
      t = nextInt()
      k = nextInt() - 1
    let u = calc(t, k)
    if u == 0:
      echo "A"
    elif u == 1:
      echo "B"
    elif u == 2:
      echo "C"
    else: assert false
else:
  discard

