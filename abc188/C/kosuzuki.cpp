#include <bits/stdc++.h>
using namespace std;
using ll = int64_t;

int main()
{
	int N;
	ll ans; 
	cin >> N;
	ll num = 1LL << N;

	vector<ll> A(num), tmp1(num), tmp2(num);
	vector<ll>::iterator iter;
	for(ll i = 0; i < num; i++){
		cin >> A.at(i);
		tmp1.at(i) = A.at(i);
	}

	if(N == 1){
		iter  = find(A.begin(), A.end(), min(A.at(0), A.at(1)));
		ans = distance(A.begin(), iter);
		cout << ans + 1 << endl;
		return 0;
	}

	for(int i = 0; i < N; i++){
		int cnt = N - i - 1; 
		ll num_tmp = 1LL << cnt;
		if(cnt == 0) {
			iter  = find(A.begin(), A.end(), min(tmp1.at(0), tmp1.at(1)));
			break;
		}

		for(ll j = 0; j < num_tmp; j++){
			tmp2.at(j) = max(tmp1.at(2*j), tmp1.at(2*j+1));
		}
		swap(tmp1, tmp2);
	}
	ans = distance(A.begin(), iter);
	cout << ans + 1 << endl;

	return 0;
}
