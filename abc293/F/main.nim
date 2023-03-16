when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils
import lib/other/binary_search

const B = 5

# Failed to predict input format
solveProc solve(N:int):
  # B桁より大きいものを数える
  ans := 0
  block:
    b := 2
    while true:
      var
        N = N
        ok = true
        ct = 0
      while N > 0:
        let d = N mod b
        if d >= 2: ok = false
        ct.inc
        N = N div b
      if ct <= B: break
      if ok:
        ans.inc
      b.inc
  # 1 ..< 2^Bについて2分探索
  # ２進数表記でtになる
  for t in 2^B:
    proc base(b:int):int =
      p := 1
      s := 0
      for i in B:
        if t[i] == 1:
          s = s +! p
        p = p *! b
      return s
    proc f(b:int):bool =
      return N <= base(b)
    let b = f.minLeft(2 .. N + 1)
    if base(b) == N:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let N = nextInt()
    solve(N)
else:
  discard

