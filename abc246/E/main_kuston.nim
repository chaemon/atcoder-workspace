{.checks: off.}

include atcoder/extra/header/chaemon_header

import std/strutils
import std/bitops
import std/sequtils
import std/sets
import std/algorithm
import std/sugar
import std/heapqueue
import std/deques
import std/tables
import std/math

#####################################################
func newSeq2d[T](h: int, w: int, init: T): seq[seq[T]] = newSeqWith(h,
    newSeqWith(w, init))
func newSeq3d[T](x: int, y: int, z: int, init: T): seq[seq[seq[
    T]]] = newSeqWith(x, newSeqWith(y, newSeqWith(z, init)))

proc chmin[T](a: var T, b: T) =
  if b < a:
    a = b
proc chmax[T](a: var T, b: T) =
  if b > a:
    a = b

func digitToInt(c: char): int = c.ord - '0'.ord

func toOut[T](x: T): string = $x
func toOut(b: bool): string =
  if b:
    "Yes"
  else:
    "No"
func toOutLn[T](s: seq[T]): string = s.map(toOut).join(" ")
func toOutCl[T](s: seq[T]): string = s.map(toOut).join("\n")

#####################################################
func surronded(s: seq[string], c: char): seq[string] =
  if s.len == 0 or s[0].len == 0:
    return @[$c]
  let w = s[0].len + 2
  let h = s.len + 2
  return @[c.repeat(w)] & s.mapIt(c & it & c) & @[c.repeat(w)]


proc solve() =
  let N = nextInt()
  let ax, ay = nextInt()
  let bx, by = nextInt()
  let S = newSeqWith(N, nextString()).surronded('#')

  let dir: seq[tuple[x, y: int]] = @[(1, 1), (-1, 1), (-1, -1), (1, -1)]

  var q = initDeque[tuple[x, y, dir, step: int]]()
  q.addLast((ax, ay, 0, 0))
  var checked = newSeq3d(N+2, N+2, 4, false)
  while q.len > 0:
    let c = q.popFirst
    if c.x == bx and c.y == by:
      echo c.step
      return
    for i, d in dir:
      if d.x * d.y == c.dir:
        continue
      var nx = c.x + d.x
      var ny = c.y + d.y
      while S[nx][ny] == '.':
        if not checked[nx][ny][i]:
          checked[nx][ny][i] = true
          q.addLast((nx, ny, d.x*d.y, c.step+1))
        nx += d.x
        ny += d.y
  echo -1

solve()
