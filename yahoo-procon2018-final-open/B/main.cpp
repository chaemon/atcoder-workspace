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

Int count_path(const vector<string> &ans){
	int N = ans.size(), M = ans[0].size();
	if(ans[0][0]=='#' or ans[N-1][M-1]=='#')return 0;
	vector<vector<Int> > dp(N,vector<Int>(M,0));
	REP(i,N)REP(j,M){
		if(i==0 and j==0)dp[i][j] = 1;
		else{
			dp[i][j] = 0;
			if(i>0 and ans[i-1][j]=='.')dp[i][j] += dp[i-1][j];
			if(j>0 and ans[i][j-1]=='.')dp[i][j] += dp[i][j-1];
		}
	}
	return dp[N-1][M-1];
}

vector<string> ans;

int build(Int K, int bx = 0, int by = 0){
	if(K<=3){
		ans[bx+1][by] = ans[bx][by+2] = '#';
		switch(K){
		case 0: ans[bx+2][by+1] = ans[bx+1][by+2] = '#';break;
		case 1: ans[bx+2][by+1] = ans[bx+2][by+2] = '#';break;
		case 2: ans[bx+2][by+1] = ans[bx+3][by+2] = '#';break;
		case 3: ans[bx+3][by+1] = ans[bx+3][by+2] = '#';break;
		default: assert(false);break;
		}
		return 4;
	}
	Int r = K%4;
//	dump(K,bx,by,r);
	int d = build(K/4,bx+3,by+3);
	d += 3;
	ans[bx+1][by] = ans[bx+2][by] = ans[bx+3][by] = '#';
	ans[bx+4][by+1] = ans[bx+4][by+2] = '#';
	ans[bx+2][by+3] = '#';
	ans[bx+2][by+d-3] = ans[bx+2][by+d-2] = '#';
	ans[bx+1][by+3] = '#';
	if(r==0){
		ans[bx][by+3] = '#';
	}else{
		for(int j = 3;j < d-r;j++){
			ans[bx+1][by+j] = '#';
		}
	}
	return d;
}

void solve(long long K){
	ans.assign(100,string(100,'.'));
	int r = build(K);
	ans.resize(r);
	REP(i,r)ans[i].resize(r);
	assert(r<=100);
	cout<<r<<" "<<r<<endl;
	REP(i,ans.size()){
		cout<<ans[i]<<endl;
	}
	Int result = count_path(ans);
	assert(result==K);
}

int main(){
	long long K;
	cin>>K;
	solve(K);
	return 0;
}
