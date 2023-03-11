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
Int R;
Int C;
Int N;
vector<Int> r;
vector<Int> c;
vector<Int> a;


//{{{ optional<T>
template<typename T>
class optional {
public:
	optional() : is_engaged_(false), value_() {}

	explicit optional(T const& value) :
		is_engaged_(true), value_(value) {}

	optional& operator=(T const& value) {
		value_ = value;
		is_engaged_ = true;
		return *this;
	}

	operator bool() const { return is_engaged_; }

	T const& operator*() const { return value_; }
	T& operator*() { return value_; }
private:
	bool is_engaged_;
	T value_;
};

template <class T, class U>
constexpr bool operator==(const optional<T>& x, const optional<U>& y){
	if(!x and !y)return true;
	if(x and y)return *x == *y;
	else return false;
}

template <class T, class U>
constexpr bool operator==(const optional<T>& x, const U& y){
	if(!x)return false;
	else return *x == y;
}
template <class T, class U>
constexpr bool operator==(const U& x, const optional<T>& y){
	if(!y)return false;
	else return x == *y;
}
template <class T, class U>
constexpr bool operator!=(const optional<T>& x, const optional<U>& y){
	return not (x!=y);
}

template <class T, class U>
constexpr bool operator!=(const optional<T>& x, const U& y){
	return not (x!=y);
}
template <class T, class U>
constexpr bool operator!=(const U& x, const optional<T>& y){
	return not (x!=y);
}

//}}}

void solve(){
	vector<optional<Int> > v(R+C);
	unordered_map<int,vector<pair<int,Int> > > mp;
	REP(i,N){
		mp[r[i]].push_back({R + c[i], a[i]});
		mp[R+c[i]].push_back({r[i],a[i]});
	}
	Int row_min, col_min;
	function<bool(int,Int,int) > dfs = [&](int u, Int t, int prev){
		if(v[u]){
			if(v[u]==t)return true;
			else return false;
		}
		v[u] = t;
		if(u<R)row_min = min(row_min,t);
		else col_min = min(col_min,t);
		for(auto &&p:mp[u]){
			if(p.first==prev)continue;
			if(!dfs(p.first,p.second - t,u))return false;
		}
		return true;
	};
	REP(u,R+C){
		if(!v[u]){
			row_min = col_min = inf<Int>();
			if(!dfs(u,0,-1) or row_min + col_min < 0){
				cout<<NO<<endl;
				return;
			}
		}
	}
	cout<<YES<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> R;
	cin >> C;
	cin >> N;
	r.assign(N,Int());
	c.assign(N,Int());
	a.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> r[i];
		cin >> c[i];
		cin >> a[i];
		r[i]--;c[i]--;
	}
	solve();
	return 0;
}

//}}}

