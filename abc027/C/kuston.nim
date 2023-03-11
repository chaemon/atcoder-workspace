{.checks:off.}

include lib/header/chaemon_header

import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL

import macros;macro ImportExpand(s:untyped):untyped = parseStmt($s[2])
import std/strutils
import std/bitops
import std/sequtils
import std/sets
import std/algorithm
import std/heapqueue
import std/deques
import std/tables
import std/math

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/forward_compatibility/hash_func.nim
ImportExpand "atcoder/extra/forward_compatibility/hash_func.nim" <=== "when not declared ATCODER_HASH_FUNC_HPP:\n  const ATCODER_HASH_FUNC_HPP* = 1\n  import hashes\n\n  proc hash*(a:int):Hash {.inline.} = \n    proc hiXorLoFallback64(a, b: uint64): uint64 {.inline.} =\n      let # Fall back in 64-bit arithmetic\n        aH = a shr 32\n        aL = a and 0xFFFFFFFF'u64\n        bH = b shr 32\n        bL = b and 0xFFFFFFFF'u64\n        rHH = aH * bH\n        rHL = aH * bL\n        rLH = aL * bH\n        rLL = aL * bL\n        t = rLL + (rHL shl 32)\n      var c = if t < rLL: 1'u64 else: 0'u64\n      let lo = t + (rLH shl 32)\n      c += (if lo < t: 1'u64 else: 0'u64)\n      let hi = rHH + (rHL shr 32) + (rLH shr 32) + c\n      return hi xor lo\n    proc hiXorLo(a, b: uint64): uint64 {.inline.} =\n      # XOR of the high & low 8 bytes of the full 16 byte product.\n      when nimvm:\n        result = hiXorLoFallback64(a, b) # `result =` is necessary here.\n      else:\n        when Hash.sizeof < 8:\n          result = hiXorLoFallback64(a, b)\n        elif defined(gcc) or defined(llvm_gcc) or defined(clang):\n          {.emit: \"\"\"__uint128_t r = `a`; r *= `b`; `result` = (r >> 64) ^ r;\"\"\".}\n        elif defined(windows) and not defined(tcc):\n          proc umul128(a, b: uint64, c: ptr uint64): uint64 {.importc: \"_umul128\", header: \"intrin.h\".}\n          var b = b\n          let c = umul128(a, b, addr b)\n          result = c xor b\n        else:\n          result = hiXorLoFallback64(a, b)\n    proc hashWangYi1(x: int64|uint64|Hash): Hash {.inline.} =\n      ## Wang Yi's hash_v1 for 64-bit ints (see https://github.com/rurban/smhasher for\n      ## more details). This passed all scrambling tests in Spring 2019 and is simple.\n      ##\n      ## **Note:** It's ok to define `proc(x: int16): Hash = hashWangYi1(Hash(x))`.\n      const P0  = 0xa0761d6478bd642f'u64\n      const P1  = 0xe7037ed1a0b428db'u64\n      const P58 = 0xeb44accab455d165'u64 xor 8'u64\n      template h(x): untyped = hiXorLo(hiXorLo(P0, uint64(x) xor P1), P58)\n      when nimvm:\n        when defined(js): # Nim int64<->JS Number & VM match => JS gets 32-bit hash\n          result = cast[Hash](h(x)) and cast[Hash](0xFFFFFFFF)\n        else:\n          result = cast[Hash](h(x))\n      else:\n        when defined(js):\n          if hasJsBigInt():\n            result = hashWangYiJS(big(x))\n          else:\n            result = cast[Hash](x) and cast[Hash](0xFFFFFFFF)\n        else:\n          result = cast[Hash](h(x))\n    hashWangYi1(a)\n  discard\n"

import lib/other/bitutils

#####################################################
proc newSeq2d[T](h:int, w:int, init:T): seq[seq[T]] = newSeqWith(h, newSeqWith(w, init))
proc newSeq3d[T](x:int, y:int, z:int, init:T): seq[seq[seq[T]]] = newSeqWith(x, newSeqWith(y, newSeqWith(z, init)))

proc chmin[T](a:var T, b:T)=
  if b < a:
    a = b
proc chmax[T](a:var T, b:T)=
  if b > a:
    a = b

proc toOut[T](x:T): string = $x
proc toOut(b:bool): string =
  if b: 
    "Yes"
  else: 
    "No"
proc toOutLn[T](s:seq[T]):string = s.map(toOut).join(" ")
proc toOutCl[T](s:seq[T]):string = s.map(toOut).join("\n")
 
#####################################################

solveProc solve(N:int):
  let l = N.firstSetBit

  let ft = if l mod 2 == 0:
    (x:int) => 2 * x
  else:
    (x:int) => 2 * x + 1
  
  let fa = if l mod 2 == 0:
    (x:int) => 2 * x + 1
  else:
    (x:int) => 2 * x

  var x = 1
  var taka = true
  while x <= N:
    if taka:
      x = ft(x)
    else:
      x = fa(x)
    taka = not taka
  
  if taka:
    echo "Takahashi"
  else:
    echo "Aoki"
  Naive:
    var t:int
    proc calc(N2, i:int):int =
      if i == -1:
        return 0
      result = 0
      var rest: int
      if N[i] == 0:
        # set to 0
        if calc(N2 * 2, i - 1) == 0:
          return 1
        # set to 1
        rest = i - 1
        if rest mod 2 == 0:
          return 1
      else:
        # set to 0
        rest = i
        if rest mod 2 == 0:
          return 1
        # set to 1
        if calc(N2 * 2 + 1, i - 1) == 0:
          return 1
      return 0
    for i in countdown(62, 0):
      if N[i] == 1: t = i;break
    if calc(1, t - 1) == 0:
      echo "Aoki"
    else:
      echo "Takahashi"

for N in 1 .. 1000:
  test(N)

