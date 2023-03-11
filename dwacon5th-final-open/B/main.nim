import sequtils, tables
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextUint(): uint = scanf("%llu",addr result)
proc nextFloat(): float = scanf("%lf",addr result)

type TrieNode = object
  count:int
  next:array[2,int]

type Trie = object
  trie_node:seq[TrieNode]

proc getTrieNode(t:var Trie):int =
  t.trie_node.add(TrieNode(count:0,next:[-1,-1]))
  let ret = t.trie_node.len - 1
  return ret
proc addTrie(t:var Trie, n:uint):void =
  var ti = 0
  for i in countdown(31,0):
    t.trie_node[ti].count += 1
    var d:int
    if (n and (uint(1) shl uint(i))) == 0:
      d = 0
    else:
      d = 1
    if t.trie_node[ti].next[d] == -1:
      let ret = t.getTrieNode()
      t.trie_node[ti].next[d] = ret
    ti = t.trie_node[ti].next[d]
  t.trie_node[ti].count += 1
proc removeTrie(t:var Trie, n:uint):void =
  var ti = 0
  for i in countdown(31,0):
    t.trie_node[ti].count -= 1
    var d:int
    if (n and (uint(1) shl uint(i))) == 0:
      d = 0
    else:
      d = 1
    if t.trie_node[ti].next[d] == -1:
      assert false
    ti = t.trie_node[ti].next[d]
  t.trie_node[ti].count -= 1
proc findMin(t:Trie, n:uint):uint =
  var
    ti = 0
    ret = uint(0)
  for i in countdown(31,0):
    assert t.trie_node[ti].count > 0
    var
      p:array[2,int]
    if (n and (uint(1) shl uint(i))) == 0:
      p = [0,1]
    else:
      p = [1,0]
    for d in p:
      let tj = t.trie_node[ti].next[d]
      if tj == -1: continue
      if t.trie_node[tj].count == 0: continue
      ti = t.trie_node[ti].next[d]
      if d == 1:
        ret = (ret or (uint(1) shl uint(i)))
      break
  return ret

proc newTrie():Trie =
  var
    t = Trie(trie_node:newSeq[TrieNode]())
    u = t.getTrieNode()
  return t

var
  N = nextInt()
  a = newSeqWith(N,nextUint())
  s = uint(0)
  t = newTrie()



for i in 0..<N:
  s = s xor a[i]
  if i != N-1:
    t.addTrie(s)

var
  s2 = uint(0)

for i in 0..<N-1:
  var u = t.findMin(s2)
  stdout.write s2 xor u," "
  t.removeTrie(u)
  s2 = u

stdout.write s xor s2,"\n"
