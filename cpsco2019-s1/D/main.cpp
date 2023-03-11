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

const int MOD = 1000000007;
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

//{{{ matrix library: mat<T> A(n); mat<T> A(n,m); vec<T> v(n);
template<class T>
struct vec:public vector<T>{
	int n;
	vec(int n):n(n){
		this->assign(n,0);
	}
};

// O( n )
template<class T>
T inner_product(const vec<T> &a, const vec<T> &b) {
	T ans = 0;
	for (int i = 0; i < a.n; ++i)
		ans += a[i]*b[i];
	return ans;
}

template<class T>
struct mat:vector<vector<T> > {
	const int n,m;
	mat(int n):n(n),m(n){
		this->assign(n,vector<T>(n,0));
	}
	mat(const pair<int,int> &p):n(p.first),m(p.second){
		this->assign(n,vector<T>(m,0));
	}
	// O( n )
	void operator+=(const mat<T> &B){
		REP(i,n)REP(j,m)(*this)[i][j] += B[i][j];
	}
	void operator-=(const mat<T> &B){
		REP(i,n)REP(j,m)(*this)[i][j] -= B[i][j];
	}
};

template<class T>
mat<T> identity(int n) {
	mat<T> A(n);
	for (int i = 0; i < n; ++i) A[i][i] = 1;
	return A;
}

template<class T>
mat<T> zero(int n) {
	mat<T> A(n);
	return A;
}

template<class T>
mat<T> operator+(const mat<T> &A, const mat<T> &B) {
	mat<T> C{A};
	C+=B;
	return C;
}
template<class T>
mat<T> operator-(const mat<T> &A, const mat<T> &B) {
	mat<T> C{A};
	C-=B;
	return C;
}
// O( n^2 )
template<class T>
vec<T> operator*(const mat<T> &A, const vec<T> &x) {
	vec<T> y(A.n);
	for (int i = 0; i < A.n; ++i)
		for (int j = 0; j < A.m; ++j)
			y[i] += T(A[i][j])*x[j];
	return y;
}
// O( n^3 )
template<class T>
mat<T> operator*(const mat<T> &A, const mat<T> &B) {
	mat<T> C({A.n,B.m});
	for (int i = 0; i < C.n; ++i)
		for (int j = 0; j < C.m; ++j)
			for (int k = 0; k < A.m; ++k)
				C[i][j] += T(A[i][k])*B[k][j];
	return C;
}
// O( n^3 )
template<class T>
void operator*=(mat<T> &A, const mat<T> &B){
	A = A*B;
}

// O( n^3 log e )
template<class T>
mat<T> pow(const mat<T> &A, long long e) {
	return e == 0 ? identity<T>(A.size())  :
		e % 2 == 0 ? pow(A*A, e/2) : A*pow(A, e-1);
}
//}}}

typedef mod_int Number;
typedef mat<Number> Matrix;
typedef vec<Number> Vector;


Int N;

void solve(){
	Matrix A(3);;
	REP(i,3){
		REP(j,3){
			if(i==j)A[i][j] = (mod_int)0;
			else A[i][j] = (mod_int)1;
		}
	}
	Matrix B(A);
	REP(j,3)B[2][j] = 0;
	Vector b(3);
	b[0] = b[1] = 1;
	b[2] = 0;
	b = A*b;
	b = A*b;
	b = pow(A*A*B,N-1)*b;
	cout<<b[0] + b[1] + b[2]<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	solve();
	return 0;
}

//}}}

