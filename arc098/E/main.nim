#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) == 255:
      break
    elif int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
proc infinity[T]():T =
  return (T(1) shl T(sizeof(T)*8-2))-1
#}}}

proc main():void =
  var
    N = nextInt()
    K = nextInt()
    Q = nextInt()
    A = newSeqWith(N,nextInt())
    ans = infinity[int]()
  for a in A:
    var
      v = newSeq[int]()
      w = newSeq[int]()
    for i in 0..N:
      if i == N or A[i] < a:
        if v.len >= K:
          v.sort(cmp[int])
          for j in 0..v.len - K:
            w.add(v[j])
        v = newSeq[int]()
      else:
        if i < N:
          v.add(A[i])
    w.sort(cmp[int])
    if len(w) >= Q:
      ans = min(abs(w[Q-1] - w[0]),ans)
  echo ans
  discard

main()

