#include <bits/stdc++.h>
using namespace std;

typedef long double rn;

long long N;
long long K;
std::vector<rn> x;
std::vector<rn> y;
std::vector<rn> c;

long double EPS = 1e-13;

rn find_min(rn a, rn b, function<rn(rn)> f) {
	const rn r = 2.0 / (3.0 + sqrtl(5.0));
	rn c = a + r * (b - a), d = b - r * (b - a);
	rn fc = f(c), fd = f(d);
	while (d - c > EPS) {
		if (fc > fd) { // '<': maximum, '>': minimum
			a = c; c = d; d = b - r * (b - a);
			fc = fd; fd = f(d);
		} else {
			b = d; d = c; c = a + r * (b - a);
			fd = fc; fc = f(c);
		}
	}
	return c;
}

rn sq(rn a){
	return a * a;
}

rn f(rn X, rn Y){
	vector<rn> v;
	for(int i = 0;i < N;i++){
		v.push_back(c[i] * sqrtl(sq(X - x[i])+sq(Y - y[i])));
	}
	sort(v.begin(), v.end());
	return v[K - 1];
}

rn g(rn X){
	auto ff = [&](rn Y){
		return f(X, Y);
	};
	rn Ymin = find_min(-1000.0, 1000.0, ff);
	return f(X, Ymin);
}

void solve(){
	rn Xmin = find_min(-1000.0, 1000.0, g);
	printf("%.10Lf\n", g(Xmin));
}

int main(){
	std::cin >> N;
	std::cin >> K;
	x.assign(N, 0.0L);
	y.assign(N, 0.0L);
	c.assign(N, 0.0L);
	for(int i = 0 ; i < N ; i++){
		std::cin >> x[i];
		std::cin >> y[i];
		std::cin >> c[i];
	}
	solve();
	return 0;
}
