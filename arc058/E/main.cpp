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
int X;
int Y;
int Z;

const uint B = (1u<<16);

bool is_valid(uint b){
	return (b&(1<<(Z-1))) and (b&(1<<(Y+Z-1))) and (b&(1<<(X+Y+Z-1)));
}

void solve(){
	vector<vector<mod_int> > dp(N+1,vector<mod_int>(B,0));
	dp[0][0] = 1;
	mod_int ans = 0;
	for(int i=0;i<N;i++){
		for(uint b = 0;b < B;b++){
			uint b1 = ((b<<1) + 1);
			for(int d = 1;d<=10;d++, b1<<=1){
				if(is_valid(b1)){
					mod_int k = dp[i][b];
					REP(j,N-(i+1))k *= 10;
					ans += k;
				}else{
					dp[i+1][b1&(B-1)] += dp[i][b];
				}
			}
		}
	}
	cout<<ans<<endl;
}


//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> X;
	cin >> Y;
	cin >> Z;
	solve();
	return 0;
}

//}}}

