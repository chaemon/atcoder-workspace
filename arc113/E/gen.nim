include atcoder/extra/header/chaemon_header

var a:seq[string]

for N in 1..15:
  for b in 2^N:
    s := ""
    for i in 0..<N:
      if (b and (1 shl i)) == 0:
        s.add('a')
      else:
        s.add('b')
    a.add(s)

echo a.len
echo a.join("\n")
