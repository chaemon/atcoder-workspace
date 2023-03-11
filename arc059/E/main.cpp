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

int N;
int C;
vector<Int> A;
vector<Int> B;

//{{{ makeNdVector
template<
typename T,
		 typename U
		 >
		 static inline std::vector<U>
		 makeNdVector(T&& n, U&& val) noexcept
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<U>(std::forward<T>(n), std::forward<U>(val));
}


#if __cplusplus >= 201402L
template<
typename T,
		 typename... Args
	>
static inline decltype(auto)
	makeNdVector(T&& n, Args&&... args) noexcept
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...));
}
#else
template<
typename T,
		 typename... Args
		 >
		 static inline auto
	makeNdVector(T&& n, Args&&... args) noexcept
-> decltype(std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...)))
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...));
}
#endif
//}}}

void solve(){
	auto dp = makeNdVector(2,C+1,mod_int(0));//index, sum
	dp[0][0] = 1;
	for(int i = 0;i < N;i++){
		auto s = makeNdVector(C + 1, (mod_int)0);
		for(int x = A[i];x<=B[i];x++){
			mod_int p(1);
			for(int j = 0;j <= C;j++){
				s[j] += p;
				p *= x;
			}
		}
		dp[1].assign(C+1,mod_int(0));
		for(int c = 0;c <= C;c++){
			for(int c0 = 0;c0 <= c;c0++){
				dp[1][c] += dp[0][c-c0] * s[c0];
			}
		}
		swap(dp[0], dp[1]);
	}
	cout<<dp[0][C]<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> C;
	A.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> A[i];
	}
	B.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> B[i];
	}
	solve();
	return 0;
}

//}}}

