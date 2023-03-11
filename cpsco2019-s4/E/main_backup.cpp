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

const string YES = "Yes";
const string NO = "No";
Int N;
string S;
Int A;
Int B;
Int C;
Int D;

bool vis[4005][4005];
int dp[4005][4005];

//maximal # of xo(B)
int calc(int i,int n){//index, # of ox
	if(i<=1){
		if(n==0)return 0;
		else return -inf<int>();
	}
	if(vis[i][n])return dp[i][n];
	vis[i][n] = true;
	int ans = calc(i-1,n);
	int j = i-1;
	if(j>=1 and S[j-1]=='o' and S[j]=='x' and n>0){
		ans = max(calc(i-2,n-1),ans);
	}else if(j>=1 and S[j-1]=='x' and S[j]=='o'){
		ans = max(calc(i-2,n)+1,ans);
	}
	if(ans<0) ans = -inf<int>();
	return dp[i][n] = ans;
//	return ans;
}

void solve(){
	if(N>4000)assert(false);
	memset(vis,false,sizeof(vis));
	int o = 0,x = 0;
	REP(i,N){
		if(S[i]=='o')o++;
		else x++;
	}
	if(o!=A+B+C or x != A+B+D){
		cout<<NO<<endl;
		return;
	}
	if(calc(N,A)>=B){
		cout<<YES<<endl;
	}else{
		cout<<NO<<endl;
	}
}

/*
void solve(){
	int flexible = 0;
	for(int i = 0;i < N;){
		char start = S[i];
		char now = start;
		int j;
		for(j = i + 1;j < N;j++){
			if(S[j]==now){
				break;
			}
			now = S[j];
		}
		int d = j - i;
		if(d%2==1){
			flexible += d/2;
		}else{
			
		}
		i = j;
	}
}
*/

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> S;
    cin >> A;
    cin >> B;
    cin >> C;
    cin >> D;
	solve();
	return 0;
}
