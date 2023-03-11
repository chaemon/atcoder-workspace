#include <iostream>
#include <string>
#include <algorithm>
#include <set>
#include <map>
#include <unordered_map>
#include <cmath>

using namespace std;

typedef long long ll;

#define MOD 1000000007

const int MAX = 2000001;
ll fac[MAX], finv[MAX], inv[MAX];

int main(int argc, char **argv)
{
    int X, Y;
    cin >> X >> Y;
    // a: (i+1, j+2), b: (i+2, j+1)
    // a + 2b = X, 2a + b = Y
    int a = (2 * Y - X) / 3;
    int b = (2 * X - Y) / 3;
    if (a + 2 * b != X || 2 * a + b != Y) {
        cout << 0 << endl;
    }
    else if (a == 0 && b == 0) {
        cout << 1 << endl;
    }
    else {
        // calculate (a+b) C (a) mod (10^9 +7)
        int s = a + b;
        //ll fac[s + 1], finv[s + 1], inv[s + 1];
//        ll *fac, *finv, *inv;
//        fac = new ll[s+1];
//        finv = new ll[s+1];
//        inv = new ll[s+1];
        fac[0] = 1; fac[1] = 1;
        finv[0] = 1; finv[1] = 1;
        inv[1] = 1;
        for (int i = 2; i <= s; ++i) {
            fac[i] = fac[i - 1] * i % MOD;
            inv[i] = MOD - inv[MOD % i] * (MOD / i) % MOD;
            finv[i] = finv[i - 1] * inv[i] % MOD;
        }
        cout << (fac[s] * (finv[a] * finv[b] % MOD) % MOD) << endl;
//        delete[] fac;
//        delete[] finv;
//        delete[] inv;
    }
    return 0;
}

