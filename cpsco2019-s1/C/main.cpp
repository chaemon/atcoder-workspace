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

Int N;
Int K;
vector<Int> A;

vector<Int> coins;

Int num_coins(Int x){
	Int ret = 0;
	for(auto &&c:coins){
		ret += x/c;
		x%=c;
	}
	assert(x==0);
	return ret;
}

//{{{ next_combination
template < class BidirectionalIterator >
inline bool next_combination ( BidirectionalIterator first1 ,
		BidirectionalIterator last1 ,
		BidirectionalIterator first2 ,
		BidirectionalIterator last2 ){
	if (( first1 == last1 ) || ( first2 == last2 )) {
		return false ;
	}
	BidirectionalIterator m1 = last1 ;
	BidirectionalIterator m2 = last2 ; --m2;
	while (--m1 != first1 && !(* m1 < *m2 )){
	}
	bool result = (m1 == first1 ) && !(* first1 < *m2 );
	if (! result ) {
		while ( first2 != m2 && !(* m1 < * first2 )) {
			++ first2 ;
		}
		first1 = m1;
		iter_swap (first1 , first2 );
		++ first1 ;
		++ first2 ;
	}
	if (( first1 != last1 ) && ( first2 != last2 )) {
		m1 = last1 ; m2 = first2 ;
		while (( m1 != first1 ) && (m2 != last2 )) {
			iter_swap (--m1 , m2 );
			++ m2;
		}
		reverse (first1 , m1 );
		reverse (first1 , last1 );
		reverse (m2 , last2 );
		reverse (first2 , last2 );
	}
	return ! result ;
}

template < class BidirectionalIterator >
inline bool next_combination ( BidirectionalIterator first ,
		BidirectionalIterator middle ,
		BidirectionalIterator last ){
	return next_combination (first , middle , middle , last );
}
template < class BidirectionalIterator >
inline bool prev_combination ( BidirectionalIterator first ,
		BidirectionalIterator middle ,
		BidirectionalIterator last ){
	return next_combination (middle , last , first , middle );
}
//}}}

void solve(){
	for(int i = 0;i<=9;i++){
		coins.push_back(pow(10.0L,i));
		coins.push_back(pow(10.0L,i)*5);
	}
	sort(ALL(coins),greater<Int>());
	vector<int> v;
	REP(i,N)v.push_back(i);
	Int ans = inf<Int>();
	do{
		Int s = 0;
		REP(i,K){
			s += A[v[i]];
		}
		ans = min(ans,num_coins(s));
	}while(next_combination(v.begin(),v.begin()+K,v.end()));
	cout<<ans<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
    A.resize(N);
    for(int i = 0 ; i < N ; i++){
        cin >> A[i];
    }
	solve();
	return 0;
}

//}}}

