include atcoder/extra/header/chaemon_header

const MOD = 998244353
var S:string

# input part {{{
proc main()
block:
  S = nextString()
#}}}

import atcoder/modint
type mint = modint998244353

# default-table {{{
import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, B.default)
  tables.`[]`(self, key)
#}}}

const B = 303

var dp = Array(B, B, B, false) # index, num-zero, num-one

proc test(n, a, b:int):bool =
  var (a, b) = (a, b)
  var rem = Seq(n, false)
  for i in countdown(n - 1, 0):
    if S[i] == '0':
      if a > 0:
        rem[i] = true
        a.dec
    else:
      if b > 0:
        rem[i] = true
        b.dec
  if a > 0 or b > 0: return false
#  echo rem
  var
    i = 0
    reserve = 0
  while i < rem.len:
    if rem[i]:
      if reserve > 0:
        i.inc
        reserve.dec
      else:
        if i + 1 < rem.len and not rem[i]:
          i += 2
        else:
          return false
    else:
      if i + 1 < rem.len:
        if rem[i + 1]:
          i += 2
        else:
          reserve.inc
          i += 2
      else:
        discard
      i.inc
  return true

proc add_first(s:seq[string], c:char):seq[string] = 
  for s in s:
    result.add(c & s)

const DEBUG = false

proc naive() =
  var
    l = S.len
    s = toHashSet([S])
  while true:
    echo s
    if l <= 1: break
    l.dec
    var s2 = initSet[string]()
    for S in s:
      let t = S[0..<2]
      let u = S[2..<S.len]
      for t in t:
        for i in 0..u.len:
          let u2 = u[0..<i] & t & u[i..<u.len]
          s2.incl(u2)
    s.swap(s2)


proc main() =
#  naive()
  let
    n = S.len
    zeros = S.count('0')
    ones = S.count('1')
  dp[0][0][0] = true
  for i in 0..n:
    for a in countdown(n, 0):
      for b in countdown(n, 0):
        if not dp[i][a][b]: continue
#        echo "found: ", i, " ", a, " ", b
        if i == n: continue
        # not use prev
        if i + 1 < n:
          if S[i] == '0':
            dp[i + 2][a + 1][b] = true
          else:
            dp[i + 2][a][b + 1] = true
          if S[i + 1] == '0':
            dp[i + 2][a + 1][b] = true
          else:
            dp[i + 2][a][b + 1] = true
        # use one prev
        if a + b > 0:
          if a > 0:
            if S[i] == '0':
              dp[i + 1][a][b] = true
            else:
              dp[i + 1][a - 1][b + 1] = true
            dp[i + 1][a][b] = true
          if b > 0:
            if S[i] == '1':
              dp[i + 1][a][b] = true
            else:
              dp[i + 1][a + 1][b - 1] = true
            dp[i + 1][a][b] = true
        # use two prev
        if a + b >= 2:
          if a > 0: dp[i][a - 1][b] = true
          if b > 0: dp[i][a][b - 1] = true

  when DEBUG:
    var tb_deb = initTable[tuple[n,a,b:int], seq[string]]()
  var tb = initTable[tuple[n,a,b:int], mint]()
  tb[(n, 0, 0)] += 1
  when DEBUG:
    tb_deb[(n, 0, 0)] = @[""]
  var ans = mint(0)
  while true:
    if tb.len == 0: break
    var tb2 = initTable[tuple[n,a,b:int], mint]()
    when DEBUG:
      var tb_deb2 = initTable[tuple[n,a,b:int], seq[string]]()
    for p,m in tb:
      let (n, a, b) = p
#      if test(n, a, b):
      if dp[n][a][b]:
        when DEBUG:
          echo "found: ", n, " ", a, " ", b, " ", m
          echo tb_deb[(n, a, b)]
          echo ""
        ans += m
      if S[0..<n].count('0') < a or S[0..<n].count('1') < b: continue
      let i = n - 1
      # 0
      if i >= 0 and S[i] == '0':
        tb2[(n - 1, a, b)] += m
        when DEBUG:
          tb_deb2[(n - 1, a, b)] &= tb_deb[(n, a, b)].addFirst('0')
      else:
        tb2[(n, a + 1, b)] += m
        when DEBUG:
          tb_deb2[(n, a + 1, b)] &= tb_deb[(n, a, b)].addFirst('0')
      # 1
      if i >= 0 and S[i] == '1':
        tb2[(n - 1, a, b)] += m
        when DEBUG:
          tb_deb2[(n - 1, a, b)] &= tb_deb[(n, a, b)].addFirst('1')
      else:
        tb2[(n, a, b + 1)] += m
        when DEBUG:
          tb_deb2[(n, a, b + 1)] &= tb_deb[(n, a, b)].addFirst('1')
    swap(tb, tb2)
    when DEBUG:
      swap(tb_deb, tb_deb2)
  echo ans
  return

main()
