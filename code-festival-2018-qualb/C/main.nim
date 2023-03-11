#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if int(c) > int(' '):
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")
#}}}

let dir = [[0, -1], [-1, 0], [0, 1], [1, 0]]

var N:int

#{{{ input part
proc main()
block:
  N = nextInt()
#}}}

proc main() =
  ans := newSeqWith(N, ".".repeat(N))
  for x in 0..<N:
    for y in 0..<N:
      if (2 * x + y) mod 5 == 0: ans[x][y] = 'X'
  block:
    let x = -1
    for y in 0..<N:
      if (2 * x + y) mod 5 == 0: ans[x + 1][y] = 'X'
  block:
    let x = N
    for y in 0..<N:
      if (2 * x + y) mod 5 == 0: ans[x - 1][y] = 'X'
  block:
    let y = -1
    for x in 0..<N:
      if (2 * x + y) mod 5 == 0: ans[x][y + 1] = 'X'
  block:
    let y = N
    for x in 0..<N:
      if (2 * x + y) mod 5 == 0: ans[x][y - 1] = 'X'
  print ans.join("\n")
  print "\n"
  return

# multisolution {{{
import streams

const CHECK = false

when CHECK:
  var output = newStringStream()
  print = proc(x: varargs[string,toStr]) = output.write(print0(@x,sep = " "))
  proc check() =
    output.flush()
    output.setPosition(0)
    # write check code
    ans := newSeqWith(N, output.nextString())
    for x in 0..<N:
      for y in 0..<N:
        if ans[x][y] == 'X': continue
        flag := false
        for d in dir:
          let x2 = x + d[0]
          let y2 = y + d[1]
          if not (0 <= x2 and x2 < N and 0 <= y2 and y2 < N): continue
          if ans[x2][y2] == 'X': flag = true
        assert(flag)
    stdout.write "Check passed!!"
  main()
  check()
else:
  main()
# }}}
