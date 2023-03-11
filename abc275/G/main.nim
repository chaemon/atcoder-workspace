when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
#include lib/math/longdouble
import lib/math/longdouble
#echo machineEpsilonFloat128()
#import lib/other/decimal_mpfr
import lib/other/binary_search_float
import lib/other/floatutils
import lib/other/static_var

#static:
#  doAssert float32 isnot float
#  doAssert float64 is float
#  doAssert float128 isnot float

#echo float32$.eps
#echo float$.eps
#echo float64$.eps
#echo float128$.eps

type Float = float128

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int]):
  proc f(s:Float):bool =
    # l: x + y = sを考える
    var 
      xmin = Float(0)
      xmax = s
    for i in N:
      # A[i] * x + B[i] * y = C[i]とlの交点
      # A[i] * x + B[i] * (s - x) = C[i]とlの交点
      if not (A[i] == B[i]):
      #if A[i] != B[i]: #TODO: こうするとなぜかだめ
        let x = (Float(C[i]) - s * Float(B[i])) / Float(A[i] - B[i])
        if A[i] < B[i]: # 傾きが1より小さい
          xmax.min= x
        else:
          xmin.max= x
      else:
        let k = Float(C[i]) / Float(A[i])
        if s < k: return false
    return xmin <= xmax
  let ans = f.minLeft(Float(0) .. Float(10)^20)
  #echo ans.toStr(20)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, A, B, C)
else:
  discard

