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

//{{{ gcd and inverse
#define __GCD_H
Int gcd(Int a, Int b) {
	return b != 0 ? gcd(b, a % b) : a;
}
Int lcm(Int a, Int b) {
	return a / gcd(a, b) *b;
}
// a x + b y = gcd(a, b)
Int extgcd(Int a, Int b, Int &x, Int &y) {
	Int g = a; x = 1; y = 0;
	if (b != 0) g = extgcd(b, a % b, y, x), y -= (a / b) * x;
	return g;
}
Int invMod(Int a, Int m) {
	Int x, y;
	if (extgcd(a, m, x, y) == 1) return (x + m) % m;
	else                         return 0; // unsolvable
}
//}}}

Int A;
Int B;
Int C;
Int D;

void solve(){
	A--;
	Int S = 0;
	S += B/C - A/C;
	S += B/D - A/D;
	Int E = C*D/gcd(C,D);
	S -= B/E - A/E;
	S = B - A - S;
	cout<<S<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> A;
    cin >> B;
    cin >> C;
    cin >> D;
	solve();
	return 0;
}

//}}}

