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

Int N;
Int Q;
vector<Int> S;
vector<Int> T;
vector<Int> X;
vector<Int> D;

vector<int> v;

// segmenttree, range update, point query
//{{{ SegmentTree<T> st(int n, T unit, function<T(T,T)> append)
template <typename T>
struct SegmentTree { // on monoid
	int n;
	vector<T> a;
	function<T (T,T)> append; // associative
	T unit; // unit
	SegmentTree() = default;
	SegmentTree(int a_n, T a_unit, function<T(T,T)> a_append) {
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1, a_unit);
		unit = a_unit;
		append = a_append;
	}
	T point_get(int i) {
//		a[i+n-1] = z;
		T ret = unit;
//		for (i = (i+n)/2; i > 0; i /= 2) {
		for (i = i + n; i > 0; i /= 2) {
			ret = append(a[i-1], ret);
//			a[i-1] = append(a[2*i-1], a[2*i]);
		}
		return ret;
	}
	void range_update(int l, int r, T t) {
		range_update(0, 0, n, l, r, t);
	}
	void range_update(int i, int il, int ir, int l, int r, T t) {
		if (l <= il and ir <= r) {
			a[i] = append(a[i],t);
		} else if (ir <= l or r <= il) {
			return;
		} else {
			range_update(2*i+1, il, (il+ir)/2, l, r, t);
			range_update(2*i+2, (il+ir)/2, ir, l, r, t);
		}
	}
	void set(){
		
	}
	//{{{ debug functions
	void write_tree(int i,int h,int il,int ir){
		REP(j,h)cout<<" ";
		cout<<a[i]<<endl;
		if(ir-il==1){
			return;
		}else{
			int im = (il+ir)/2;
			write_tree(i*2+1,h+1,il,im);
			write(i*2+2,h+1,im,ir);
		}
	}
	void write_tree(){
		write_tree(0,0,0,n);
	}
	void write(){
		REP(i,n)cout<<point_get(i)<<" ";
		cout<<endl;
	}
	//}}}
};
//}}}

int append(int l,int r){
	return min(l,r);
}

void solve(){
	REP(i,N){
		v.push_back(S[i]-X[i]);
		v.push_back(T[i]-X[i]);
	}
	REP(i,Q)v.push_back(D[i]);
	sort(ALL(v));
	v.erase(unique(ALL(v)),v.end());
	SegmentTree<int> st((int)v.size(),inf<int>(),append);
	REP(i,N){
		int s = lower_bound(ALL(v),S[i]-X[i]) - v.begin();
		int t = lower_bound(ALL(v),T[i]-X[i]) - v.begin();
//		dump(S[i]-X[i],T[i]-X[i],s,t);
		st.range_update(s,t,X[i]);
	}
	REP(i,Q){
		int s = lower_bound(ALL(v),D[i]) - v.begin();
		int j = st.point_get(s);
		if(j<inf<int>())cout<<j<<endl;
		else cout<<-1<<endl;
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> Q;
    S.assign(N,Int());
    T.assign(N,Int());
    X.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> S[i];
        cin >> T[i];
        cin >> X[i];
    }
    D.assign(Q,Int());
    for(int i = 0 ; i < Q ; i++){
        cin >> D[i];
    }
	solve();
	return 0;
}

//}}}

