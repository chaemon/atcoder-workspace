#include <bits/stdc++.h>

using namespace std;

typedef long long Int;

void exit_ac(){
	cerr<<"Judge: AC"<<endl;
	exit(0);
}
void exit_wa(const string message = ""){
	cerr<<"Judge: WA"<<" ( "<<message<<" )"<<endl;
	exit(1);
}

#ifdef INTERACTIVE
const string header_prefix = "Input                 Output\n----------------------------------";
const string input_prefix  = "                      ";

string input(){
	string s;
	getline(cin,s);
	cerr<<input_prefix<<s<<endl;
	return s;
}

void output(const string &s){
	cerr<<s<<endl;
	cout<<s<<endl;
}
#endif

typedef long long Int;

Int sq(Int x){
	return x * x;
}

int main(int argc, char *argv[]){
#ifdef INTERACTIVE
	cerr<<header_prefix<<endl;
	ifstream in_s_2(argv[1]);
	while(in_s_2){
		string s;
		getline(in_s_2,s);
		cout<<s<<endl;
		cerr<<s<<endl;
	}
#endif
	ifstream in_s(argv[1]), out_s(argv[2]);
	int N;
	Int D1, D2;
	in_s>>N>>D1>>D2;
	vector<Int> x(N*N), y(N*N);
	set<pair<Int,Int> > s;
	for(int i = 0;i < x.size();i++){
		cin>>x[i]>>y[i];
	}
	for(int i = 0;i < x.size();i++){
		for(int j = i + 1;j < x.size();j++){
			Int D = sq(x[i] - x[j])+sq(y[i] - y[j]);
			if(D == D1){
				char message[100];
				sprintf(message, "the distance %lld between %d-th and %d-th is D1", D, i + 1, j + 1);
				exit_wa(message);
			}
			if(D == D2){
				char message[100];
				sprintf(message, "the distance %lld between %d-th and %d-th is D2", D, i + 1, j + 1);
				exit_wa(message);
			}

		}
	}
	exit_ac();
	assert(false);
}
