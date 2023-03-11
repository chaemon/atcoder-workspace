#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ sieve_of_eratosthenes
var pdiv = newSeq[int]()

proc sieve_of_eratosthenes(n:int) =
  pdiv.setLen(n)
  for i in 2..<n:
    pdiv[i] = i;
  for i in 2..<n:
    if i * i >= n: break
    if pdiv[i] == i:
      for j in countup(i*i,n-1,i):
        pdiv[j] = i;

proc is_prime(n:int): bool =
  return n!=1 and pdiv[n] == n
#}}}

var dp = newSeqWith(1000010,-1)

proc calc(n:int):int =
  if dp[n]>=0: return dp[n]
  if n == 0:
    dp[n] = 0
    return 0
  var a = newSeq[int]()
  for t in [2,n-2]:
    if t > 0 and is_prime(t) and n - t >= 0 and (is_prime(n-t) or n - t == 0):
      a.add(calc(n-t))
  var c = 0
  while true:
    if c notin a:
      dp[n] = c
      return c
    c += 1

proc solve(N:int, X:seq[int]) =
  sieve_of_eratosthenes(1000000+1)
  var ret = 0
  for x in X:
    ret = ret xor calc(x)
  if ret == 0:
    echo "Ai"
  else:
    echo "An"
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
  solve(N, X);
  return

main()
#}}}
