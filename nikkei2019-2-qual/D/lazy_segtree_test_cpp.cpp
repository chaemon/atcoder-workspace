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

template< typename Monoid, typename OperatorMonoid = Monoid >
struct LazySegmentTree {
	using F = function< Monoid(Monoid, Monoid) >;
	using G = function< Monoid(Monoid, OperatorMonoid) >;
	using H = function< OperatorMonoid(OperatorMonoid, OperatorMonoid) >;

	int sz, height;
	vector< Monoid > data;
	vector< OperatorMonoid > lazy;
	const F f;
	const G g;
	const H h;
	const Monoid M1;
	const OperatorMonoid OM0;


	LazySegmentTree(int n, const F f, const G g, const H h,
			const Monoid &M1, const OperatorMonoid OM0)
	: f(f), g(g), h(h), M1(M1), OM0(OM0) {
		sz = 1;
		height = 0;
		while(sz < n) sz <<= 1, height++;
		data.assign(2 * sz, M1);
		lazy.assign(2 * sz, OM0);
	}

	void set(int k, const Monoid &x) {
		data[k + sz] = x;
	}

	void build() {
		for(int k = sz - 1; k > 0; k--) {
			data[k] = f(data[2 * k + 0], data[2 * k + 1]);
		}
	}

	inline void propagate(int k) {
		if(lazy[k] != OM0) {
			lazy[2 * k + 0] = h(lazy[2 * k + 0], lazy[k]);
			lazy[2 * k + 1] = h(lazy[2 * k + 1], lazy[k]);
			data[k] = reflect(k);
			lazy[k] = OM0;
		}
	}

	inline Monoid reflect(int k) {
		return lazy[k] == OM0 ? data[k] : g(data[k], lazy[k]);
	}

	inline void recalc(int k) {
		while(k >>= 1) data[k] = f(reflect(2 * k + 0), reflect(2 * k + 1));
	}

	inline void thrust(int k) {
		for(int i = height; i > 0; i--) propagate(k >> i);
	}

	void update(int a, int b, const OperatorMonoid &x) {
		thrust(a += sz);
		thrust(b += sz - 1);
		for(int l = a, r = b + 1; l < r; l >>= 1, r >>= 1) {
			if(l & 1) lazy[l] = h(lazy[l], x), ++l;
			if(r & 1) --r, lazy[r] = h(lazy[r], x);
		}
		recalc(a);
		recalc(b);
	}

	Monoid query(int a, int b) {
		thrust(a += sz);
		thrust(b += sz - 1);
		Monoid L = M1, R = M1;
		for(int l = a, r = b + 1; l < r; l >>= 1, r >>= 1) {
			if(l & 1) L = f(L, reflect(l++));
			if(r & 1) R = f(reflect(--r), R);
		}
		return f(L, R);
	}

	Monoid operator[](const int &k) {
		return query(k, k + 1);
	}

	template< typename C >
	int find_subtree(int a, const C &check, Monoid &M, bool type) {
		while(a < sz) {
			propagate(a);
			Monoid nxt = type ? f(reflect(2 * a + type), M) : f(M, reflect(2 * a + type));
			if(check(nxt)) a = 2 * a + type;
			else M = nxt, a = 2 * a + 1 - type;
		}
		return a - sz;
	}

	template< typename C >
	int find_first(int a, const C &check) {
		Monoid L = M1;
		if(a <= 0) {
			if(check(f(L, reflect(1)))) return find_subtree(1, check, L, false);
			return -1;
		}
		thrust(a + sz);
		int b = sz;
		for(a += sz, b += sz; a < b; a >>= 1, b >>= 1) {
			if(a & 1) {
				Monoid nxt = f(L, reflect(a));
				if(check(nxt)) return find_subtree(a, check, L, false);
				L = nxt;
				++a;
			}
		}
		return -1;
	}


	template< typename C >
	int find_last(int b, const C &check) {
		Monoid R = M1;
		if(b >= sz) {
			if(check(f(reflect(1), R))) return find_subtree(1, check, R, true);
			return -1;
		}
		thrust(b + sz - 1);
		int a = sz;
		for(b += sz; a < b; a >>= 1, b >>= 1) {
			if(b & 1) {
				Monoid nxt = f(reflect(--b), R);
				if(check(nxt)) return find_subtree(b, check, R, true);
				R = nxt;
			}
		}
		return -1;
	}
};

int f(int a, int b){
	return min(a,b);
}

bool check2019(int a){
	return a <= 2019;
}

int main(){
	auto st = LazySegmentTree<int,int>(10,f,f,f,1000000,1000000);
	st.update(0,3,3);
	st.update(4,7,2019);
	for(int i = 0;i < 10;i++){
		cout<<st.query(i,i+1)<<endl;
	}
	cout<<st.find_first(0,check2019)<<endl;
	cout<<st.find_last(10,check2019)<<endl;
}

