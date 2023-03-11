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
#include"debug.hpp"
#include"print.hpp"
#endif
// }}}

Int append(Int a, Int b){
	return max(a,b);
}

//{{{ segment_tree<T> st(int n, T unit, function<T(T,T)> append)
template <typename T>
struct segment_tree { // on monoid
	int n;
	vector<T> a;
	function<T (T,T)> append; // associative
	T unit; // unit
	segment_tree() = default;
	segment_tree(int a_n, T a_unit, function<T(T,T)> a_append) {
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

Int N;
vector<Int> A;

void test(){
	segment_tree<Int> st(10,0,append);
	st.range_update(1,4,2001);
	st.range_update(2,9,1003);
	st.write();
}

void solve(){
	segment_tree<Int> st(1000*1000+1,0,append);
	for(int i = N - 1;i>=0;i--){
		//process A[i]
		vector<pair<pair<Int,Int>,Int> > result;
		for(Int X = 1;X*X <= A[i]; X++){
			Int Y = A[i]/X;
			if(Y>0){
				Int ans0 = st.point_get(Y) + Y;
				result.push_back({{X,X+1},ans0});
			}
		}
		for(Int Y = 1;Y*Y <= A[i]; Y++){
			Int Xl = A[i]/(Y+1) + 1, Xr = A[i]/Y + 1;
			assert(Xl>=Xr or 
					(A[i]/Xl==Y and (Xl==1 or A[i]/(Xl-1)!=Y))
					and (A[i]/(Xr-1)==Y and A[i]/Xr!=Y));
			if(Xl<Xr){
				Int ans0 = st.point_get(Y) + Y;
				if(Xl<Xr)result.push_back({{Xl,Xr},ans0});
			}
		}
		for(auto p:result){
			st.range_update(p.first.first,p.first.second,p.second);
		}
	}
	Int ans = 0;
	for(auto p:st.a){
		ans = max(ans,p);
	}
	cout<<ans<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	A.resize(N);
	for(int i = 0 ; i < N ; i++){
		cin >> A[i];
	}
	solve();
	return 0;
}

//}}}

