#include <bits/stdc++.h>
using namespace std;


void solve(long long N, std::vector<long long> A){
	const int B = 2000001;
	bitset<B> bs;
	bs.set(0);
	long long S = 0;
	for(int i = 0;i < N;i++){
		bs |= (bs << A[i]);
		S += A[i];
	}
	for(int s = S/2;s>=0;s--){
		if(bs.test(s)){
			cout<< S - s<<endl;
			return;
		}
	}
}

// Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
int main(){
    long long N;
    scanf("%lld",&N);
    std::vector<long long> A(N);
    for(int i = 0 ; i < N ; i++){
        scanf("%lld",&A[i]);
    }
    solve(N, std::move(A));
    return 0;
}
