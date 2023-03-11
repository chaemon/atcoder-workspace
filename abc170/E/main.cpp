#include <bits/stdc++.h>
using namespace std;


long long N;
long long Q;
std::vector<long long> A;
std::vector<long long> B;
std::vector<long long> C;
std::vector<long long> D;

const int M = 200000;

void solve(){
	multiset<int> s;// minus
	vector<multiset<int> > rates(M);
	vector<multiset<int>::iterator> v(N);
	vector<multiset<int>::iterator> w(M);
	for(int i = 0;i < N; i++){
		v[i] = rates[B[i]].insert(-A[i]);
	}
	for(int j = 0;j < M; j++){
		if(rates[j].size() > 0){
			int h = - *rates[j].begin();
			w[j] = s.insert(h);
		}else{
			w[j] = s.insert(2000000000);//dummy
		}
	}
	for(int q = 0;q < Q; q++){
		int i = C[q];
		//B[i] -> D[q]
//		cout<<B[i]<<" -> "<<D[q]<<endl;
		rates[B[i]].erase(v[i]);
		s.erase(w[B[i]]);
		if(rates[B[i]].size() > 0){
			int h = - *rates[B[i]].begin();
			w[B[i]] = s.insert(h);
		}else{
			w[B[i]] = s.insert(2000000000);//dummy
		}
		s.erase(w[D[q]]);
		v[i] = rates[D[q]].insert(-A[i]);
		int h = - *rates[D[q]].begin();
		w[D[q]] = s.insert(h);
		cout<<*s.begin()<<endl;
		/*
		for(int i = 0;i < M;i++){
			if(rates[i].size() > 0){
				cout<<"i: "<<endl;
				for(auto &&it:rates[i]){
					cout<<it.first<<" "<<it.second<<", ";
				}
				cout<<endl;
			}
		}
		*/
		B[i] = D[q];
	}
}

// Generated by 1.1.7 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
int main(){
	std::cin >> N;
	std::cin >> Q;
	A.assign(N, 0);
	B.assign(N, 0);
	for(int i = 0 ; i < N ; i++){
		std::cin >> A[i];
		std::cin >> B[i];
		B[i]--;
	}
	C.assign(Q, 0);
	D.assign(Q, 0);
	for(int i = 0 ; i < Q ; i++){
		std::cin >> C[i];
		std::cin >> D[i];
		C[i]--;
		D[i]--;
	}
	solve();
	return 0;
}
