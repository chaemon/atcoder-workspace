#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if (b and (B(1) shl B(n))) == 0: 0 else: 1)
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int = sizeof(B)) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#}}}

type Operator = enum
  AND = "AND"
  OR = "OR"
  XOR = "XOR"
  NOT = "NOT"

#{{{ main function
proc main() =
  let T = nextInt()
  if T == 1:
    let N, K = nextInt()
    ans := newSeq[(Operator, int, int)]()
    proc test(ans: seq[(Operator, int, int)], a:seq[bool]):bool =
      var a = a
      a.setLen(a.len + ans.len)
      for i,p in ans:
        var (ii,j,k) = (i+N,p[1],p[2])
        if p[0] == AND:
          a[ii] = a[j] and a[k]
        elif p[0] == OR:
          a[ii] = a[j] or a[k]
        elif p[0] == XOR:
          a[ii] = a[j] xor a[k]
        elif p[0] == NOT:
          a[ii] = not a[j]
        else:
          assert(false)
      return a[^1]
    proc test(ans: seq[(Operator, int, int)]):int =
      result = 0
      for b in 0..<(1 shl N):
        a := newSeq[bool](N)
        for i in 0..<N:
          a[i] = if b[i] == 1: true else: false
        if test(ans, a): result += 1
#    P := ((1 shl N) - K) xor 1
    P := (1 shl N) - K
    N2 := N
    while P mod 2 == 0: N2 -= 1;P = P div 2
    prev := 0
    for i in 1..<N2:
      if P[i] == 0:
        ans.add((OR, i, prev))
      else:
        ans.add((AND, i, prev))
      prev = ans.len - 1 + N
#    echo ans
#    echo test(ans)
    echo ans.len
    for i in 0..<ans.len:
      echo ans[i][0], " ", ans[i][1] + 1, " ", ans[i][2] + 1
  else:
    echo "Hello World!!"
  return

main()
#}}}
