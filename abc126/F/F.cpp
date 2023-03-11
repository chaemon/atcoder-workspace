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

int M,K;

void check(const deque<int> &d){
	assert(d.size()==(1<<(M+1)));
	vector<uint> s(d.size()+1);
	unordered_map<uint,vector<int> > pos;
	s[0] = 0;
	for(int i = 0;i < d.size();i++){
		s[i+1] = s[i] ^ d[i];
		pos[d[i]].push_back(i);
	}
	for(auto &&p:pos){
		auto &&val = p.first;
		auto &&v = p.second;
		assert(0<=val and val<(1<<M));
		assert(v.size()==2);
		int i = v[0], j = v[1];
		assert((s[j+1] ^ s[i])==K);
	}
}

int main(){
	cin>>M>>K;
	if(M==0){
		if(K==0){
			cout<<0<<" "<<0<<endl;
		}else{
			cout<<-1<<endl;
		}
		return 0;
	}else if(M==1){
		if(K==0){
			cout<<0<<" "<<0<<" "<<1<<" "<<1<<endl;
		}else{
			cout<<-1<<endl;
		}
		return 0;
	}
	if(K>=(1<<M)){
		cout<<-1<<endl;
		return 0;
	}
	deque<int> d;
	d.push_back(K);
	for(int i = 0;i<(1<<M);i++){
		if(i==K)continue;
		d.push_front(i);
	}
	for(int i = 0;i<(1<<M);i++){
		if(i==K)continue;
		d.push_back(i);
	}
	d.push_back(K);
	REP(i,d.size()){
		cout<<d[i];
		if(i+1<d.size())cout<<" ";
	}
	cout<<endl;
	check(d);
	return 0;
}

