#include<iostream>
#include<unordered_map>

using namespace std;

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	long long N;
	cin>>N;
	long long ans = N * (N - 1) / 2;
	unordered_map<int, int> mp;
	for(int i = 0;i < N;i++){
		int A;
		cin>>A;
		mp[A]++;
	}
	for(auto &it:mp){
		long long d = it.second;
		ans -= d * (d - 1) / 2;
	}
	cout<<ans<<endl;
	return 0;
}

