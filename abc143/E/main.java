import java.io.*;
import java.util.*;

class Main {

    // Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
    public static void main(String[] args) throws Exception {
        final Scanner sc = new Scanner(System.in);
        long N;
        N = sc.nextLong();
        long M;
        M = sc.nextLong();
        long L;
        L = sc.nextLong();
        long[] A = new long[(int)(M)];
        long[] B = new long[(int)(M)];
        long[] C = new long[(int)(M)];
        for(int i = 0 ; i < M ; i++){
                A[i] = sc.nextLong();
                B[i] = sc.nextLong();
                C[i] = sc.nextLong();
        }
        long Q;
        Q = sc.nextLong();
        long[] s = new long[(int)(Q)];
        long[] t = new long[(int)(Q)];
        for(int i = 0 ; i < Q ; i++){
                s[i] = sc.nextLong();
                t[i] = sc.nextLong();
        }
        solve(N, M, L, A, B, C, Q, s, t);
    }

    static void solve(long N, long M, long L, long[] A, long[] B, long[] C, long Q, long[] s, long[] t){

    }
}
