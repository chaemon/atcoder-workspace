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

vector<Int> A;
vector<Int> B;
vector<Int> C;

//{{{ optional<T>
template<typename T>
class optional {
public:
	optional() : is_engaged_(false), value_() {}

	explicit optional(T const& value) :
		is_engaged_(true), value_(value) {}
	

	T& operator=(T const& value) {
		value_ = value;
		is_engaged_ = true;
		return value_;
	}

	operator bool() const { return is_engaged_; }

	T const& operator*() const { return value_; }
	T& operator*() { return value_; }
private:
	bool is_engaged_;
	T value_;
};
//}}}

bool vis[11][11][11][11][11][11];
rn result[11][11][11][11][11][11];

rn calc(int i,int j,int k,int l,int m,int n){
	if(i<0 or j<0 or k<0 or l<0 or m<0 or n<0)return 0.0L;
	auto &r = result[i][j][k][l][m][n];
	if(vis[i][j][k][l][m][n])return r;
	vis[i][j][k][l][m][n] = true;
	if(i==0 and j==0 and k==0 and l==0 and m==0 and n==0){
		r = 0;
		return r;
	}
	rn S = (i + k + m)*100.0L + (j + l + n)*50.0L;
	rn ans = -inf<rn>();
	if(i+j>0){
		rn p = i/(rn)(i+j);
		ans = max(ans,
			p*(S - calc(i-1,j,k,l,m,n))  + (1.0L-p)*(S - calc(i,j-1,k,l,m,n))
			 );
	}
	if(k+l>0){
		rn p = k/(rn)(k+l);
		ans = max(ans,
			p*(S - calc(i,j,k-1,l,m,n)) + (1.0L-p)*(S - calc(i,j,k,l-1,m,n))
			 );
	}
	if(m+n>0){
		rn p = m/(rn)(m+n);
		ans = max(ans,
			p*(S - calc(i,j,k,l,m-1,n)) + (1.0L-p)*(S - calc(i,j,k,l,m,n-1))
			 );
	}
//	cerr<<i<<" "<<j<<" "<<k<<" "<<l<<" "<<m<<" "<<n<<" "<<ans<<endl;
	r = ans;
	return r;
}

void solve(){
	memset(vis,false,sizeof(vis));
	rn r = calc(A[0],A[1],B[0],B[1],C[0],C[1]);
	cout<<fixed<<setprecision(10)<<r<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	A.resize(2);
    for(int i = 0 ; i < 2 ; i++){
        cin >> A[i];
    }
    B.resize(2);
    for(int i = 0 ; i < 2 ; i++){
        cin >> B[i];
    }
    C.resize(2);
    for(int i = 0 ; i < 2 ; i++){
        cin >> C[i];
    }
	solve();
	return 0;
}

//}}}

