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

const string YES = "Yes";
const string NO = "No";
Int N;
Int A;
Int B;
Int C;
Int D;
string S;

void solve(){
	bool flag = false;
	if(D<C){
		for(int i = B - 1;i <= D - 1;i++){
			if(S[i]=='.' and S[i+1]=='.' and S[i+2]=='.'){
				flag = true;
			}
		}
	}else{
		flag = true;
	}
	if(!flag){
		cout<<NO<<endl;
		return;
	}
	bool valid = true;
	for(int i = A;i <= B - 1;i++){
		if(S[i]=='#' and S[i+1]=='#')valid = false;
	}
	for(int i = C;i <= D - 1;i++){
		if(S[i]=='#' and S[i+1]=='#')valid = false;
	}
	if(valid){
		cout<<YES<<endl;
	}else{
		cout<<NO<<endl;
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> A;
	cin >> B;
	cin >> C;
	cin >> D;
	cin >> S;
	A--;B--;C--;D--;
	solve();
	return 0;
}

//}}}

