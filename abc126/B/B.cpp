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

int main(){
	string S;
	cin>>S;
	bool YYMM = false, MMYY = false;
	if((S[0]=='0' and S[1]!='0') or (S[1]=='1' and S[2]<='2')){
		MMYY = true;
	}
	if((S[2]=='0' and S[3]!='0') or (S[2]=='1' and S[3]<='2')){
		YYMM = true;
	}
	if(YYMM and MMYY){
		cout<<"AMBIGUOUS"<<endl;
	}else if(YYMM){
		cout<<"YYMM"<<endl;
	}else if(MMYY){
		cout<<"MMYY"<<endl;
	}else{
		cout<<"NA"<<endl;
	}
}

