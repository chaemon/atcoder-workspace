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

enum STATE{
	RG,GB
};

void solve(){
	if(S.front()!='R' or S.back()!='B'){
		cout<<NO<<endl;
		return;
	}
	STATE state = RG;
	for(int i = 0;i < N;){
		if(i+2<N and S[i]=='R' and S[i+1]=='G' and S[i+2]=='B'){
			i += 3;
			state = GB;
			continue;
		}else if(i+1<N and S[i]=='G' and S[i+1]=='G'){
			cout<<NO<<endl;
			return;
		}
		if(state==GB and S[i]=='R'){
			state = RG;
		}
		if(state==RG and S[i]=='B'){
			cout<<NO<<endl;
			return;
		}
		i++;
	}
	cout<<YES<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> S;
	solve();
	return 0;
}
