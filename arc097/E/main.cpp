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
constexpr T inf = numeric_limits<T>::has_infinity ? numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);

int __inf_ignore(){
	int t = inf<int>;
	return t;
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

Int N;
vector<string> c;
vector<Int> a;


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

//{{{ cumulative_sum(vector<T>)
template<class T>
vector<T> cumulative_sum(const vector<T> &v){
	vector<T> ret(v.size()+1);
	ret[0] = T(0);
	for(int i = 0;i < v.size();i++){
		ret[i+1] = ret[i] + v[i];
	}
	return ret;
}
//}}}

void solve(){
	vector<vector<Int> > dp(N+1,vector<Int>(N+1,inf<Int>));
	vector<int> pos[2];
	REP(i,2)pos[i].resize(N);
	REP(i,N*2){
		if(c[i]=="W"){
			pos[0][a[i]] = i;
		}else if(c[i]=="B"){
			pos[1][a[i]] = i;
		}else{
			assert(false);
		}
	}
	dp[0][0] = 0;
	for(int i = 0;i <= N;i++){// white
		for(int j = 0;j <= N;j++){// black
			dump(i,j,dp[i][j]);
			// white
			if(i < N)dp[i+1][j] = min(dp[i][j] + abs(i+j-pos[0][i]),dp[i+1][j]);
			// black
			if(j < N)dp[i][j+1] = min(dp[i][j] + abs(i+j-pos[1][j]),dp[i][j+1]);
		}
	}
	cout<<dp[N][N]/2<<endl;
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    c.assign(2*N,string());
    a.assign(2*N,Int());
    for(int i = 0 ; i < 2*N ; i++){
        cin >> c[i];
        cin >> a[i];
		a[i]--;
    }
	solve();
	return 0;
}
//}}}
