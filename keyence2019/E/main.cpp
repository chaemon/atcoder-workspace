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

struct S{
	Int val;
	int i;
	S(Int val, int i):val(val),i(i){}
};

struct T{
	Int val;
	int s,t;
	T(){
		
	}
	T(Int val, int s, int t):val(val),s(s),t(t){
		
	}
	bool operator<(const T &t)const{
		return val > t.val;
	}
};

S append(const S &l, const S &r){
	if(l.val <= r.val){
		return l;
	}else{
		return r;
	}
}

//segment tree point update, range query
//{{{ SegmentTree(int n, T a_unit, function<T(T,T)> append)
template <typename T>
struct SegmentTree { // on monoid
	int n;
	vector<T> a;
	T unit; // unit
	function<T (T,T)> append; // associative
	SegmentTree() = default;
	SegmentTree(int a_n, T a_unit, function<T (T,T)> a_append):unit(a_unit), append(a_append){
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1, a_unit);
	}
	void point_update(int i, T z) {
//		a[i+n-1] = append(a[i+n-1],z);
		a[i+n-1] = z;
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
		if(ir - il==1){
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
	void write(){
		for(int i = 0;i < n;i++){
			T t = range_concat(i,i+1);
			if(t.val==inf<Int>())cerr<<"*"<<" ";
			else cerr<<t.val<<" ";
		}
		cerr<<endl;
	}
};
//}}}

Int N;
Int D;
vector<Int> A;

const S Inf = S(inf<Int>(),-1);

void solve(){
	vector<bool> selected(N,false);
	priority_queue<T> q;
	SegmentTree<S> left((int)N,Inf,append), right((int)N,Inf,append);
	for(int i = 0;i < N;i++){
		left.point_update(i, S(A[i] - i * D, i));
		right.point_update(i, S(A[i] + i * D, i));
	}
	auto update_weight_queue = [&](int i){
		auto sl = left.range_concat(0,i);
		Int lv = (sl.val < inf<Int>())?sl.val + A[i] + i * D:inf<Int>();
		auto sr = right.range_concat(i+1,N);
		Int rv = (sr.val < inf<Int>())?sr.val + A[i] - i * D:inf<Int>();
		if(lv<rv){
//			dump(i,sl.i,lv);
			q.push(T(lv,i,sl.i));
		}else{
//			dump(i,sr.i,rv);
			if(rv < inf<Int>())q.push(T(rv,i,sr.i));
		}
	};
	Int ans = 0;
	q.push(T(0, -1, 0));
	for(;!q.empty();){
		auto qt = q.top();
		int s = qt.s, t = qt.t;
		q.pop();
		if(selected[t]){
			if(s>=0)update_weight_queue(s);
			continue;
		}
		Int val = qt.val;
		selected[t] = true;
		ans += val;
		left.point_update(t,S(inf<Int>(),t));
		right.point_update(t,S(inf<Int>(),t));
		update_weight_queue(t);
		if(s>=0)update_weight_queue(s);
	}
	cout<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> D;
	A.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> A[i];
	}
	solve();
	return 0;
}

//}}}
