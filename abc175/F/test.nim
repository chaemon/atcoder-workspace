import heapqueue

proc main() =
  type Q = object
    d:int

#  mixin `<`
  proc `<`(a, b:Q):bool = a.d < b.d

  var q = initHeapQueue[Q]()
  for d in [3, 1, 4, 1, 5, 9, 2, 6, 5]:
    q.push(Q(d:d))
  while q.len > 0:
    var a = q.pop()
    echo a.d

main()
