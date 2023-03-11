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
#define dump(x)  cerr << #x << " = " << (x) << endl;
#define debug(x) cerr << #x << " = " << (x) << " (L" << __LINE__ << ")" << " " << __FILE__ << endl;
#define debug_v(x) cerr << #x << " = [";REP(__ind,(x).size()){cerr << (x)[__ind] << ", ";}cerr << "] (L" << __LINE__ << ")" << endl;

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
#include"debug.hpp"
#include"print.hpp"
#endif
// }}}

//{{{ lazy_propagation_segment_tree
template <typename M, typename Q>
struct lazy_propagation_segment_tree { // on monoids
	int n;
	vector<M> a;
	vector<Q> q;
	function<M (M,M)> append_m; // associative
	function<Q (Q,Q)> append_q; // associative, not necessarily commutative
	function<M (Q,M)> apply; // distributive, associative
	M unit_m; // unit
	Q unit_q; // unit
	lazy_propagation_segment_tree() = default;
	lazy_propagation_segment_tree(int a_n, M a_unit_m, Q a_unit_q, function<M (M,M)> a_append_m, function<Q (Q,Q)> a_append_q, function<M (Q,M)> a_apply) {
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1,     a_unit_m);
		// q.resize(2*(n-1)-1, a_unit_q);
		q.resize(2*n-1, a_unit_q);
		unit_m = a_unit_m;
		unit_q = a_unit_q;
		append_m = a_append_m;
		append_q = a_append_q;
		apply = a_apply;
	}
	void range_apply(int l, int r, Q z) {
		range_apply(0, 0, n, l, r, z);
	}
	void range_apply(int i, int il, int ir, int l, int r, Q z) {
		if (l <= il and ir <= r) {
			a[i] = apply(z, a[i]);
			// if (i < q.size()) q[i] = append_q(z, q[i]);
			q[i] = append_q(z, q[i]);
		} else if (ir <= l or r <= il) {
			// nop
		} else {
			range_apply(2*i+1, il, (il+ir)/2, 0, n, q[i]);
			range_apply(2*i+1, il, (il+ir)/2, l, r, z);
			range_apply(2*i+2, (il+ir)/2, ir, 0, n, q[i]);
			range_apply(2*i+2, (il+ir)/2, ir, l, r, z);
			a[i] = append_m(a[2*i+1], a[2*i+2]);
			q[i] = unit_q;
		}
	}
	M range_concat(int l, int r) {
		return range_concat(0, 0, n, l, r);
	}
	M range_concat(int i, int il, int ir, int l, int r) {
		if (l <= il and ir <= r) {
			return a[i];
		} else if (ir <= l or r <= il) {
			return unit_m;
		} else {
			return apply(q[i], append_m(
						range_concat(2*i+1, il, (il+ir)/2, l, r),
						range_concat(2*i+2, (il+ir)/2, ir, l, r)));
		}
	}
	void write(){
		cerr<<"======"<<endl;
		for(int i=0;i<n;i++){
			cerr<<range_concat(i,i+1)<<" ";
		}
		cerr<<endl;
	}
};
//}}}

Int N;
vector<int> b;
Int Q;
vector<int> l;
vector<int> r;

void test(){
	function<int(int,int)> a_append_m = [](int x,int y){
		return min(x,y);
	};
	function<int(int,int)> a_append_q = [](int x,int y){
		return min(x,y);
	};
	function<int(int,int)> a_apply = [](int x,int y){
		return min(x,y);
	};

	lazy_propagation_segment_tree<int,int> st(10, inf<int>(), inf<int>(), a_append_m, a_append_q, a_apply);
	st.range_apply(0,2,10);
	st.range_apply(2,4,7);
	st.range_apply(3,5,4);
	for(int i=0;i<10;i++){
		cout<<st.range_concat(i,i+1)<<" ";
	}
	cout<<endl;
	st.range_apply(1,4,5);
	for(int i=0;i<10;i++){
		cout<<st.range_concat(i,i+1)<<" ";
	}
	cout<<endl;
}


void solve(){
	function<int(int,int)> a_append_m = [](int x,int y){
		return min(x,y);
	};
	function<int(int,int)> a_append_q = [](int x,int y){
		return min(x,y);
	};
	function<int(int,int)> a_apply = [](int x,int y){
		return min(x,y);
	};

	lazy_propagation_segment_tree<int,int> st(N+1, inf<int>(), inf<int>(), a_append_m, a_append_q, a_apply);
	vector<Int> dp(N+1,inf<Int>());
	vector<pii> qs;
	REP(i,Q)qs.push_back({l[i],r[i]});
	sort(ALL(qs));
	st.range_apply(0,1,0);
	int j = 0, s = 0, cur_min = 0;
	for(int i=0;i<N;i++){
		// cur_min is minimal among [0,i)
		// cur_min propagation
//		dump(cur_min);
		while(j<qs.size() and qs[j].first==i){
//			dp[qs[j].second] = min(dp[qs[j].second], cur_min + numzero[qs[j].second] - numzero[qs[j].first]);
			auto l = qs[j].first, r = qs[j].second;
			auto t = min(st.range_concat(l,r), cur_min - s);
			st.range_apply(r,r+1,t);
			j++;
		}
//		dump(s);
//		st.write();
		assert(j==qs.size() or qs[j].first>i);
		//update cur_min to [0,i+1)
		if(b[i]==1)cur_min++;
		else s++;
		cur_min = min(cur_min, st.range_concat(i,i+1) + s);
	}
//	cout<<st.range_concat(N-1,N) + s<<endl;
	cout<<cur_min<<endl;
//	cout<<cur_min<<endl;
}


//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	b.resize(N);
	for(int i = 0 ; i < N ; i++){
		cin >> b[i];
	}
	cin >> Q;
	l.resize(Q);
	r.resize(Q);
	for(int i = 0 ; i < Q ; i++){
		cin >> l[i];
		l[i]--;
		cin >> r[i];
	}
	solve();
	return 0;
}

//}}}
