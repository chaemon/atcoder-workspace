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
constexpr T inf = numeric_limits<T>::has_infinity ? numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);

int __inf_ignore(){
	int t = inf<int>;
	return t;
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

Int N;
vector<Int> x;
vector<Int> y;

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

void solve(){
	const int B = 100001;
	UnionFind ufx(B), ufy(B);
	unordered_set<int> listx, listy;
	unordered_map<int,vector<int> > xy, yx;
	REP(i,N){
		xy[x[i]].push_back(y[i]);
		yx[y[i]].push_back(x[i]);
		listx.insert(x[i]);
		listy.insert(y[i]);
	}
	for(auto &&p:xy){
		auto &&v = p.second;
		REP(i,v.size()){
			ufy.unionSet(v[0],v[i]);
		}
	}
	for(auto &&p:yx){
		auto &&v = p.second;
		REP(i,v.size()){
			ufx.unionSet(v[0],v[i]);
		}
	}
	vector<vector<int> > xv(B), yv(B);
	for(int x = 0;x < B;x++){
		if(listx.find(x)==listx.end())continue;
		int r = ufx.root(x);
		xv[r].push_back(x);
	}
	for(int y = 0;y < B;y++){
		if(listy.find(y)==listy.end())continue;
		int r = ufy.root(y);
		yv[r].push_back(y);
	}
	Int ans = 0;
	vector<bool> visx(B), visy(B);
	REP(i,N){
		int rx = ufx.root(x[i]), ry = ufy.root(y[i]);
		if(visx[rx] or visy[ry])continue;
		visx[rx] = visy[ry] = true;
		ans += ufx.size(rx) * (Int)ufy.size(ry);
	}

	cout<<ans - N<<endl;
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

