#include <bits/stdc++.h>
using namespace std;

int N;
std::vector<int> A;

bool f(int K){
	map<int,int> m;
	auto inc = [&](int p){
		while(true){
			m[p]++;
			if(m[p] < K) return true;
			assert(m[p] == K);
			m[p] = 0;
			p--;
			if(p < 0)return false;
		}
	};
	for(int i = 0;i < N;i++){
		auto it = m.lower_bound(A[i]);
		m.erase(it, m.end());
		if(not inc(A[i] - 1))return false;
		for(auto it:m){
			cout<<it.first<<":"<<it.second<<"  ";
		}
		cout<<endl;
	}
	return true;
}

void solve(){
	if(f(1)){
		cout<<1<<endl;
		return;
	}
	int l = 1, r = N;
	while(r - l > 1){
		int m = (l + r) / 2;
		if(f(m)){
			r = m;
		}else{
			l = m;
		}
	}
	cout<<r<<endl;
}

// Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
int main(){
    std::cin >> N;
    A.assign(N, 0);
    for(int i = 0 ; i < N ; i++){
        std::cin >> A[i];
    }
    solve();
    return 0;
}
