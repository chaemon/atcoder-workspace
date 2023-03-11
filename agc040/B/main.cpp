#include <bits/stdc++.h>
using namespace std;

#define REP(i,n) for(int i=0;i<(int)(n);++i)

typedef long long Int;

const Int INF = 1000000000000000ll;

void solve(long long N, std::vector<long long> L, std::vector<long long> R){
	vector<pair<Int,Int> > p;
	REP(i,N)p.push_back({L[i], R[i]});
	sort(p.begin(),p.end());
	REP(i,N)L[i] = p[i].first, R[i] = p[i].second;
	Int ans = 0;
	
//	vector<pair<Int,int> > v;
//	REP(i,N)v.push_back({R[i] - L[i] + 1, i});
//	sort(v.begin(), v.end());
//	for(int vi = N - 1;vi >= N - 2;vi--){
//		int i = v[vi].second;
//		Int Lmax = -1e+12, Rmin = 1e+12;
//		REP(j, N){
//			if(i == j)continue;
//			Lmax = max(Lmax, p[j].first);
//			Rmin = min(Rmin, p[j].second);
//		}
//		
//		if(Lmax <= Rmin){
//			Int t = 0;
//			ans = max(ans, t = R[i] - L[i] + 1 + Rmin - Lmax + 1);
//		}
//	}
	
	Int Rmin = INF;
	int Rmin_count = 0;
	for(int i = 0;i < N;i++){
		if(Rmin > R[i]){
			Rmin = R[i];
			Rmin_count = 0;
		}else if(Rmin == R[i]){
			Rmin_count++;
		}
	}
	Int Lmax2 = -INF, Rmin2 = INF;
	for(int i = N - 1;i >= 0;){
		if(Rmin < L[i]){
			Lmax2 = max(Lmax2, L[i]);
			Rmin2 = min(Rmin2, R[i]);
			i--;
			continue;
		}
		int j = i;
		while(j >= 0 and L[j] == L[i]){
			j--;
		}

		if(Lmax2 < 0){
			Int max_len = -INF;
			for(int k = 0;k < N;k++){
				if(j - i == 1 and L[k] == L[i])continue;
				if(Rmin_count == 1 and R[k] == Rmin)continue;
				max_len = max(max_len, R[k] - L[k] + 1);
			}
			if(max_len >= 0)ans = max(ans, max_len + Rmin - L[i] + 1);
			Lmax2 = max(Lmax2, L[i]);
			Rmin2 = min(Rmin2, R[i]);
			i--;
			continue;
		}

		if(Rmin2 >= Lmax2)ans = max(ans, Rmin2 - Lmax2 + 1 + Rmin - L[i] + 1);
		//		ans = max(ans, Rmin2 - Lmax2 + 1 + Rmin - p[i].first + 1);
//		if(j < Rmin_id and Rmin_id <= i){
//			break;
//		}


		for(int k = i;k > j;k--){
			Lmax2 = max(Lmax2, L[k]);
			Rmin2 = min(Rmin2, R[k]);
		}

		i = j;
	}
	cout<<ans<<endl;
}

int main(){
	long long N;
	scanf("%lld",&N);
	std::vector<long long> L(N);
	std::vector<long long> R(N);
	for(int i = 0 ; i < N ; i++){
		scanf("%lld",&L[i]);
		scanf("%lld",&R[i]);
	}
	solve(N, std::move(L), std::move(R));
	return 0;
}
