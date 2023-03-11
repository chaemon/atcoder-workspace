# verify-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum

when not declared ATCODER_HEADER_HPP:
  const ATCODER_HEADER_HPP* = 1
  {.hints:off checks:off assertions:on checks:off optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/streams as streams_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  proc getchar*(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(base:int = 0): int =
    scanf("%lld",addr result)
    result -= base
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*(): string =
    var get = false;result = ""
    while true:
      var c = getchar()
      if int(c) > int(' '): get = true;result.add(c)
      elif get: break
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
when not declared ATCODER_FENWICKTREE_HPP:
  const ATCODER_FENWICKTREE_HPP* = 1
  import std/sequtils

  # TODO
  #include <atcoder/internal_type_traits>

  # Reference: https://en.wikipedia.org/wiki/Fenwick_tree
  type fenwick_tree*[T] = object
    n:int
    data:seq[T]
  
  # TODO
  #  using U = internal::to_unsigned_t<T>;
  
  proc init_fenwick_tree*[T](n:int):auto
    = fenwick_tree[T](n:n, data:newSeqWith(n, T(0)))
  
  proc add*[T](self: var fenwick_tree[T], p:int, x:T) =
    assert p in 0..<self.n
    var p = p + 1
    while p <= self.n:
  # TODO
  #      self.data[p - 1] += U(x)
      self.data[p - 1] += x
      p += p and -p
  proc sum*[T](self: fenwick_tree[T], r:int):T =
    var
      s = T(0)
      r = r
    while r > 0:
      s += self.data[r - 1]
      r -= r and -r
    return s
  proc sum*[T](self: fenwick_tree[T], p:Slice[int]):T =
    let (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    return self.sum(r) - self.sum(l)
  
#  U sum(int r) =
#    U s = 0;
#    while (r > 0) {
#      s += data[r - 1];
#      r -= r & -r;
#    }
#    return s;
#  }


import std/sequtils

let N, Q = nextInt()
let a = newSeqWith(N, nextInt())

var st = initFenwickTree[int](N)

for i in 0..<N: st.add(i, a[i])
for _ in 0 ..< Q:
  let t = nextInt()
  if t == 0:
    let p, x = nextInt()
    st.add(p, x)
  else:
    let l, r = nextInt()
    echo st.sum(l..<r)
