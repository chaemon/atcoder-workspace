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

vector<int> vi;

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
//		a[i+n-1] = z;
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

int Q;

Int a_sum = 0, a_num = 0, b_sum = 0;
SegmentTree<pair<int,Int> > st;
vector<int> ind;

Int calc(int i){
	if(i==ind.size())return inf<Int>();
	Int x = ind[i];
	auto p = st.range_concat(0,i);
	return p.first * x - p.second - (a_num - p.first) * x + (a_sum - p.second) + b_sum;
}


pair<int,Int> append(pair<int,Int> l, pair<int,Int> r){
	return {l.first + r.first, l.second + r.second};
}

int main(){
	vector<vector<int> > query;
	cin>>Q;
	REP(i,Q){
		int q;
		cin>>q;
		if(q==1){
			int a,b;
			cin>>a>>b;
			query.push_back({1,a,b});
			ind.push_back(a);
		}else{
			query.push_back({2});
		}
	}
	sort(ALL(ind));
	ind.erase(unique(ALL(ind)),ind.end());
	st = SegmentTree<pair<int,Int> >(ind.size()+1,{0,0},append);
	REP(i,Q){
		auto q = query[i];
		if(q[0]==1){
			Int a = q[1], b = q[2];
			a_num++;
			a_sum += a;
			b_sum += b;
			int t = lower_bound(ALL(ind),(int)a) - ind.begin();
			st.point_update(t,{1,a});
		}else{
			int l = 0, r = ind.size();
			Int lval = calc(l), rval = calc(r);
			while(r-l>=3){
				int d = (r-l)/3;
				int l1 = l + d, r1 = r - d;
				Int l1val = calc(l1), r1val = calc(r1);
				if(l1val<=r1val){
					r = r1;
					rval = r1val;
				}else{
					l = l1;
					lval = l1val;
				}
			}
			Int ans = inf<Int>();
			int ans_i = -1;
			for(int i = l; i <= r;i++){
				Int v = calc(i);
				if(v < ans)ans = v, ans_i = i;
			}
			cout<<ind[ans_i]<<" "<<ans<<endl;
		}
	}
}


