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

const int MOD = 1000000007;
//{{{ modular algebra
template<int mod=MOD>
struct Num{
	int v;
	Num(int n):v(n){}
	Num():v(0){}
	operator int() const {return v;}
	operator long long() const {return v;}
	Num operator=(int n){v=n;return *this;}

	inline void operator*=(const Num &a) {
		v = (v*(long long)a)%mod;
	}
	inline Num operator*(const Num &a) const {
		Num n(*this);n*=a;
		return n;
	}
	inline void operator+=(const Num &a){
		v += (int)a;
		if(v>=mod)v -=mod;
		//	assert(0<=v and v<mod);
	}
	inline Num operator+(const Num &a) const {
		Num n(*this);n+=a;
		return n;
	}
	inline Num operator-(){
		if(v==0)return 0;
		else return Num(mod-v);
	}
	inline void operator-=(Num &a){
		v-=(int)a;
		if(v<0)v+=mod;
	}
	inline Num operator-(Num &a){
		Num n(*this);n-=a;
		return n;
	}
#ifdef __GCD_H
	inline Num inv(){
		return Num(invMod(this->v,mod));
	}
	inline void operator/=(const Num &a){
		(*this)*=invMod((int)a,mod);
	}
	inline Num operator/(const Num &a){
		Num n(*this);n/=a;
		return n;
	}
#endif
};

template<class T, int mod>
T& operator <<(T &os, const Num<mod> &n){
	os<<(int)n.v;
	return os;
}

template<class T, int mod>
T& operator >>(T &is, Num<mod> &n){
	is>>n.v;
	return is;
}
//}}}
typedef Num<MOD> mod_int;

Int N;
vector<Int> A;
string S;
Int Q;
vector<Int> T;
vector<Int> X;
vector<Int> Y;

typedef deque<mod_int> P;

P append(const P &s, const P &t, const char &op){
	if(s.size()==0)return t;
	else if(t.size()==0)return s;
	P d(s);
	if(op=='+'){
		d.insert(d.end(),ALL(t));
	}else{
		d.pop_back();
		d.push_back(s.back() * t.front());
		d.insert(d.end(),t.begin()+1,t.end());
	}
	if(d.size() <= 2){
		return d;
	}else{
		return {d.front(),accumulate(d.begin()+1, d.end()-1, (mod_int)0),d.back()};
	}
}

template <typename T>
struct segment_tree { // on monoid
	int n;
	vector<T> a;
	function<T (T,T,char)> append; // associative
	T unit; // unit
	segment_tree() = default;
	segment_tree(int a_n, T a_unit, function<T (T,T,char)> a_append) {
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1, a_unit);
		S.resize(n);
		unit = a_unit;
		append = a_append;
	}
	
	/*
	void point_update(int i, T z) {
		a[i+n-1] = z;
		for (i = (i+n)/2; i > 0; i /= 2) {
			a[i-1] = append(a[2*i-1], a[2*i], 'a');
		}
	}
	*/
	void build(int i, int il, int ir){
		if(ir - il == 1){
			if(il<N)a[i] = {A[il]};
			else a[i] = {};
		}else{
			int im = (il+ir)/2;
			build(i*2+1,il,im);
			build(i*2+2,im,ir);
			a[i] = append(a[i*2+1],a[i*2+2],S[im-1]);
		}
	}
	void build(){
		build(0,0,n);
	}
	void point_update(int i, int il, int ir, int t){
		if(ir - il == 1){
			a[i] = {A[t]};
		}else{
			int im = (il+ir)/2;
			if(t<im)point_update(i*2+1,il,im,t);
			else point_update(i*2+2,im,ir,t);
			a[i] = append(a[i*2+1],a[i*2+2],S[im-1]);
		}
	}
	void point_update(int t, mod_int z){
		A[t] = z;
		point_update(0, 0, n, t);
	}
	void point_update_op(int i, int il, int ir, int t){
		if(ir - il == 1){
			// do nothing
		}else{
			int im = (il+ir)/2;
			if(t<im-1)point_update_op(i*2+1,il,im,t);
			else if(im<=t)point_update_op(i*2+2,im,ir,t);
			a[i] = append(a[i*2+1],a[i*2+2],S[im-1]);
		}
	}
	void point_update_op(int t, char op){
		S[t] = op;
		point_update_op(0, 0, n, t);
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
			int im = (il+ir)/2;
			auto ret = append(
					range_concat(2*i+1, il, im, l, r),
					range_concat(2*i+2, im, ir, l, r),
					S[im-1]);
			return ret;
		}
	}
};

void solve(){
	segment_tree<P> st(N,P(),append);
	st.build();
	REP(i,Q){
		X[i]--;
		if(T[i]==1){
			st.point_update(X[i],Y[i]);
		}else if(T[i]==2){
			char new_op = (S[X[i]] == '+')? '*':'+';
			st.point_update_op(X[i],new_op);
		}else{
			auto v = st.range_concat(X[i],Y[i]);
			cout<<accumulate(v.begin(),v.end(),(mod_int)0)<<endl;
		}
	}
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
	cin >> S;
	cin >> Q;
	T.resize(Q);
	X.resize(Q);
	Y.resize(Q);
	for(int i = 0 ; i < Q ; i++){
		cin >> T[i];
		cin >> X[i];
		cin >> Y[i];
	}
	solve();
	return 0;
}

//}}}
