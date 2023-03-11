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

const string nl = "\n";

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

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	int N;
	cin>>N;
	vector<int> x(N), y(N);
	REP(i,N)cin>>x[i]>>y[i];
	UnionFind uf(N);
	vector<pair<int,int> > v;
	for(int i = 0;i < N;i++){
		v.emplace_back(x[i], i);
	}
	sort(ALL(v));
	REP(d, 2){
		map<int,int> mp;
		REP(ii, N){
			int i = v[ii].second;
			mp[y[i]] = i;
			auto it = mp.lower_bound(y[i]);
			if(it != mp.begin()){
				auto it0 = mp.begin();
				int y0 = it0->first, i0 = it0->second;
				it0++;
				while(true){
					int y1 = it0->first, i1 = it0->second;
					uf.unionSet(i0, i1);
					if(it0 == it) break;
					it0++;
				}
				mp.erase(mp.begin(), it);
			}
		}
		reverse(ALL(v));
		REP(i,N)y[i] *= -1;
	}
	REP(i, N){
		cout<<uf.size(i)<<endl;
	}
	return 0;
}

