#include<bits/stdc++.h>
#define X(i,l,r) for(int i=l;i<r;i++)
using namespace std;int main(){int n;cin>>n;pair<int,int> y[n];int a[n];int p,q;X(i,0,n)cin>>p>>q,y[--p]={--q,i};p=-1;q=0;X(x,0,n){p=max(p,n-1-y[x].first);if(p==x){X(i,q,x+1)a[y[i].second]=x+1-q;q=x+1;}}X(i,0,n)cout<<a[i]<<endl;}
