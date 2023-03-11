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
	int K;
	long long X, Y;
	in_s >> K >> X >> Y;
	int s, out_s_val;
	out_s >> out_s_val;
	cin>>s;
	if(out_s_val == -1){
		if(s == -1)exit_ac();
		else exit_wa("-1 is expected but not");
	}
	Int x_prev = 0, y_prev = 0;
	Int x, y;
	for(int i = 0;i < s;i++){
		cin>>x>>y;
		Int x_diff = x - x_prev;
		Int y_diff = y - y_prev;
		if(abs(x_diff) + abs(y_diff) != K)exit_wa("manhattan distance is not K");
		x_prev = x;
		y_prev = y;
	}
	if(x == X and y == Y){
		exit_ac();
	}else{
		exit_wa("the destination is not correct");
	}
	assert(false);
}
