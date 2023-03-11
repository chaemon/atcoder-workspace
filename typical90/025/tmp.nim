include atcoder/extra/header/chaemon_header

block:
  iterator `*`[T](a, b: Slice[T]):(T, T) =
    for p in a:
      for q in b:
        yield (p, q)
    discard
  for (a, b) in (0 .. 3) * (0 .. 4):
    echo a, " ", b
    discard

