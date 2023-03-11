n,x,*A=map(int,open(0).read().split())
o=F=1e20
r=range
for k in r(1,n+1):
 d=[n*[-F]for _ in r(n+1)];d[0][0]=0
 for a in A:
  for i in r(k,0,-1):
   print(i)
   for j in r(k):d[i][j]=max(d[i][j],d[i-1][(j-a)%k]+a)
 o=min(o,(x-d[k][x%k])//k)
print(o)



#n,x,*A=map(int,open(0).read().split())
#o=F=1e20
#r=range
#for k in r(1,n+1):
# d=n*[-F];d[0]=0
# for a in A:
#  e=n*[-F]
#  for i in r(k,0,-1):
#   for j in r(k):e[j]=max(e[j],d[(j-a)%k]+a)
#  d=e
# o=min(o,(x-d[x%k])//k)
#print(o)
