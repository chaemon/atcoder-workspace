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

typedef unsigned char UC;

int H,W;
vector<string> A;

const int B = 185*(185+1)/2;
UC dp[B][B];
UC ri[185][185], ci[185][185];

UC get(int i,int j,int k,int l){//i<=j and k<=l
	if(j>i or k>l)return inf<UC>();
	//assert(i<=j and k<=l)
	return dp[j*(j+1)/2+i][l*(l+1)/2+k];
}

void set_val(int i,int j,int k,int l, UC t){
	dp[j*(j+1)/2+i][l*(l+1)/2+k] = t;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	cin>>H>>W;
	A.resize(H);
	REP(i,H)cin>>A[i];
	
	memset(dp,0,sizeof(dp));
	
	REP(i_max,H){
		REP(j_max,W){
			//row
			for(int j=0;j<=j_max;j++){
				int ri_ = i_max;
				ri[i_max][j] = ri_;
				for(int i = i_max - 1;i>=0;i--){
					UC a0 = get(i,ri_,j,j_max), a1 = get(ri_+1,i_max,j,j_max);
					if(a0<a1)
					
					
					ri[i][j] = ri_;
				}
			}
			
			
			//col
			
			
			for(int i = 0;i<=i_max;i++){
				for(int j = 0;j<=j_max;j++){
					int rid = ri[i][j], cid = ci[i][j];
					UC c = max(get(i,rid,j,j_max),get(rid+1,i_max,j,j_max));
					UC r = max(get(i,i_max,j,cid),get(i,i_max,cid+1,j_max));
					set_val(i,i_max,j,j_max, min(c,r) + 1);
				}
			}
		}
	}
	cout<<(int)get(0,0,H-1,W-1)<<endl;
	return 0;
}
