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

//{{{
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
		a.resize(2*n-1, a_unit_m);
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
	void assign_val(int k, M z){
		assign_val(0,0,n,k,z);
	}
	void assign_val(int i, int il, int ir, int k, M z){
		if(ir - il == 1){
			dump(a[i]);
			a[i] = z;
			dump(a[i]);
		}else{
			int im = (il+ir)/2;
			range_apply(2*i+1, il, im, 0, n, q[i]);
			range_apply(2*i+2, im, ir, 0, n, q[i]);
			if(k<im)assign_val(i*2+1,il,im,k,z);
			else    assign_val(i*2+2,im,ir,k,z);
		}
	}
	void write(){
		REP(i,n){
			cerr<<range_concat(i,i+1)<<" ";
		}
		cerr<<endl;
	}
};
//}}}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	function<int(int,int)> append_m = [&](int a, int b){
		return max(a,b);
	};
	function<int(int,int)> append_q = [&](int a, int b){
		return a + b;
	};
	function<int(int,int)> apply = [&](int a, int b){
		if(b==-inf<int>())return -inf<int>();
		else return a + b;
	};
	int N;
	cin>>N;
	vector<Int> w(N);
	REP(i,N)cin>>w[i];
	vector<vector<int> > t(N);
	vector<int> index;
	REP(i,N){
		int M;
		cin>>M;
		t[i].resize(M);
		REP(j,M)cin>>t[i][j], index.push_back(t[i][j]);
	}
	sort(ALL(index));
	index.erase(unique(ALL(index)),index.end());
	vector<vector<int> > v(index.size()+1);
	REP(i,N){
		REP(j,t[i].size()){
			int k = lower_bound(ALL(index),t[i][j]) - index.begin();
			v[k].push_back(i);
		}
	}
	lazy_propagation_segment_tree<int,int> st(index.size()+1, -inf<int>(), 0, append_m, append_q, apply);
	Int ans = 0;
	vector<int> prev(N,-1);
	REP(t,index.size()+1){
		dump(t);
		st.write();
		Int val;
		if(t==0)val = 0;
		else val = st.range_concat(0,t);
		ans = max(ans,val);
		st.assign_val(t,val);
		cerr<<"u = ";
		for(auto &&u:v[t]){
			int s;
			cerr<<u<<",";
			assert(u<N);
			if(prev[u]==-1)s = -1;
			else s = prev[u];
			st.range_apply(s+1,t+1,w[u]);
			prev[u] = t;
		}
		cerr<<endl;
	}
	cout<<ans<<endl;
	// Failed to predict input format
	return 0;
}

//}}}

