#include <bits/stdc++.h>
using namespace std;
using ll = int64_t;
template<class T> inline bool chmax(T& a, T b) { if (a < b) { a = b; return 1; } return 0; }
template<class T> inline bool chmin(T& a, T b) { if (a > b) { a = b; return 1; } return 0; }
const long long INF = 1LL << 60;

int main()
{
	ll N, K;
	cin >> N >> K;

	vector<ll> a(N);
	stack<ll> b[K];
	for(ll &x : a) cin >> x;
	sort(a.begin(), a.end());
//	for(ll i = 0; i < N; i++){
//		for(ll j = 0; j < K; j++){
//			if(a[i] == 0 && b[j].empty()){
//				b[j].push(a[i]);
//				break;
//			} else if(!b[j].empty() && b[j].top() == a[i] - 1){
//				b[j].push(a[i]);
//				break;
//			}        
//		}
//	}

	vector<ll> ct(N);
	for(ll x : a)ct[x]++;
	for(ll ai = 0; ai < N; ai++){
		const ll loop_max = min(K, ct[ai]);
		for(ll j = 0; j < loop_max; j++){
			if((ai == 0) or (not b[j].empty() and b[j].top() == ai - 1)){
				b[j].push(ai);
			}else{
				break;
			}
		}
	}

	ll ans = 0;
	for(ll i = 0; i < K; i++){
		if(b[i].size() > 0){
			ans += b[i].top() + 1;
		}
	}
	cout << ans << endl;
	return 0;
}
