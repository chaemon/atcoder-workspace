when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import random
import std/strutils
randomize()

import atcoder/modint
type mint = modint998244353

const N = 998244353
const M = 1000000007
const B = 29
doAssert N > 2^B and M > 2^B

# N, M > 2^B
# x in 0 ..< M^2
# つまりx < 2^(2 * B)
# 2^k > M^2なるkで m = 2^k / M > M
# 4 * B桁あれば大丈夫 4 * 4 * 3 = 48回くらい必要？
#
# 最後にrかr+Mか問題がある
# Mを引いて64bit目が立ってるかどうかで1 or 0にする関数を作る

# Failed to predict input format

# X, Y, Zは使わないように

solveProc solve():
  let tmp0 = "X"
  var ans: seq[seq[string]]
  proc separate(a:string, x:seq[string], n:int, r = n):seq[seq[string]] = # n桁ずつx個に分ける
    # aの下n桁をyに残りをxに格納
    let k = x.len
    doAssert n <= B and 0 < r and r <= n
    var d = 0 # 一番左の桁
    for i in k:
      #debug d, 64 - d - n
      var m = if i == 0: r else: n
      if 64 - d - m >= 0:
        result.add @["mul", tmp0, a, $(1u shl (64 - d - m))]
      else:
        result.add @["mul", tmp0, a, "1"]
        m = 64 - d
      result.add @["rem", tmp0, tmp0]
      let u = mint.init(1u shl (64 - m)).inv
      result.add @["mul", tmp0, tmp0, $(u.val)]
      result.add @["rem", x[i], tmp0]
      if i == k - 1: break
      result.add @["mul", tmp0, x[i], $((cast[uint](-1)) shl d)]
      result.add @["add", a, tmp0, a]
      if i == 0:
        d += r
      else:
        d += n
  #block debug:
  #  for n in 0 ..< 2^(3 * 4):
  #    var
  #      v = {"A": n.uint, tmp0: 0u}.toOrderedTable
  #      op = separate("A", @["D", "E", "F", "G"], 3)
  #    v = test(op, v)
  #    doAssert v["D"] + v["E"] * 2^3 + v["F"] * 2^6 + v["G"] * 2^9 == n
  ans.add @["mul", "A", "A", "B"]
  ans.add @["add", "C", "A", "0"]
  #var k = 0
  #while 2^k <= M^2: k.inc
  #let m = (2^k).floorDiv M
  var k = 90
  let m = 1237940030619800060
  debug m, k # k = 60
  ans.add @["add", "B", $m, "0"]

  #block:
  #  ans.add @["add", "U", "A", "0"]
  #  ans.add separate("U", @["P", "Q", "R"], B)

  ans.add separate("A", @["D", "E", "F"], B)
  #block:
  #  ans.add @["add", "U", "B", "0"]
  #  ans.add separate("U", @["S", "T"], B)

  ans.add separate("B", @["G", "H", "I"], B)
  var d = @["J", "K", "L", "M", "N"]
  for i, x in @["D", "E", "F"]:
    for j, y in @["G", "H", "I"]:
      ans.add @["mul", tmp0, x, y]
      ans.add @["add", d[i + j], d[i + j], tmp0]
  # @[J, K, L, M]を2^k桁で割る
  block:
    # J: 0  ..< 29?
    # K: 29 ..< 58?
    # L: 58 ..< 87?
    # M: 87 ..< 116?
    # N: 116 ..< 
    # ほしい桁は(k = 60) .. ^1
    # J, Kは大丈夫(たぶん)
    # Lについて
    ans.add separate("L", @["X", "Y", "Z"], B, 3) # 58..60, 61..<90, 90..
    ans.add @["add", "B", "Z", "0"]
    # Mについて
    ans.add separate("M", @["X", "Y", "Z"], B, 3) # 87..89, 90..
    ans.add @["add", "B", "Y", "B"]
    ans.add @["mul", "Z", "Z", $(2u^B)]
    ans.add @["add", "B", "Z", "B"]
    # Nについて
    ans.add @["mul", "N", "N", $(2u^26)]
    ans.add @["add", "B", "B", "N"]
  debug ans.len
  # v["B"]が(xm / 2^k)になっているはず
  ans.add @["mul", "B", "B", $(cast[uint](-M))]
  ans.add @["add", "C", "C", "B"]
  # v["C"]が0 ..< 2Mの範囲
  # BからMを引く
  block:
    proc test(op:seq[seq[string]], v:OrderedTable[string, uint]):OrderedTable[string, uint] =
      var v = v
      proc get(s:string):uint =
        if s.len == 1 and s[0] in 'A'..'Z':
          if s notin v: v[s] = 0u
          return v[s]
        else: return s.parseUInt()
      for p in op:
        if p[0] == "add":
          v[p[1]] = get(p[2]) + get(p[3])
        elif p[0] == "mul":
          v[p[1]] = get(p[2]) * get(p[3])
        elif p[0] == "rem":
          let u = get(p[2])
          v[p[1]] = u mod N.uint
      return v
    proc test(a, b:uint) =
      let x = a * b
      var v = {"A":a, "B":b}.toOrderedTable
      v = test(ans, v)
      doAssert x == v["D"] + v["E"] * 2u^B + v["F"] * 2u^(2*B)
      doAssert m.uint == v["G"] + v["H"] * 2u^B + v["I"] * 2u^(2*B)
      block:
        let t = v["C"]
        echo "t = ", t
        doAssert t == x mod M or t == x mod M + M
        doAssert t in 0u ..< M.uint
    test(458955091,894655231)
    for _ in 10000:
      let
        a = random.rand(0u ..< M.uint)
        b = random.rand(0u ..< M.uint)
      echo "a, b = ", a, " ", b
      test(a, b)

  debug ans.len
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

