include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(A:int, B:int) =
  var (A, B) = (A, B)
  swapped := false
  if A > B: swap(A, B); swapped = true
  # A <= B
  a := Seq[int]
  s := 0
  for i in 1..B:
    a.add(-i)
    s += i
  for i in 1..A - 1:
    a.add(i)
    s -= i
  a.add(s)
  if swapped:
    for it in a.mitems: it *= -1
  echo a.join(" ")
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

