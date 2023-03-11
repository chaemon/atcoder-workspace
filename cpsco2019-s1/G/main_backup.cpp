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

Int N;
vector<Int> A;

vector<unordered_map<Int,Int> > dp;

Int calc(int i,Int X){
	if(i==N)return 0;
	auto it = dp[i].find(X);
	if(it!=dp[i].end()){
		return it->second;
	}
	Int ans = 0;
	//do
	if(X<=A[i]){
		Int Y = A[i]/X;
		ans = max(Y + calc(i+1,Y),ans);
	}
	//do nothing
	ans = max(calc(i+1,X),ans);
	return dp[i][X] = ans;
}

void solve(){
	dp.resize(N);
	Int ans = 0;
	for(Int X = 1;X<=A[0];X++){
		ans = max(ans,calc(0,X));
	}
	/*
	for(Int X0 = 1;X0 <= 1000;X0++){
		Int X = X0;
		Int S = 0;
		REP(i,N){
			if(X>A[i])continue;
			Int Y = A[i]/X;
			S += Y;
			X = Y;
		}
		ans = max(ans,S);
	}
	dump(ans);
	for(Int Y0 = 1;Y0 <= 1000;Y0++){
		Int Xmax = A[0]/Y0, Xmin = A[0]/(Y0+1) + 1;
		if(Xmin>Xmax)continue;
		Int X = Y0, S = Y0;
		RREP(i,1,N){
			Int Y = A[i]/X;
			S += Y;
			X = Y;
		}
		ans = max(ans,S);
	}
	*/
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

