import std.algorithm;
import std.conv;
import std.stdio;
import std.string;

void solve(long A, long B, long C, long D){
	writeln(min(A, B) + min(C, D));
}

// Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
int main(){
	auto input = stdin.byLine.map!split.joiner;

	long A;
	A = input.front.to!long;
	input.popFront;

	long B;
	B = input.front.to!long;
	input.popFront;

	long C;
	C = input.front.to!long;
	input.popFront;

	long D;
	D = input.front.to!long;
	input.popFront;

	solve(A, B, C, D);
	return 0;
}
