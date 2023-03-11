#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
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
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

type
  Concept_newSeqWith = concept x
    newSeqWith(0, x)

template SeqImpl(lens: seq[int]; init: typedesc or Concept_newSeqWith; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init: typedesc or Concept_newSeqWith): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: static varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template Array(lens: static varargs[int]; init: typedesc): auto =
  ArrayImpl(@lens, init, 1, lens.len).default
#}}}

let d = [
".###..#..###.###.#.#.###.###.###.###.###.",
".#.#.##....#...#.#.#.#...#.....#.#.#.#.#.",
".#.#..#..###.###.###.###.###...#.###.###.",
".#.#..#..#.....#...#...#.#.#...#.#.#...#.",
".###.###.###.###...#.###.###...#.###.###."]


var N:int
var s:seq[string]

#{{{ input part
proc main()
block:
  N = nextInt()
  s = newSeqWith(5, nextString())
#}}}

proc find_dig(s:array[5, string]):int =
  for t in 0..<10:
    valid := true
    for i in 0..<5:
      if d[i][t * 4 + 1..t * 4 + 3] != s[i]: valid = false
    if valid: return t
  doAssert(false)

proc main() =
  var ct = 0
  var i = 1
  while ct < N:
    t := Array([5], string)
    for j in 0..<5:
      t[j] = s[j][i..i+2]
    var d = find_dig(t)
    stdout.write(d)
    i += 4
    ct.inc
  echo ""
  return

main()
