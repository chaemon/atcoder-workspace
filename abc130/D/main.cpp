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

// segment tree point update, range query
// SegmentTree<T>(int n, T unit, function<T(T,T)> append)
// point_update(int i, T z), range_concat(int l, int r), build(vector<T> &v)
//{{{ class SegmentTree
template <typename T>
struct SegmentTree { // on monoid
	int n;
	vector<T> a;
	function<T (T,T)> append; // associative
	T unit; // unit
	SegmentTree() = default;
	SegmentTree(int a_n, T a_unit, function<T (T,T)> a_append) {
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1, a_unit);
		unit = a_unit;
		append = a_append;
	}
	void point_update(int i, T z) {
		a[i+n-1] = append(a[i+n-1],z);
		for (i = (i+n)/2; i > 0; i /= 2) {
			a[i-1] = append(a[2*i-1], a[2*i]);
		}
	}
	T range_concat(int l, int r) {
		return range_concat(0, 0, n, l, r);
	}
	T range_concat(int i, int il, int ir, int l, int r) {
		if (l <= il and ir <= r) {
			return a[i];
		} else if (ir <= l or r <= il) {
			return unit;
		} else {
			return append(
					range_concat(2*i+1, il, (il+ir)/2, l, r),
					range_concat(2*i+2, (il+ir)/2, ir, l, r));
		}
	}
	void build(int i, int il, int ir, const vector<T> &v){
		if(ir-il==1){
			if(il<n)a[i] = v[il];
			else a[i] = unit;
		}else{
			int im = (il+ir)/2;
			build(v,i*2+1,il,im);
			build(v,i*2+2,im,ir);
			a[i] = append(a[i*2+1],a[i*2+2]);
		}
	}
	void build(const vector<T> &v){
		build(0,0,n,v);
	}
};
//}}}

Int N;
Int K;
vector<Int> a;

Int append(Int a,Int b){
	return a + b;
}

void solve(){
	vector<Int> v;
	Int s = 0;
	for(int i = 0;i < N;i++){
		s += a[i];
		v.push_back(s);
		v.push_back(s+K);
	}
	sort(ALL(v));
	v.erase(unique(ALL(v)),v.end());
	SegmentTree<Int> st(v.size(),0,append);
	s = 0;
	REP(i,N){
		s += a[i];
		int j = distance(v.begin(),lower_bound(ALL(v),s));
		st.point_update(j,1);
	}
	Int ans = 0, base_sum = 0;
	for(int i = 0;i < N;i++){
//		ans += distance(st.lower_bound(K+base_sum),st.end());
		int j;
		j = distance(v.begin(),lower_bound(ALL(v),base_sum + K));
		ans += st.range_concat(j,v.size());
		
		base_sum += a[i];
		j = distance(v.begin(),lower_bound(ALL(v),base_sum));
		st.point_update(j,-1);
//		auto it = st.find(base_sum);
//		st.erase(it);
	}
	cout<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
    a.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> a[i];
    }
	solve();
	return 0;
}

//}}}

