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
constexpr T inf = numeric_limits<T>::has_infinity ? numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);

int __inf_ignore(){
	int t = inf<int>;
	return t;
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

int N;
int K;

const int B = 32000;
//const int B = 5;

const int MOD = 1000000007;
//{{{ Modular algebra, Mint
struct Mint{
	int v;
	template<class T>
	Mint(T n){
		v = n%MOD;
		if(v<0)v+=MOD;
	}
	Mint():v(0){}
	explicit operator int() const {return v;}
	explicit operator long long() const {return v;}
	inline void operator *=(const Mint &a) {
		v = (v*(long long)a.v)%MOD;
	}
	inline Mint operator *(const Mint &a) {
		Mint n(*this);n*=a;
		return n;
	}
	inline void operator+=(const Mint &a){
		v+=a.v;
		if(v>=MOD)v-=MOD;
		//	assert(0<=v and v<MOD);
	}
	inline Mint operator+(const Mint &a){
		Mint n(*this);n+=a;
		return n;
	}
	inline Mint operator -(){
		if(v==0)return 0;
		else return Mint(MOD-v);
	}
	inline void operator -=(const Mint &a){
		v-=a.v;
		if(v<0)v+=MOD;
	}
	inline Mint operator -(const Mint &a){
		Mint n(*this);n-=a;
		return n;
	}
#ifdef __GCD_H
	inline Mint inv(){
		return Mint(invMOD(this->v,MOD));
	}
	inline void operator /=(const Mint &a){
		(*this)*=invMOD(a.v,MOD);
	}
	inline Mint operator /(const Mint &a){
		Mint n(*this);n/=a;
		return n;
	}
#endif
};

template<class T>
T& operator <<(T &os, const Mint &n){
	os<<(int)n.v;
	return os;
}

template<class T>
T& operator >>(T &is, Mint &n){
	long long v;is >> v;
	n = Mint(v);
	return is;
}
//}}}

Mint dp[110][B];//dp[i+1][Y]:  x[i]==Y
Mint s[110][B+1];
Mint dp2[110][B];//dp[i+1][Y]:  x[i-1]==Y
Mint s2[110][B+1];

void naive3(){
	const int T = 100;
	vector<int> v(T+1);
	for(int a = 1;a <= T;a++){
		for(int b = 1;b <= T;b++){
			for(int c = 1;c <= T;c++){
				if(a*b<=N and b*c<=N)v[c]++;
			}
		}
	}
	cerr<<"naive result: "<<endl;
	for(int c = 1;c<=20;c++){
		cerr<<v[c]<<" ";
	}
	cerr<<endl;
	return;
}

void solve(){
	memset(dp,0,sizeof(dp));
	memset(s,0,sizeof(dp));
	memset(dp2,0,sizeof(dp));
	memset(s2,0,sizeof(dp));
	dp[0][1] = 1;

	for(int i = 0;i < K;i++){
		s[i][0] = 0;
		for(int j = 0;j + 1 <= B;j++){
			s[i][j+1] = s[i][j] + dp[i][j];
		}
		s2[i][B] = 0;
		for(int j = B;j - 1 >= 0;j--){
			s2[i][j-1] = s2[i][j] + dp2[i][j-1];
		}
		/*
		for(int j = 0; j <= B;j++){
			cerr<<s2[i][j-1]<<" ";
		}
		cerr<<endl;
		*/
		for(int Y = 1;Y < B;Y++){
//			bool opt = false;
//			if(i==2 and Y==1)opt = true;
			int T = N/Y - B + 1;
			// set dp[i+1][Y]
			if(i-1>=0 and T>=0){
				dp[i+1][Y] += s[i-1][Y+1] * T;
//				if(opt)dump(dp[i+1][Y],T,Y);
				dp[i+1][Y] += s2[i][Y+1];
//				if(opt)dump(dp[i+1][Y],s2[i-1][Y+1]);
			}
			int k = min(N/Y,B-1);
			dp[i+1][Y] += s[i][k+1];
//			if(opt)dump(dp[i+1][Y]);
			// set dp2[i+1][Y]
			if(T>=0)dp2[i+1][Y] = dp[i][Y] * T;
			else dp2[i+1][Y] = 0;
		}
		/*
		for(int Y = 1;Y < min(20,B);Y++){
			cerr<<dp[i+1][Y]<<" ";
		}
		cerr<<endl;
		for(int Y = 1;Y < min(20,B);Y++){
			cerr<<dp2[i+1][Y]<<" ";
		}
		cerr<<endl;
		*/
	}
	Mint ans = 0;
	for(int Y = 1; Y < B;Y++){
		ans += dp[K][Y];
		ans += dp2[K][Y];
	}
	cout<<ans<<endl;
//	naive3();
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> K;
	solve();
	return 0;
}
//}}}
