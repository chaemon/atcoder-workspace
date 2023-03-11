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
  stdout.flushFile()

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")
# }}}

var N:int

proc main()

# Interactive {{{
import deques
const CHECK = true

when CHECK:
  type Interactive = object
    ans: string
    time, limit: int
#  var interactive = Interactive(ans: "RRBBRB", time: 0, limit: 210)
  var interactive = Interactive(ans: "RBBRBRBRBRRBBR", time: 0, limit: 210)
  N = interactive.ans.len div 2

  import streams
  
#  var output = newStringStream()
  var output = initDeque[string]()
  print = proc(x: varargs[string,toStr]) = output.addLast(print0(@x,sep = " "))

  proc ask(self: var Interactive):string = 
    self.time += 1
    var s = output.popFirst().strip()
    stderr.write "time: ", self.time, "\n query: ", s, "\n"
    if self.time > self.limit: 
      stderr.write "too many query!!"
      assert(false)
    v := s[2..^1].split(" ").mapIt(it.parseInt - 1)
    var
      R = 0
      B = 0
    for i in v:
      if self.ans[i] == 'R': R += 1
      else: B += 1
    if R > B: result = "Red"
    else: result = "Blue"
    stderr.write "                    ", result, "\n"
  proc judge(self: var Interactive) =
    let s = output.popFirst().strip()
    stderr.write "judge: ", s, "\n"
    assert(s[2..^1] == interactive.ans)

proc ask(v:seq[int]):int =
  print "?", v.mapIt($(it + 1)).join(" ")
  let T = when CHECK: interactive.ask() else: nextString()
  if T == "Red": return 0
  elif T == "Blue": return 1

proc judge(s:string) =
  print "!", s
  when CHECK:
    interactive.judge()
# }}}

main()

proc main():void =
  if CHECK:
    discard
  else:
    N = nextInt()
  var
    rs = newSeq[int]()
    bs = newSeq[int]()
  for i in 0..<N: rs.add(i)
  for i in 0..<N: bs.add(i + N)
  if ask(rs) == 1: swap(rs, bs)
  # 0 is false
  proc test_i(i:int): bool =
    for j in 0..<i:
      swap(rs[j], bs[j])
    if ask(rs) == 0: result = false
    else: result = true
    for j in 0..<i:
      swap(rs[j], bs[j])
  var idx = -1
  var
    (l, r) = (0, N)
  while r - l > 1:
    var m = (l + r) div 2
    if test_i(m): r = m
    else: l = m
  idx = r - 1
  for i in 0..<r:
    swap(rs[i], bs[i])
  # rs: "blue" is majority
  # bs: "red" is majority
  # rs[i]: blue
  # bs[i]: red
  var ans = newSeqWith(N*2, -1)
  # foreach bs
  for i in 0..<N:
    swap(rs[idx], bs[i])
    if ask(rs) == 0:# red
      ans[rs[idx]] = 0
    else:
      ans[rs[idx]] = 1
    swap(rs[idx], bs[i])
  # foreach rs
  for i in 0..<N:
    swap(bs[idx], rs[i])
    if ask(bs) == 0:# red
      ans[bs[idx]] = 0
    else:
      ans[bs[idx]] = 1
  let s = ans.mapIt(if it == 0: "R" else: "B").join()
  judge(s)
