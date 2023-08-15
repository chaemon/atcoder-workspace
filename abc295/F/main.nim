when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

const DO_TEST = false

include lib/header/chaemon_header

proc toDigit(R:int):seq[int] =
  R := R
  while R > 0:
    result.add R mod 10
    R.div=10
  result.reverse

proc toInt(a:seq[int]):int =
  # aのsの部分だけ取り出す
  result = 0
  for d in a:
    result *= 10
    result += d

solveProc solve(S:string, L:int, R:int):
  var
    Sd = Seq[int]
    Sl = S.len
  for d in S:
    Sd.add d - '0'
  proc calc(R:int):int =
    if R < 0: return 0
    # R以下でのSの出現回数を探す
    let Rd = R.toDigit
    for i in 0 .. Rd.len - Sl:
      # Rd[i ..< i + Sl]にSdを当てはめる
      # 左側追従の場合
      # Rd[0 ..< i]
      block bb:
        if i == 0 and Sd[0] == 0: break bb
        ok := true
        following := true
        for j in 0 ..< Sl:
          if Rd[i + j] < Sd[j]:
            ok = false;break
          elif Rd[i + j] > Sd[j]:
            following = false
            break
        if not ok: break bb
        # okの場合の右側の決定
        d := 0
        if following:
          # 追従が続いている場合は右側の個数
          d += toInt(Rd[i + Sl .. ^1]) + 1
        else:
          # 続いていなければ10のべき
          d = 1
          for j in i + Sl ..< Rd.len:
            d *= 10
        result += d
      # それ以外
      # i = 0では追従しないといけない
      if i == 0: continue
      var d = toInt(Rd[0 ..< i])
      if Sd[0] == 0:
        # 最初が0のときは0はだめ
        d.dec
      if d <= 0: continue
      for j in i + Sl ..< Rd.len:
        d *= 10
      result += d
    discard
  echo calc(R) - calc(L - 1)
  Naive:
    Sd := Seq[int]
    for d in S:
      Sd.add d - '0'
    ans := 0
    for n in L .. R:
      var d = n.toDigit
      for i in d.len - Sd.len + 1:
        if d[i ..< i + Sd.len] == Sd:
          ans.inc
    echo ans

when not DO_TEST:
  var T = nextInt()
  for case_index in 0..<T:
    var S = nextString()
    var L = nextInt()
    var R = nextInt()
    solve(S, L, R)
else:
  #solve("0", 10, 10)
  #solve("1", 10, 10)
  for R in 1 .. 10000:
    debug R
    test("1", 1, R)
    test("0", 1, R)
    test("00", 1, R)
    test("09", 1, R)
    test("37", 1, R)

