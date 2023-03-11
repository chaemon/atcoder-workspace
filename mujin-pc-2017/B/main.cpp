#include<iostream>

using namespace std;

const int INF = 1000000000;

int N;
char A[555][555];
int row_count[555], col_count[555];

int main(){
	cin>>N;
	for(int i=0;i<N;i++)cin>>A[i];
	for(int i=0;i<N;i++){
		row_count[i] = 0;
		for(int j=0;j<N;j++)row_count[i] += (A[i][j]=='#');
	}
	for(int j=0;j<N;j++){
		col_count[j] = 0;
		for(int i=0;i<N;i++)col_count[j] += (A[i][j]=='#');
	}
	int full_col = 0;
	bool valid = false;
	for(int j=0;j<N;j++){
		if(col_count[j]==N)full_col++;
		if(col_count[j] > 0)valid = true;
	}
	if(not valid){
		cout<<-1<<endl;
		return 0;
	}
	if(full_col==N){
		cout<<0<<endl;
		return 0;
	}
	int ans = INF;
	for(int i=0;i<N;i++){
		int a = 0;
		if(col_count[i] == 0)a++;
		a += min(ans,N-full_col+N-row_count[i]);
		ans = min(ans, a);
	}
	cout<<ans<<endl;
	return 0;
}

