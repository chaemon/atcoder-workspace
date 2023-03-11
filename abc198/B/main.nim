include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(N:string) =
  proc isPalindrome(S:string):bool =
#    let Srev = reversed(S).join("")
#    return S == Srev
    for i in 0..<S.len:
      let j = S.len - 1 - i
      if S[i] != S[j]: return false
    return true
  for i in 0..<20:
    let s:string = '0'.repeat(i) & N
    if isPalindrome(s):echo YES;return
  echo NO
  return

# input part {{{
block:
  var N = nextInt()
  solve(N.toStr)
#}}}

