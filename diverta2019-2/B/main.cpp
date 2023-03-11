// #includes {{{
#ifdef MY_DEBUG
#include "header/header.hpp"
#else
#include <bits/stdc++.h>
#endif

using namespace std;

#define REP(i,n) for(int i=0;i<(int)(n);++i)
#define RREP(i,a,b) for(int i=(int)(a);i<(int)(b);++i)
#define FOR(i,c) for(__typeof((c).begin()) i=(c).begin();i!=(c).end();++i)
#define LET(x,a) __typeof(a) x(a)
//#define IFOR(i,it,c) for(__typeof((c).begin())it=(c).begin();it!=(c).end();++it,++i)
#define ALL(c) (c).begin(), (c).end()
#define MP make_pair

#define EXIST(e,s) ((s).find(e)!=(s).end())

#define RESET(a) memset((a),0,sizeof(a))
#define SET(a) memset((a),-1,sizeof(a))
#define PB push_back
#define DEC(it,command) __typeof(command) it=command

//debug

#define whole(f,x,...) ([&](decltype((x)) whole) { return (f)(begin(whole), end(whole), ## __VA_ARGS__); })(x)

typedef long long Int;
typedef unsigned long long uInt;
typedef long double rn;

template<class T>
T inf(){
	return numeric_limits<T>::has_infinity?numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

//{{{ Union-Find
struct UnionFind {
	vector<int> data;
	UnionFind(int size) : data(size, -1) { }
	bool unionSet(int x, int y) {
		x = root(x); y = root(y);
		if (x != y) {
			if (data[y] < data[x]) swap(x, y);
			data[x] += data[y]; data[y] = x;
		}
		return x != y;
	}
	bool findSet(int x, int y) {
		return root(x) == root(y);
	}
	int root(int x) {
		int r;
		compress(x,r);
		return r;
	}
	int size(int x) {
		return -data[root(x)];
	}
	void compress(int x,int &r){
		if(data[x]<0){
			r=x;
			return;
		}
		compress(data[x],r);
		data[x]=r;
	}
};
//}}}

Int N;
vector<Int> x;
vector<Int> y;

void solve(){
	set<pair<Int,Int> > s,v;
	REP(i,N)s.insert({x[i],y[i]});
	REP(i,N){
		REP(j,N){
			if(i==j)continue;
			pair<Int,Int> p = {x[i]-x[j], y[i]-y[j]};
//			if(p.first>0 or (p.first==0 and p.second>0))v.insert(p);
			v.insert(p);
		}
	}
	Int ans0 = N;
	for(auto &&d:v){
		Int ans = N;
		auto s2(s);
		while(!s2.empty()){
			auto p0 = *s2.begin();
			vector<pair<Int,Int> > w = {p0};
			auto p = p0;
			while(1){
				p.first += d.first;
				p.second += d.second;
				if(s2.find(p)==s2.end()){
					break;
				}
				w.push_back(p);
			}
			p = p0;
			while(1){
				p.first -= d.first;
				p.second -= d.second;
				if(s2.find(p)==s2.end()){
					break;
				}
				w.push_back(p);
			}
			ans -= w.size() - 1;
			for(auto &&p:w){
				s2.erase(p);
			}
		}
		ans0 = min(ans,ans0);
	}
	cout<<ans0<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	x.assign(N,Int());
	y.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> x[i];
		cin >> y[i];
	}
	solve();
	return 0;
}

//}}}

