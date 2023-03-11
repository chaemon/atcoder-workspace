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
#define dump(x)  cerr << #x << " = " << (x) << endl;
#define debug(x) cerr << #x << " = " << (x) << " (L" << __LINE__ << ")" << " " << __FILE__ << endl;
#define debug_v(x) cerr << #x << " = [";REP(__ind,(x).size()){cerr << (x)[__ind] << ", ";}cerr << "] (L" << __LINE__ << ")" << endl;

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

string S;
Int M;
vector<string> P;
vector<Int> W;
vector<Int> dp;

//const uint p = 991;

struct TrieNode{
	int next[26];
	Int W;
	TrieNode():W(0){
		memset(next,-1,sizeof(next));
	}
};

vector<TrieNode> trie;

void insert(string s, Int W){
	reverse(ALL(s));
	int t = 0;
	REP(i,s.size()){
		int j = s[i] - 'a';
		int next_t;
		if(trie[t].next[j]==-1){
			next_t = trie[t].next[j] = trie.size();
			trie.push_back(TrieNode());
		}else{
			next_t = trie[t].next[j];
		}
		t = next_t;
	}
	trie[t].W = max(trie[t].W,W);
}

void solve(){
	trie.push_back(TrieNode());
	dp.resize(S.size()+1);
	REP(i,M)insert(P[i],W[i]);
	/*
	unordered_map<uint,int> x;
	REP(i,M){
		uint s = 0;
		for(int j = 0;j < P[i].size();j++){
			s *= p;
			s += P[i][j];
		}
		x[s] = i;
	}
	*/
	dp[0] = 0;
	Int ans = 0;
	for(int i = 0;i<S.size();i++){
		dp[i+1] = dp[i];
//		uint s = 0, pr = 1;
		int k = 0;
		for(int t = 0;t<=200;t++){
			int j = i - t;
			if(j<0)break;
			k = trie[k].next[S[j]-'a'];
			if(k==-1)break;
//			s += S[j] * pr;
//			pr *= p;
//			auto it = x.find(s);
			if(trie[k].W>=0){
				dp[i+1] = max(dp[i+1], dp[j] + trie[k].W);
			}
		}
//		cerr<<i<<" "<<dp[i+1]<<endl;
		ans = max(ans,dp[i+1]);
	}
	cout<<ans<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> S;
    cin >> M;
    P.resize(M);
    for(int i = 0 ; i < M ; i++){
        cin >> P[i];
    }
    W.resize(M);
    for(int i = 0 ; i < M ; i++){
        cin >> W[i];
    }
	solve();
	return 0;
}

//}}}

