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

#define INTERACTIVE
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
	//write code
	int N;
	string ans;
	in_s >> N;
	out_s >> ans;
	int ct = 0;
	while(true){
		string q = input();
		if(q[0] == '?'){
			ct++;
			if(ct>210)break;
			q = q.substr(2,q.size() - 2);
			stringstream ss(q);
			int red_ct = 0, blue_ct = 0;
			for(int i = 0;i < N;i++){
				int v;
				ss>>v;
				v--;
				if(ans[v]=='R')red_ct++;
				else if(ans[v]=='B')blue_ct++;
				else assert(false);
			}
			if(red_ct > blue_ct){
				output("Red");
			}else if(red_ct < blue_ct){
				output("Blue");
			}else{
				output("-1");
			}
		}else if(q[0] == '!'){
			q = q.substr(2,q.size() - 2);
			if(q.size()!=2*N){
				exit_wa("Invalid answer length");
			}else{
				for(int i = 0;i < 2*N;i++){
					if(ans[i] != q[i])exit_wa("wrong answer: " + q);
				}
			}
			exit_ac();
		}else{
			exit_wa("Invalid query");
		}
	}
	exit_wa("too many queries");
	assert(false);
}
