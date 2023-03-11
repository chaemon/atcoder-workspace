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
template inf(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

block main:
  let
    N, P = nextInt()
    S = nextString()

  if P == 2 or P == 5:
    var ans = 0
    for i,s in S:
      let d = S[i].ord - '0'.ord
      if d mod P == 0:
        ans += i + 1
    echo ans
  else:
    var
      tb = initTable[int,int]()
      r = 0
      p = 1
      ans = 0
    tb[0] = 1
    for i in countdown(S.len - 1, 0):
      let d = S[i].ord - '0'.ord
      r += d * p
      r = r mod P
      ans += tb[r]
      tb[r] += 1
      p *= 10
      p = p mod P
    echo ans
  discard

