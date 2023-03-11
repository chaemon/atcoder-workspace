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

//{{{ id set??
template<class T>
struct id_set{
	vector<T> v;
	map<T,int> m;
	int num;
	id_set(){num=0;}
	int size(){return num;}
	int encode(const T &t){
		if(m.find(t)==m.end()){
			insert(t);
		}
		return m[t];
	}
	int operator[](const T &t){
		if(m.find(t)==m.end()){
			insert(t);
		}
		return m[t];
	}
	T decode(int i){
		assert(i<v.size());
		return v[i];
	}
	int insert(const T &t){
		if(m.find(t)!=m.end()){
			return m[t];
		}else{
			m.insert(MP(t,num));
			v.push_back(t);
			num++;
			assert(v.size()==num);
		}
		return num-1;
	}
	bool find(const T &t){
		return m.find(t)!=m.end();
	}
	void sort(){
		std::sort(v.begin(),v.end());
		m.clear();
		REP(i,v.size())m[v[i]]=i;
	}
};
//}}}

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
vector<Int> A;
vector<Int> B;

void solve(){
	id_set<int> ids;
	REP(i,N)ids.insert(A[i]),ids.insert(B[i]);
	UnionFind uf(ids.size());
	REP(i,N){
		int a = ids[A[i]], b = ids[B[i]];
		uf.unionSet(a,b);
	}
	vector<int> ct(ids.size());
	REP(i,N){
		int a = ids[A[i]], b = ids[B[i]];
		int r = uf.root(a);
		ct[r]++;
	}
	int ans = 0;
	REP(i,ids.size()){
		if(i!=uf.root(i))continue;
		ans += min(uf.size(i),ct[i]);
	}
	cout<<ans<<endl;
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    A.assign(N,Int());
    B.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> A[i];
        cin >> B[i];
    }
	solve();
	return 0;
}
//}}}
