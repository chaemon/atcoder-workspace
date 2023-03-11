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

const string YES = "YES";
const string NO = "NO";
Int H;
Int W;
Int N;
Int s_r;
Int s_c;
string S;
string T;

void solve(){
	int up = s_r, bottom = s_r;
	REP(i,N){
		if(S[i]=='U')up--;
		else if(S[i]=='D')bottom++;
		if(up<1 or bottom>H){
			cout<<NO<<endl;
			return;
		}
		if(T[i]=='U'){
			if(bottom>1)bottom--;
		}else if(T[i]=='D'){
			if(up<H)up++;
		}
//		if(up>bottom)swap(up,bottom);
	}
	int left = s_c, right = s_c;
	REP(i,N){
		if(S[i]=='L')left--;
		else if(S[i]=='R')right++;
		if(left<1 or right>W){
			cout<<NO<<endl;
			return;
		}
		if(T[i]=='L'){
			if(right>1)right--;
		}else if(T[i]=='R'){
			if(left<W)left++;
		}
//		if(left>right)swap(left,right);
	}
	cout<<YES<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> H;
    cin >> W;
    cin >> N;
    cin >> s_r;
    cin >> s_c;
    cin >> S;
    cin >> T;
	solve();
	return 0;
}
