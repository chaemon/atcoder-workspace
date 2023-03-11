#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

{.checks:off, hints:off}

#{{{ bitutils
proc bits(v:varargs[int]): int =
  result = 0
  for x in v: result = (result or (1 shl x))
proc `[]`(b:int,n:int):int =
  if (b and (1 shl n)) == 0: 0 else: 1
proc test(b:int,n:int):bool =
  if b[n] == 1:true else: false
proc set(b:var int,n:int) = b = (b or (1 shl n))
proc unset(b:var int,n:int) = b = (b and (not (1 shl n)))
proc write_bits(b:int,n:int = 64) =
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
#}}}

#{{{ gauss (bit_matrix)
proc gauss(v:seq[int],n:int):seq[int] =
  var
    v = v
    p = 0
  for i in countdown(n-1,0):
    var found = false
    for j in p..<v.len:
      if v[j].test(i):
        swap(v[p],v[j])
        found = true
        break
    if not found: continue
    for j in 0..<v.len:
      if j == p: continue
      if v[j].test(i): v[j] = (v[j] xor v[p])
    p += 1
  v.setlen(p)
  return v
#}}}

proc main():void =
  let
    N = nextInt()
    A = newSeqWith(N,nextInt())
    B = newSeqWith(N,nextInt())
    T = 60
  let
    gA = gauss(A,T)
    gB = gauss(B,T)
  echo if gA == gB: "Yes" else: "No"

main()

