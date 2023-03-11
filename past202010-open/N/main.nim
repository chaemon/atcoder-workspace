include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

const DEBUG = true

proc match(s:string, b:int):bool =
  for i in 0..<6:
    if s[i] == '?': continue
    elif s[i] == '0':
      if b[i]: return false
    elif s[i] == '1':
      if not b[i]: return false
    else: assert false
  return true

# Failed to predict input format
block main:
  let s = Seq[18: nextString()]
  const B = 2^6
  var dp = Seq[B*B: 0]
  for b in 0..<B:
    if match(s[0], b): dp[b] = 1
  for i in 1..<18:
    var dp2 = Seq[B*B: 0]
    for b in 0..<B:
      if not match(s[i], b): continue
      for bp in 0..<B:
        for bpp in 0..<B:
          valid := true
          for i in 0..<6:
            zero := 0
            one := 0
            for j in [i - 1, i, i + 1]:
              if j in 0..<6:
                if bp[j]: one.inc
                else: zero.inc
              else:
                zero.inc
            if bpp[i]: one.inc
            else: zero.inc
            if b[i]: one.inc
            else: zero.inc
            if bp[i]:
              if one <= 2: valid = false
            else:
              if zero <= 2: valid = false
          if not valid: continue
          dp2[bp * B + b] += dp[bpp * B + bp]
    swap(dp, dp2)
  ans := 0
  for b in 0..<B:
    for bp in 0..<B:
      valid := true
      for i in 0..<6:
        zero := 0
        one := 0
        for j in [i - 1, i, i + 1]:
          if j in 0..<6:
            if b[j]: one.inc
            else: zero.inc
          else:
            zero.inc
        if bp[i]: one.inc
        else: zero.inc
        zero.inc
        if b[i]:
          if one <= 2: valid = false
        else:
          if zero <= 2: valid = false
      if not valid: continue
      ans += dp[bp * B + b]
  echo ans
  discard

