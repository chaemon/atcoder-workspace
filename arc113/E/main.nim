include atcoder/extra/header/chaemon_header

const DEBUG = true

proc solve(T:int, S:seq[string]) =
  for S in S:
    ac := S.count('a')
    bc := S.count('b')
    if ac == S.len or bc == S.len: # all a
      echo S
    else:
      # count a range
      var v = newSeq[int]()
      var i = 0
      let ra = S.rfind('a')
      assert ra >= 0
      while i < S.len:
        while i < S.len and S[i] == 'b': i.inc
        if i == S.len: break
        assert S[i] == 'a'
        var j = i
        while j < S.len and S[j] == 'a': j.inc
        v.add(j - i)
        i = j
      let rb = S.len - 1 - S.rfind('a')
      let lb = bc - rb
      var ans:string
      if rb != 0:
        # back a-s
        ans = 'b'.repeat(lb) & 'a'.repeat(ac mod 2) & 'b'.repeat(rb)
        block b1: # any a's
          var
            tail = 0
            tail_count = 0
            one = 0
          for i in 0..<v.len:
            if v[i] == 1: one.inc
            else:
              tail += v[i]
              tail_count.inc
          if S[0] == 'a' and tail_count + one == 1:
            break b1
          if tail_count == 0:
            tail = one mod 2
          else:
            tail -= (tail_count - 1) * 2
            if S[0] == 'a' and v[0] >= 2 and tail_count == 1:
              one.dec
              tail.dec
            if one mod 2 == 1:
              tail.dec
              one.dec
          ans.max= 'b'.repeat(lb + rb - 2) & 'a'.repeat(tail)
      else:
        block: # back a-s
          var
            tail = 0
            tail_count = 0
            n = v.len
            one = 0
          if v[^1] == 1:
            tail.inc
            tail_count.inc
            n = v.len - 1
          for i in 0..<n:
            if v[i] == 1: one.inc
            else:
              tail += v[i]
              tail_count.inc
          tail -= (tail_count - 1) * 2
          if one mod 2 == 1:
            tail.dec
          ans = 'b'.repeat(lb) & 'a'.repeat(tail)
      echo ans
  return

# input part {{{
block:
  var T = nextInt()
  var S = newSeqWith(T, nextString())
  solve(T, S)
#}}}

