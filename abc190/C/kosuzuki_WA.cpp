#include <bits/stdc++.h>
using namespace std;
using ll = int64_t;

int main()
{
	ll N, M;
	cin >> N >> M;

	vector<ll> A(M), B(M);
	for(int i = 0; i < M; i++){
		cin >> A[i] >> B[i];
	}

	ll K;
	cin >> K;
	vector<ll> C(K), D(K);
	for(int i = 0; i < K; i++){
		cin >> C[i] >> D[i];
	}

	int ans = 0;
	for(int bit = 0; bit < 1 << K; bit++){
		vector<bool> ball(N + 1);
		for(int i = 0; i < K; i++){
			ball[bit & 1 << i ? C[i] : D[i]] = 1;
		}

		int cnt = 0;
		for(int i = 0; i < M; i++){
			if(ball[A[i]] and ball[B[i]]) cnt++;
		}

		if(cnt > ans) ans = cnt;
	}

	cout << ans << endl;
	return 0;
}
