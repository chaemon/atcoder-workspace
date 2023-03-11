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

vector<vector<int> > dir = {{0,1},{1,0},{0,-1},{-1,0}};

Int H;
Int W;
vector<string> A;

Int dist[1010][1010];
bool vis[1010][1010];

void solve(){
	memset(vis,false,sizeof(vis));
	queue<pii> q;
	REP(i,H)REP(j,W){
		if(A[i][j]=='#')dist[i][j] = 0,q.push({i,j});
		else dist[i][j] = inf<Int>();
	}
	Int ans = 0;
	for(;!q.empty();){
		int x = q.front().first, y = q.front().second;
		q.pop();
		if(vis[x][y])continue;
		vis[x][y] = true;
		ans = max(ans,dist[x][y]);
		for(auto &&p:dir){
			int x2 = x + p[0], y2 = y + p[1];
			if(x2<0 or H<=x2 or y2<0 or W<=y2)continue;
			if(dist[x2][y2]>dist[x][y]+1){
				dist[x2][y2] = dist[x][y] + 1;
				q.push({x2,y2});
			}
		}
	}
	cout<<ans<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> H;
    cin >> W;
    A.assign(H,string());
    for(int i = 0 ; i < H ; i++){
        cin >> A[i];
    }
	solve();
	return 0;
}
