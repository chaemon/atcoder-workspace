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

const long long MOD = 998244353;

//{{{ modular algebra
template<int mod=MOD>
struct Num{
	int v;
	Num(int n):v(n){}
	Num():v(0){}
	operator int() const {return v;}
	operator long long() const {return v;}
	template<class T>
	Num operator =(int n){v=n;return *this;}

	template<class T>
	inline void operator *=(const T &a) {
		v = (v*(long long)a)%mod;
	}
	template<class T>
	inline Num operator *(const T &a) {
		Num n(*this);n*=a;
		return n;
	}
	template<class T>
	inline void operator+=(const T &a){
		v+=(int)a;
		if(v>=mod)v-=mod;
		//	assert(0<=v and v<mod);
	}
	template<class T>
	inline Num operator+(const T &a){
		Num n(*this);n+=a;
		return n;
	}
	inline Num operator -(){
		if(v==0)return 0;
		else return Num(mod-v);
	}
	template<class T>
	inline void operator -=(const T &a){
		v-=(int)a;
		if(v<0)v+=mod;
	}
	template<class T>
	inline Num operator -(const T &a){
		Num n(*this);n-=a;
		return n;
	}

#ifdef __GCD_H
	inline Num inv(){
		return Num(invMod(this->v,mod));
	}
	template<class T>
	inline void operator /=(const T &a){
		(*this)*=invMod((int)a,mod);
	}
	template<class T>
	inline Num operator /(const T &a){
		Num n(*this);n/=a;
		return n;
	}
#endif
};

template<int mod=MOD>
int abs(Num<mod> &a){
	return a.v;
}
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

//{{{ mod_pow(Num<mod> x,Int k)
/* (x^k)%m */
template<int mod=MOD>
inline Num<mod> mod_pow(Num<mod> x, Int k){
	if(k==0) return 1;
	Num<mod> res(mod_pow(x,k/2));
	res*=res;
	if(k%2)res*=x;
	return res;
}
//}}}

Int N;
Int M;
vector<vector<Int>> a;

//{{{ matrix library: MATRIX<T> A(n); MATRIX<T> A(n,m); VECTOR<T> v(n);
template<class T>
struct VECTOR:public vector<T>{
	const int &n;
	VECTOR(const int &n):n(n){
		this->assign(n,0);
	}
};

// O( n )
template<class T>
T inner_product(const VECTOR<T> &a, const VECTOR<T> &b) {
	T ans = 0;
	for (int i = 0; i < a.n; ++i)
		ans += a[i]*b[i];
	return ans;
}

template<class T>
struct MATRIX:vector<vector<T> > {
	const int &n,&m;
	MATRIX(const int &n):n(n),m(n){
		this->assign(n,vector<T>(n,0));
	}
	MATRIX(const pair<int,int> &p):n(p.first),m(p.second){
		this->assign(n,vector<T>(m,0));
	}
	// O( n )
	void operator+=(const MATRIX<T> &B){
		REP(i,n)REP(j,m)(*this)[i][j] += B[i][j];
	}
	void operator-=(const MATRIX<T> &B){
		REP(i,n)REP(j,m)(*this)[i][j] -= B[i][j];
	}
};

template<class T>
MATRIX<T> identity(int n) {
	MATRIX<T> A(n);
	for (int i = 0; i < n; ++i) A[i][i] = 1;
	return A;
}

template<class T>
MATRIX<T> zero(int n) {
	MATRIX<T> A(n);
	return A;
}

template<class T>
MATRIX<T> operator+(const MATRIX<T> &A, const MATRIX<T> &B) {
	MATRIX<T> C{A};
	C+=B;
	return C;
}
template<class T>
MATRIX<T> operator-(const MATRIX<T> &A, const MATRIX<T> &B) {
	MATRIX<T> C{A};
	C-=B;
	return C;
}
// O( n^2 )
template<class T>
VECTOR<T> operator*(const MATRIX<T> &A, const VECTOR<T> &x) {
	VECTOR<T> y(A.n);
	for (int i = 0; i < A.n; ++i)
		for (int j = 0; j < A.m; ++j)
			y[i] += T(A[i][j])*x[j];
	return y;
}
// O( n^3 )
template<class T>
MATRIX<T> operator*(const MATRIX<T> &A, const MATRIX<T> &B) {
	MATRIX<T> C({A.n,B.m});
	for (int i = 0; i < C.n; ++i)
		for (int j = 0; j < C.m; ++j)
			for (int k = 0; k < A.m; ++k)
				C[i][j] += T(A[i][k])*B[k][j];
	return C;
}
// O( n^3 )
template<class T>
void operator*=(MATRIX<T> &A, const MATRIX<T> &B){
	A = A*B;
}

// O( n^3 log e )
template<class T>
MATRIX<T> pow(const MATRIX<T> &A, long long e) {
	return e == 0 ? identity<T>(A.size())  :
	e % 2 == 0 ? pow(A*A, e/2) : A*pow(A, e-1);
}

typedef int Number;
typedef MATRIX<Number> Matrix;
typedef VECTOR<Number> Vector;

//}}}

//{{{ gauss
template<class T>
int gauss(MATRIX<T> &A, VECTOR<T> &b) {
	//int gauss(& A) {//returns rank
	const int n = A.size(), m = A[0].size();
	int pi = 0;
	for(int pj = 0;pj < m;pj++){
		for(int i = pi+1; i < n; i++) {
			if (abs(A[i][pj]) > abs(A[pi][pj])) {
				swap(A[i], A[pi]);
				swap(b[i], b[pi]);
			}
		}
		if (abs(A[pi][pj]) > 0) {
			T d = A[pi][pj];//1/A[pi][pj]
			REP(j, m)A[pi][j] *= d;
			b[pi] *= d;
			REP(i,n){
				if(i==pi)continue;
				T k = A[i][pj];
				REP(j, m) A[i][j] -= k * A[pi][j];
				b[i] -= k * b[pi];
			}
			pi++;
		}
		if(pi==N)break;
	}
	return pi;
	/*
	   for(int i = pi; i < n; i++)
	   if (abs(b[i]) > 0)
	   throw Inconsistent();
	   if (pi < m || pj < m)
	   throw Ambiguous();
	   for(int j = m-1; j >= 0; j--)
	   REP(i, j)
	   b[i] = modulo(b[i] - b[j] * A[i][j]);
	   */
}
//}}}

void solve(){
	MATRIX<Num<2> > a2({N,M});
	VECTOR<Num<2> > b(N);
	REP(i,N)REP(j,M)a2[i][j] = a[i][j];
	int t = gauss(a2,b);
	/*
	REP(i,a2.size()){
		REP(j,a2[0].size()){
			cout<<a2[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<t<<endl;
	*/
	mod_int ans = mod_pow((mod_int)2,N) - mod_pow((mod_int)2,N-t);
	ans *= mod_pow((mod_int)2,M-1);
	cout<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> M;
	a.assign(N, vector<Int>(M));
	for(int i = 0 ; i < N ; i++){
		for(int j = 0 ; j < M ; j++){
			cin >> a[i][j];
		}
	}
	solve();
	return 0;
}

//}}}

