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

void solve(){
	int flexible = 0;
	vector<int> oxs, xos;
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
			if(start=='o')oxs.push_back(d/2);
			else xos.push_back(d/2);
		}
		i = j;
	}
	sort(ALL(oxs),greater<int>());
	sort(ALL(xos),greater<int>());
	int ox_sum = accumulate(ALL(oxs),0), xo_sum = accumulate(ALL(xos),0);
	int ox_max = flexible + ox_sum;
	int xo_max = flexible + xo_sum;
	if(A>ox_max or B>xo_max){
		cout<<NO<<endl;
	}else if(flexible + ox_sum + xo_sum - oxs.size() - xos.size() >= A+B){
		cout<<YES<<endl;
	}else{
		
	}
}

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
