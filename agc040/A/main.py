#!/usr/bin/env python3
import sys


def count_L_slow(S, N):
    ret=0
    for i in range(N):
        if S[i:i+1]=='>':
            ret+=1
        else:
            break
    return ret

def solve(S: str):
########################### added
    next_S = [-1 for i in range(len(S) + 1)]
    next_L = [-1 for i in range(len(S) + 1)]

    next_S[len(S)] = -1

    for i in range(len(S) - 1, -1, -1):
        if S[i] == '>':
            next_S[i] = i
        else:
            next_S[i] = next_S[i + 1]

    next_L[len(S)] = -1

    for i in range(len(S) - 1, -1, -1):
        if S[i] == '<':
            next_L[i] = i
        else:
            next_L[i] = next_L[i + 1]

###########################

    #count '<'
    def count_S(i, N):
#        ret=S.find('>')
        if i >= len(next_S):
            return N
        ret = next_S[i] - i
        if ret < 0:
            ret = N
        return ret
    
    #count '>'
    def count_L(i, N):
#        ret=S.find('<')
        if i >= len(next_L):
            return N
        ret = next_L[i] - i
        if ret < 0:
            ret = N
        return ret


#    #count '<'
#    def count_S(S, N):
#        ret=S.find('>')
#        #print("<",S,N,ret)
#        if ret==-1:
#            ret=N
#        return ret
#    
#    #count '>'
#    def count_L(S, N):
#        ret=S.find('<')
#        if ret==-1:
#            ret=N
#        #print(">",S,N,ret)
#        return ret

    answer=0

    cnt_l=count_L(0,len(S))
    answer+=int((cnt_l+1)*cnt_l/2)
    i=cnt_l


    while i<len(S):
#        cnt_s=count_S(S[i:],len(S[i:]))
#        cnt_l=count_L(S[i+cnt_s:],len(S[i+cnt_s:]))

        cnt_s=count_S(i, len(S) - i)
        cnt_l=count_L(i+cnt_s, len(S) - (i+cnt_s))

        answer+=int((cnt_s+1)*cnt_s/2)
        answer+=int((cnt_l+1)*cnt_l/2)
        if cnt_l>cnt_s:
           answer-=cnt_s
        else:
           answer-=cnt_l
        #answer+=(cnt_l+1)*cnt_l//2
        #print("cnt_s,cnt_l",cnt_s, cnt_l,answer)
        i+=cnt_s+cnt_l

    print(answer)
    return


# Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
def main():
    def iterate_tokens():
        for line in sys.stdin:
            for word in line.split():
                yield word
    tokens = iterate_tokens()
    S = next(tokens)  # type: str
    solve(S)

if __name__ == '__main__':
    main()



