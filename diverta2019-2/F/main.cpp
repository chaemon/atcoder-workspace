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

//{{{ safe_set
template<class T>
void safe_set(vector<T> &v,int i,const T &t){
	if(i>=v.size())v.resize(i+1);
	v[i]=t;
}
//}}}

//{{{ makeNdVector
template<
typename T,
		 typename U
		 >
		 static inline std::vector<U>
		 makeNdVector(T&& n, U&& val) noexcept
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<U>(std::forward<T>(n), std::forward<U>(val));
}


#if __cplusplus >= 201402L
template<
typename T,
		 typename... Args
	>
static inline decltype(auto)
	makeNdVector(T&& n, Args&&... args) noexcept
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...));
}
#else
template<
typename T,
		 typename... Args
		 >
		 static inline auto
	makeNdVector(T&& n, Args&&... args) noexcept
-> decltype(std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...)))
{
//	static_assert(std::is_integral<T>::value, "[makeNdVector] 1st argument must be an integer type");
	return std::vector<decltype(makeNdVector(std::forward<Args>(args)...))>(std::forward<T>(n), makeNdVector(std::forward<Args>(args)...));
}
#endif
//}}}

int N;

const int B = 15;
Int f[B];
Int dist[10][10];

void check(){
	unordered_map<Int,int> s;
	vector<int> a(N);
//	REP(i,N)REP(j,N)assert(i==j or 0<dist[i][j]);
	REP(i,N)a[i] = i;
	do{
		Int sum = 0;
		REP(i,N-1){
			sum += dist[a[i]][a[i+1]];
		}
		s[sum] ++;
		assert(s[sum]<=2);
		assert(sum<=1e+11);
	}while(next_permutation(ALL(a)));
}

Int dist_max(int K){
	const int B = (1<<K);
	auto dp = makeNdVector(B,K,-inf<Int>());
	REP(i,K)dp[1<<i][i] = 0;
	for(int b = 1;b < B;b++){
		REP(i,K){
			if(dp[b][i]<0)continue;
			REP(j,K){
				if(b&(1<<j))continue;
				Int &r = dp[b|(1<<j)][j];
				r = max(r,dp[b][i] + dist[i][j]);
			}
		}
	}
	Int ans = 0;
	REP(i,K)ans = max(ans,dp[B-1][i]);
	return ans;
}

void solve(){
	srand(time(NULL));
	f[0] = 1;f[1] = 2;
	for(int i = 2;i < B;i++)f[i] = f[i-1] + f[i-2] + 1;
//	Int S = 2;
	dist[0][1] = dist[1][0] = 1;
	for(int i = 2;i < N;i++){
		Int S = dist_max(i) + 1;
		dump(S);
		vector<int> v(i);
		REP(j,v.size())v[j] = j;
		random_shuffle(ALL(v));
		dump(v);
		//connect i
		for(int j = 0;j < i;j++){
			dist[v[j]][i] = dist[i][v[j]] = S * f[j];
		}
	}
	
	REP(i,N){
		REP(j,N){
//			if(i!=j)dist[i][j]++;
			cout<<dist[i][j]<<" ";
		}
		cout<<endl;
	}
	check();
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	solve();
	return 0;
}

//}}}

