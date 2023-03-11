type S = object
  greater:iterator(a:int):int

iterator greater(a:int):int {.closure.} =
  for i in a + 1 ..< 10:yield i

var s = S(greater:greater)

# works well
echo "test by iterator"
for i in greater(2): stdout.write i, " "
echo ""
for i in greater(5): stdout.write i, " "
echo ""
# not work second for loop
echo "test by iterator member"
for i in s.greater(2): stdout.write i, " "
echo ""
for i in s.greater(5): stdout.write i, " "
echo ""
