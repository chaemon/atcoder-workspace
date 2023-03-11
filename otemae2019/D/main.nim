#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
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

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}

const MOD = 1_000_000_007

#{{{ Mint
type Mint = object
  v:int
proc newMint[T](a:T):Mint =
  var a = a
  a = a mod MOD
  if a < 0: a += MOD
  return Mint(v:a)
proc convert[T](self:Mint, a:T):Mint = newMint(a)
proc newMint(a:Mint):Mint =
  return a
proc `+=`[T](a:var Mint, b:T):void =
  a.v += newMint(b).v
  if a.v >= MOD:
    a.v -= MOD
proc `+`[T](a:Mint,b:T):Mint =
  var c = a
  c += b
  return c
proc `*=`[T](a:var Mint,b:T):void =
  a.v *= newMint(b).v
  a.v = a.v mod MOD
proc `*`[T](a:Mint,b:T):Mint =
  var c = a
  c *= b
  return c
proc `-`(a:Mint):Mint =
  if a.v == 0: return a
  else: return Mint(v:MOD - a.v)
proc `-=`[T](a:var Mint,b:T):void =
  a.v -= newMint(b).v
  if a.v < 0:
    a.v += MOD
proc `-`[T](a:Mint,b:T):Mint =
  var c = a
  c -= b
  return c
proc `$`(a:Mint):string =
  return $(a.v)
proc pow(x:Mint, n:int):Mint =
  var (x,n) = (x,n)
  result = newMint(1)
  while n > 0:
    if (n and 1) > 0: result *= x
    x *= x
    n = (n shr 1)
proc extGcd(a,b:int, x,y:var int):int =
  var g = a
  x = 1
  y = 0
  if b != 0:
    g = extGcd(b, a mod b, y, x)
    y -= (a div b) * x
  return g;
proc invMod(a,m:int):int =
  var
    x,y:int
  if extGcd(a, m, x, y) == 1: return (x + m) mod m
  else: return 0 # unsolvable
proc `/=`[T](a:var Mint,b:T):void =
  a.v *= invMod(newMint(b).v,MOD)
  a.v = a.v mod MOD
proc `/`[T](a:Mint,b:T):Mint =
  var c = a
  c /= b
  return c
#}}}

proc solve(N:int, M:int, S:seq[string]) =
  var dp = newSeqWith(N+1, newSeqWith(M+1, newSeqWith(3, newMint(0))))
  dp[0][0][0] = newMint(1)
  for i in 0..<N:
    let sd = if i == 0: 1 else: 0
    for j in 0..M:
      for s in 0..2:
        for d in sd..9:
          let s2 = (s + d) mod 3
          var str = ""
          if s2 == 0: str &= "Fizz"
          if d == 0 or d == 5: str &= "Buzz"
          if str == "":
            dp[i+1][j][s2] += dp[i][j][s]
          else:
            if j < M and S[j] == str: dp[i+1][j+1][s2] += dp[i][j][s]
  var ans = newMint(0)
  for s in 0..2: ans += dp[N][M][s]
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var S = newSeqWith(M, "")
  for i in 0..<M:
    S[i] = nextString()
  solve(N, M, S);
  return

main()
#}}}
