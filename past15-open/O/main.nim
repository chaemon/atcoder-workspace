when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/math
import lib/math/eratosthenes

solveProc solve(N:int, A:int, B:int):
  var
    a = Seq[N: true]
    es = initEratosthenes()
    i = 0
  for p in es.enumPrime(10^6):
    # pで割り切れるものを
    # A * i + B ≡0 (mod p)
    # A * i ≡-B
    var (A, B) = (A, B)
    if A mod p == 0:
      if B mod p != 0:
        continue
      else:
        if B == p:
          echo 1
        else:
          echo 0
        return
    else:
      let r = ((-B).floorMod(p) * invMod(A, p)) mod p
      for i in countup(r, N - 1, p):
        if A * i + B == p: continue
        a[i] = false
  echo a.count(true)
  discard


when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  discard

