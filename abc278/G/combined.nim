import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL


static:
  when not defined SecondCompile:
    # md5sum: aafccf61c19b9b669c5c8d68da04c221  atcoder.tar.xz

    template getFileName():string = instantiationInfo().filename
    let fn = getFileName()
    block:
      let (output, ex) = gorgeEx("if [ -e ./atcoder ]; then exit 1; else exit 0; fi")
      doAssert ex == 0, "atcoder directory already exisits"
    discard staticExec("echo \"/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4O//JqpdADCdCIqmAHyeLmzPetXzW8A5LcJR8qDQ0Kn6/cUO3NCbyAWifr9wJSjZLt2VZ5obovm5UZU0Pk++aArN2xbDlUHWNSCOXJPbYRCX1uzymyBLCsgoGUMUyQ4DeUN+iZImWw27lmW0YJ+F24pLfDf8WVb0qjPbXGV2G30hTwkL3UNGuVEOFhnlmzCU+dPAc11CGmDV/vqKnP5Zi7RwtkbQJuvWAdrNsYPC9zUIjF2mqY79Tq1qZEIAExWcYI0kxWvlhFeqnPwO0QOI+jWOtZDtRr/CcliCYFX4SNLAN+eCqtP7tBaEXiFJthCVzLIMyWXP0Kuzhc6UUjUbA9QBkJcGL2iofJ0qCsZOylS8GX/eQdsbiHOepl+IGxqcZtQta8BL2V+Ql12uesROyT1qBiBeg9O7+ekfkrbC+ITJw2vMMjDqRE2Zb16QByz69eR5R6Bj5flO2SfL/y//XipgrX0C67VVtlAcxuvx8eqYSE5Vz6+z9kiuYV/JYyuLQWR3g8e/W7C9q1RC4GxbshTfLsTOuN9MdCAW4hvQ6ckTKeOJ4K0ngjv3Dw8meQ6tbja7r8NNG6tpwYlxUcKE7b9Mc20nsR0L3uP+Hg0BZ5n2CIje+BBzLUJRPNIIJSjv/Z+E/0k793AwXKdcDigIRo2kOHtDE9MPoYlHp58O3Ur1PmMtPkiA5VyVZ8U6+XQzY1i3LzO/VJ9w1B0uZX5No9ZUzBO42F0sWDyAI5yyZDZKtuf18AZcKCGt6TODTU/p/vj09fhLIS9emmtnT38Gz3PSj69qgdiw4SquPcLEzq8Ry47oEHMHBV4u3QaPzNBtqh+bliICUIqOAb0C31PV/QetqwDnhaAMwfW2VY7qDky8moUXI4PIOFUJKdjX9QrfETvdeCZQvvibUSboAp3VbcmMXh2WJi0+dlKstlBVEGUrTRNDE77HLlp1bfEg1kJwEK18yz+HDxYiYZfRVXoKGKZBcjHTk+H4el8DuTn3bmsYRTeZ27ySei4snt/8ifcoN9X3LrYYp3zwM1pPKd162iqONARwj/3EDTBvwo56upYdc4v5pOWo159/fVHwHfK/iPMHW66K1J0zQ9XVZ9qmUHwnV2CZ9v9lrG9o6rJ2rcYDhyJyyWETTPJYMyruCL0b2npvU1dKHbnHp5nLEwad56ajbhr+G7eZWv1TWjHnTl3oN/2W7akjeQ1I+p99ecTChgefEfNY/h1AmG3XoYfn01ewalq3yMBdQX4xtzK/ejeZG/AWg8zc4zIDO555h0TkDSomA5pwvp76Dx4W28FmnJiSCrxOgqVRYfwTWnCCq7LRD/aKrDw1wyE2rliTN6MxRnPVPTeMumCzKMUReZrixyPya5nlsPsBv+WmSyKIB7hByB2zHvOtNSdBVrSZXdv4vudVYVYnKioRYspRSESAd99j9pHPQA0z3SecxSHeCOKsGSN6jlODfJ6LwQWa7I9sjwDBmSGRksNTPnLtJnNv5+tO3t5Yz3juoBMPWnGpY611HZBUf23Gvtnr3Q1nay220ce3X9NdZ/wy7BwiBlvbR1C0H+xIwqGlzh+YQhn0Y3C0UJVrjXtdmhOavs6Z5SQevyakDMQxCH6xHBiY/NgFWCj6+g4yrPoa4IN1/ICVwF2Z2k9ocrzwPh68CNnhHqnMDL3omusoRtnl5vy2XTDdiP+GDEuteFmHnTZtR6pfrU1knHEmuVjxA6dfLQjvz7Xwo0vQ5mCsuYZXhpDGoq+PkGKr6QlNF8kWRHMNpeDE4t432ROEdfeUhmZUeXkd52jCseJiz4a3s9IKnaZ56S5RmgcYRHGZZPVFvn8Jk7RKOgG8bBrJPSHNT4xhLt6J1UqKOzAinFnRsXH2qDSMmJDsrwKcCywFHYAv4urPGBAkKBIq0xaKhHTPzbx5haRYd1wpennuXL3qV/nBHd9f9KxqP98+j8fEJ3BaJv+SDQTKhAZ/h5wU4mSwpf9rRTXNecq3Bqi/rwDoZPiQbryiRbOnTpzbNtf9cESiOSB1kB61/5uU6frNyhWVfmZmPWMYtkcxgRXpw3xMCOe3SWC3uzLF0Ll694Ci3XCSEmRJCtPP6023MnhARHX83/WFezEQyrdhYvO18E5evI2hLn6m91FM0yuc6rwp2HYt0+1K7xnzbsWrzuNSaMr5OPii+ZvDht8cMZ+j7L4Pe5Oz19VH4Ya9Rse0sUaNAsVvCBBJkLXdx24a0xZ7vbhGRol2kXEgMsGlE2JOk7s79sAUKJFdpXxs8PHHxKzwhXlPIU8aLcfzwdj0mctIdEKPrdtW4KWQqYWdFMTVUoDrUQBKcymExXnn9BVomG8+clcsoCRtaGH/WvROZ2/g9XZ+gmOYXQMcFEjNRqOG50tSWbPVKy2sDiwL6lDWhXkAT3BntVfDREegmTo8WbLaUBYD123MVhxZdS8LOhrZClzp5NXeS8ARQBoREZ511OR/DclfJaIgMmHHAGomnBd99VNz2plBmZ4sbGKfVR8MOa0m7ol0d1JTakZ/sRRBW+oQjVt67ts/K3qwFq78AS7bTOm0nJ6Ngb3KpO3VY3yMBzCGS7x5BFSp75ldm13pOsMNrs1MWuOZ069ZgRkHQox+ORf9OPkhPTWszk/ayt1HlB7u4IejmTC75s//nJqfNW6z02yF6LdyrwT2iDmjFkdRlElf+TI5PpoaOf20voy6eiTlKgVuVGwxcYCEXROQyVHd9MaKGIXtAdYgstUEpwNWJgK/1gKsRhCg3/Ezs1GdaWvdJMueVe6GHgjoEVKW0ltUooxOTDwnyFyaDtljUk2SJKY9xGz4e6i4zUt3MVCvOhusiZhRV6jdUYRGMDiE5iMgOf5wsXmAHZgq4s4BVZnVBR3tu7i7YAnbMlF2EX8iQQou5ZRZMO+upodsJ362sR7kO+5ALW6UQKvAA21ZI5NavMTqhpChBLeaixWOO4ByDh6cTxMYlPTHDCflO5/OoG8xLb6v2vJT4Rkjt9qTPLg3NWlRaO3s8Nb+5wrSiBs5mVMMeTyUDqNjZi0I7l0veXeQv/OpCELHWvnM8Un38MkRqh4V/BBBNrzykb9aya88ylB/tK+nS1pAtBH1j+bjcd4MQZfBHzQp/E4Jg6g2u4fLMAghQDmkm1+EKcGRskdR1O7KFNuGHzXqWjzF4CFdJhP2fkqqh5kuuvHPmyZkyZ+MdyIIt5oCw4dm2NXEMAloyDfeKVPIQJjoGFGnP/wFQ5q/LPMb0NfBTO+gUStUEft/PtT18SbGRMe/GwDqLMMcqGPToW6OUdTBYTtLyPhG8fFYhdXu1M3lOfCyLNq2XAO+2EOSloKreI3yJYQqY64wTIeGZ1gj2kwEpkj20oKjdCUwIjCEjeYdF2iJghh+Qdz5Ux0X+pT2xwBeEduY1yObMzJJbR7tA+c6A89CrsLo5xOuEgUavr9QJ8EbkCdL26IF3A/ONk2qnGIVaSb39+lTMM7rdI4+uBeoSY/aTpOKzbY8Nd1etp98xeGGHIByHXGljZ7s16JEZ+wT5sLSC+SwbouAWsytNrbqGRKFu4ZpvtbK0zMUgNqneBqT9ltZhlsoOvT/LfFBfHDg3qVpGnbn0COEpv8/8hm/ruwqwAz0hsVB+PC2tDTPY6Z25Vf7VxyAwwpvn4xob/nvzlbMPZLlodCFg+bzwhqbiUZhPYKwaBNyCSldqoXQxQ8oLjAX8Wh4R+YO7CwiAhQ9qU/O6C2B74MclE2QNKNrOrA/88hcX9hYQYlfo3iLbHMGoRNJP5ewaAAHSMkdEiVHT778Jg6JP0NgnGtxamJcrYzJrj+scv0p9VgpkqPOvXOCUqL7FvjDetniQ8HSqOT0arQrnMU4B0yx1A9qQVR6dDdpGTYdDU5RGjnk4nYK5oS34UPpzSZ1XEXbDUGjztCxNefkVPqemPtvuzFJoHCac5KNjODKgKLMbb4rtz47rm6Tw2tqClYa4mEgftgoQqQESWCm8fV4Skh1VRH4QNB5JweUnG7tJ5nS82gJ6HasjmUq0lT60XYe36gX57lztNPppnGhHoDOoBD7+5mrECzCz2s/ffOLKj0Oqam+awPW+WQtWAh8DhCEq7bJXMY7GvRtZIj89jHnq5hr15HEPF5f9UTD3YhR7FS9Pbwxg3PMsS1XreqRpsTzafJiEAgTztGsOI24VCg+8iba2UpyU6FZEZfMVtFfbdVYH8AgK72Mo6lMj6CLcazKOIpD9505fiiF40BfoMU1muByNkgjVNK7JQclrzJkVibmN1RoHZ/qlGYK9ME2aeM3xoghb4qtnul36JP9unCWTb8uwDujPDQY+AcIIHfMCDRa6xf7BcvQvLhCWrB1jbOU0el5tQ52yuxXHbl/SmH1TUS8H6AJzIKsqg/7MyUlRC+0gorLhDSJT2y7qjHE5XMLIHMhzesHxAjcovSG6MD+IKI0LF97VdpIJiWOyT7MIbuCSUK9Qkb8iAFyy35WFwLZT0mqHGxW6K5AflMF+gdgce2eRvi02642SE9gPNit4QU0yVaEucU/W7+dwJPFIoale3wC36sKbUnJITy2W8hEDZcCYWC78xFKH5Ipy7pybjTQbdHjzN5PKgtVZnaG/WsqZG2rLQm3C5PlnqnkEzlgQJq7PhSMrUtDV7fuz0gqUjEaAV2rgDHMUosTMeDE0KV2dYHWTKlazfjJPyKimZq1YlajA5ZSoqv7Hf9kj1Fm10dLabG+vcqPyxmvwa/Edqnhgk5TXXoGWX6/tFcsbAP1dcepHvisnWEKcB24HZ9RF2FbVdFY6L+7WWnV3/c0w4IZ/7fpLxmnmeNP1KmPKbljZnFaanIuNC4JRroFKsn63BsSu1d8eImfFhzYIDjw4maJOkUPVDco2WWMDcq495Og5qE+dNF6OaqOwj0InFxKX0W3dfB7znifSPDHSEvbbU//Vd4CDAxALSI/RdJkVh4KB64R3vs2zmd8CuX/B5CLCm1bj3dsxSYItilTv/I98rVVUpWWmJhskuN/FX2s0giynrZaF02Jyuwqol4pvCPtcUscaUiJ4tOsY6xZGAg2M+BE+AA1/44581Fk+icEcBpg9mLmA/G2Fbk7i9Ze2HiswYNgaA1vBgRMS3WRMwZUN1xfv/vSgX10uN6Be29VLb1wXSOjX/FTHoqMdPbY9b3cApAYMsREGNaZGmNHIcDp5X4CxJnSBfyrefeyQR/Ri0r6OgBOSty9MORVj/LwwaAF311/6ex7Y8xtE1BZdYZQ3EuJITGXnOKPiGO6PZr0IUn1J+uUr2fs41QPUjoRCfRMlaqTkeD5mOJI6N2ZyaN1ucgwiHPC3Z9/8taYrx7uas9hlOO1ZHmBPN+OLFE6L8MJoI5HURTOtJuuNOPf44bsXy1uRTtIH7Une2cavbr037uW9CsxaQlaifFL5RoQRR1EPur0ocoGn+kXepbqD5BvDjmOm+BlcRbQmewaydA7Pki7qNakQTllxf4EI3wC5sHqI/pyyRcr3MOupTVrVrU7hM6VzE3OvUfpNDUiewja6hMCGl8OJvGrsGxcdYs9+Awyvlmo57xfnDxEvAIY1DgVrJ1iBvkdbKuKVrFeJBNh1ODjsOQ5nfSQ3LHS1nQiNa0cyo8thvogKYtIMW3sTE7MHGJVOZqBuOstLO4mcUkJPGKSE9UaUZJgnnus6Dh07oH6SWbVLC2Qpum+17sXBPbWE93KVjSSpMlcBP+006ruj6lR+bJF1AthUoUj94JJfisvG3/bcfL8AP8a5A0Ji0oWFVhzEPun6ljM57zkazU/N/uMlyEN++0JjtFHi0IbT/sipj5B+uSXyqgQS/PHRCkk5/PHgmw574pVCWqmJUa9289M9yFAzdP3mo1q6WlEgQ468HZwpXlpQ8y2LL4h5RKdoEMuC5ryrkOFs13l7LXkPiaJ0R93vQUAmWVSSRPl2HgyuEYypiYakSoNOLX1HZWh1M1Ia8V5KkpOoP3o8x5CpGQZPjOeXRTlt688Y1+cQsx8NUcLagrxZcowBsliVUZn1T2XQibqhUsDk0fIzn4rOqOg7L9VrCSTTu1D4hu1QRvRlYzNE/fBOijF3jIUy4Bx9kNPCOPmsKKSQvTEi7GUgG/jlCrvG8pX//lpAS6BZjgTvy9kSpOzR3J375kCxdL1e8DYFMwGr5B4oVr5KMSIWtO0no0+lSHAGJtY2pSQ6Og08TGxsuhGYqw+LuC2wBzIN24CDwMNESrJEV+oQ4EoFpy47z3g5LHSfNcMfEd0yNwBDm2LskgnJ6wv/QAklsBKy70FyFdvYKJIuYIw+PqBgxEJa98uUqm+qDnOPJpvj4BcnackWDmwPRWEeTnT5L723APuK5WEeaD0vrraa+ouffsqqXeXtixQ68UIGmgp9jCT/LIZlRFkblLUFMTbykaliRYTTsEerpFmvXJgcafU4RwZ6x38DkPBGRRaGyGT6Lp21OXln+xIRVpGTtXXWBSEWFdGtvrFBxA9yPv19fLX5ZMhFkE7NxbR3J21aHka7BXFJuRGaFFxcSFM7qbB4R0YosZpmnKo7rtdd+8/9A7ziZ0E4SNF7pyjVqoVl6SKDMfgT7woZxIMPZaBGa9COplfUbtct/zQaX0qXgube8U00pVYB0i2J81oklCzEl0G+6yJtKWXbr6TkmZHIGEc0tLRojHScOfbdibJe427fK5GENhLecHQuXwPuggK9jpKn6kj1edR9O/b24Gc+pLICwGmUVdq6MyhYzvarzY7ycucFZ2WB5sSMv/kEOnjDdpvpjNl52eWeO7UbzkoNuzDXcKgL8KhPiFKK2VkWMpTQBtxGaVf8+HRhgkYRoQ+hCbxIqtlSOvP/sEErVHUOsS3Nrv/2qukeqFuGqTTM710jYMaTEzfsix0csA0brRbaU/RT7LVyJnYwwygv1YugFN/eBnQmAd3Awirww2vRhQ28NFQDhqmD/vgKaS9suZZW23hfq1OwCdkL+sJwBl6an945vgXic5M8XMPqqKtdltCccojzJjsjPqELOK4dzWqXvpwRUFNBLdw0odcZmve3IIXLhoC2hrW1NMvj4z6wVsUluGSL1gGiATYoWbl4npBdfChK19jjlKK+BpHA+B6FQCpPqkoVJ3mk8YcEu5LGAv5DDUlY6eqMEKK9QlkNpUlmGPe9mI3coae5hnKn7FEe9jY/p7EtB2TrrbE/qT9tAYYvlUPvVA2U2v3laC7HzgE9w57EDVzmCmw3/9hCtj+9ZM1GtR279dCh2LYEsahxX3PJIYngO2LHtVcnm4vNj1Cg6SKZU7Mw5uvBQe+2nhfZaDJKPzXV+s/wFeXAUlzG95vBKZzk9oo8bsKhVEEaByOmiFsSM/pNeUcM6jAMoU+pYf6fXmEXp4k8IuWqvmhtjgBJHqIZpC7ZmtVmoF8HchaQyGN32La6gwlDCxknCmQObczumSOVVl1DWJWF0xts1BVUnoic+PP6W2vpZ00oOOCiSBtGC6a9A/zhAUzfi6vDAxqZHHCmwhByQiJPqghMY0xBgbhn0uovWb3OubRt7ez2/LbKLIXK/+TuRDWcCQgohaxD9E9aW7Bf+smWW1pChmcNAwxBD8ayLz/cT8H7/6r96AdyvrJ5CaHe+l5feqvg8CcnUCBoPRPlFl3lFwum5auP00DA8Tj0eMECptKDgOJqY9/3QZjHc0TbJjIsnZatRLJCUNGocdaO+JmMGxcmOzq+BwUNTF/o3rzpjW7pCSxqhSoehiiOqmbtZi39EAf/zrfLD1iXImu39b3GeMVggJB9FOSKtxzcPzAhEU+0WC5LOTHNkDXAeF7hLx63skmkQ7qqsqtcueWBG8rKhf3+OtjGsVNTpaqAXc+Uhkak/42A4WJzzQuecgj735h920La4LP+myEgbTHIBxO8u7FUH/ZKhb28YPI6KfF3bnfpzVgbMVRaZVF/Q2KWAEOH9wtqzjCYi/mNtEUn/6h7icSGF/25CoQm+t6S7rajN3iYItPRADAxmZS3O+fl9mczWz/0zBX3jTqPSM9GueI5JQse3NpNoUKunUuFtE8cs884pQTdoNJmj1KBmyP8wf8o7R8DivwIvx01wngJvrK/Dv2VfKbD9efbkgaaJr001m3/GFFkMRMPaTj1wS04K3VyoCf3lfmiuOusbiAchy9OEb6MxtZMSxe97RMxkTMt22yznuqau4SKuVisW5kfTAvovWjxm3aG4lbQNSHxaOs13CBDQvWwFZVRjL3p2x/GWxhYGwi1GRdZxj19UUuD5FZDxm4i5hipK6ngA7eRTDy+/K1h1mNzWVP+csF5S/W5126Gg+llNLEW5/iEhZ+wGs8B6ZahyY11qoKZpDgtJvUXR2+AREZvuNx4mlBQVrKYwRASkHSzHjCbX247EEYmFs2j5BScwpYB+sed8JEz85oJ33RqQxbZBJhFECo+7/FN7BQiR0VhDIiMUy0hSYl1HMVwQK7MXRJU85xoPQSRpEIz8SV1gIs0AO1SvcmSpLi1y3e179ILSDin6yXvC+wxILBHkb+4s6404vu1blzGfdocEifOmb+d9MHebplL0BRRvaUI6nYyvKicpOG2E+fVuIeHiMIKQhftkp5CZzy5tFlIilDTANDLNgKNse0xmDeIXhupfGYCpFU2toW/lQiR1dpKcqRcIyQL1HRkPQZSRQ1dqERnTjq5Ib/rdpwcR1V9I22IFyvzA8kGKUoM9KOuqnGtnSKISBltg9jRnhFMM6vAq0cWzKNFFPWzno/EqdDRTcz8zCu7psfK4OLBtqEw/NowZhKLk/v644gDBZDoWPpogJP9jXgXLORGiFfAOPTpjv1z+S97ON1TQrj1798NO1AEpLLrHPat+AnEhmvPmSqwWZvijo2hyC6Nf+CW9mlIWExoWvysO3SErqXj4mPtqjwcACK7kY0rdc+EuBtEJTXtEe3lrADjkrCEv5DB1dW89vDC9CYE/uQATmOs1nimPqwix8b9bHbWXFv+sGWVet727zrUwNXjg4hzbvs/216gD92r6fdmayikRQ+MyzAVMGKPlFROjD73owKbCMx8zuvXHkx9yky+BsKdxbLe01k1FxDo6RpcMAadbRtaRTzZ6re6zkJx9xaGM4l/Uo5UryKskleOf7EDmwQdx7rXYE6WiGfK1DPeZqE3R/cFgpjCjRvEfK3vNVuJA1tEmoOPRqhHlYGbchqwp5xeIGKJH5hSXcEDDURyQ4wqoogixTsNaj1+2NK+huY/zX4FoG4agfpMv3NnP6ZHFIIsf42yJTT/JyYAz42vJ6Cuz74SekgrfkUr/CAs9f4wHEkIZb8UH9a/St9WBxzM5FESM8BGY/gW7du3SDid1kr4HrAyg3npNyt+ED0Ck5jTFiJd+kgEQ4KDZga+r16+QtBCUw4FKOty/VIp1f83DjogxeqpdB0rjF5EUzo7G5UDfV82fnVEHJrMH/OEJReaWpy7wKkD70r6g3uGbTnTFn0T0feQic9mH2ZSxaUP4u/Oe9uQpF0KJ1mw25MID00bht+e+TCp3jWJmUk11EL7lIEggTplmfBShAPC8c+BX4za/LtQ253zUqJtTSe6OauLJ/5M0MxPCDNgrAMBG7fUTzUX34xpArjXWcPr3Y6sdbuxH00/vuqmCLmzTmBK41Fw0GzedTd88Batewfd4n3AR9bjw+ikULM4A2TMrNPsLYf1cs866nS12am2P0qOsJ/Sf1SbR1HCSrcbiOE9OSqNhUnhCTGbVt36X/Tk3EMrQfNe1reK5T59VmyAAQHqkyScs6ib7jBQ/a1LHq4UTWogxhStgsgpIH+mrmXXM29fffmMniJKB9Htr1zUH1dYLHvGwV0ft3lYYVIaX/VmZIlVUz/gR3CDWT8Gl85GujREhilSvhMXY22hPdf00/jIfUAPbnQRrDvowYNbuwUf7K3xWsXT/FriHiYHu6FFiMc0LiOJK5jI2VKQN5d+3j6OCQvDdyTNxFwS/xiOPRC93sS8vXrX9UDtdfHFEbLpNB1io9pOBkm/BUOdUmO0gt29BXpLAL/KyAkfpfy/ubrPvj4daVsStbBlUxO9uOEHGTtiHAFrs/yqOkcjCvvKnv1toB6F5N/QxZ7+opTViPnnW6sQEvND8tJPOnojPI45Vwe9GIIVPjT51J/L3gNZaGB8EQ1o4MuSAe+sFoAh3mTGzNJXRJXxIXZkHq3MK8rB1jclnQ1cABidPJyYOG26sBIp8Kxq9AlbvCxn58q/zb+w3TS1JTUAwTovyBcn0IVeHbys4CDs3VbFpLdQJvRKZdixh6bAfTQdPXrZWkQvoT5ib/ikS5LJblELTqT7/DsrT/eT/iI5j1Mooq4QwNH8sk4ByR5yk7ceGRQ1QIxJAWQrgZTn50SqyXVYdGdHOlqxtlVsXQC2jIk6Il7m9Rsjfr7yO+sJNYZeBmDCCLfFX7RioTUToq81HHsEw6MqQOVBZmfYP/4ZuXdxiew4BJsmbnEtQI+h8Y3/rX4IwilJHNKcIc+oDAQMuXhYPNqZkPjb9QZwriWWpYKsyGbCIT+DoGeXqvP4pHGBB5XAzzWq2ipujniXm0vmMU+NIyLv8KLMX4/EJOF3FnUpyy/qdGNJrHNz4lWxBy/tkARxpyHDBSMzLss9xpS3pcrLkHrmedkBak51+khdbDFNeRtkLDeSNw/82DSuQzrncCAeis8+VHfBmN/tu3DP2blJsmR+ae6MF1PmQq3UE1fYjIhWRRb8zYQxp8AiqE+SiWoPDrb/Cg9zQPULJCEgmIRTD7MbjfT1GMFfiN2VMBrld/7kuajzxj5Uqx/2rbvEGbxUXZUNkP76d7OYv1xYuKgcajsk2WvDoOksN1lVBbmjq5yeH66mTvC4dnBO/jutWD64IyveCrTQnfkMCf8ZvT/b2eDWvKhN0o/tc8xPo4aerONQANfs7nRYZiL5Gf1Y1tsLZh6LSFOXVjSAjvr6igs3LCGJE0HMxevIduJl0N1h+j3vIwAfie8ZGikWiTU6b5ZC10hGMwAhcdkL5am01JwgUUMlIRfYOiP6JTBtnTH6INOrtVdY/t3Bt+VZAtv6l3xMmYmduaO1GUq28GigE/fbMc/O8bHSjN+tfnGEGghhC79iXPAI6nhuAiySSVvnsBZ+BXRLOaLCrNP4fZUBXu4SagCItxK4Mmg1SbVhHbJkf91f/+3DQN/ah7HTOaFhvc6qAOCLf1sG5W5GeqIw8709GWG4/VcyzVKQrw/iFVhFK6ZKAmdoF1M+vC0sFhtB12mU7p7qjDb8b40WZz3aaou6dJkVg6aARnZPs/yDxGqSh31K014JB84ek3AbzH0b4iVlDAKwECXKpdOWI20DOX5xNGyL2N9/yw83iGnepqmnnxG3Re5u7kUfSj3NXt+Y54I11TDy9oCyoYG2hEFrwbmcNV8CnQ7BafxsWXWM+cSDI0OYb+VQpPyeRZoD845cZhGUr/qRqPfAhWCuzAO6IqQDLyh8yAdcdPeO6StTvZk4vlu25+JSCT0xmAxhcnAXpwP//0rrya6c9qhPErXP7y8oTLeoonlVwj0q6dgs23EVq9K+aFhvrddfA1VfZDUQTTp4WGlNW0rpkm/A27gW4MOPWP4P1fmuDqn2d2TgKrh4jZ0Xfg+5UJoqBNE6CTUtz91l32POJrTp5rFAhzsoJ4pwuLuOK9sp8L29tmza7V5hYoi00uqd3/i5BdNUJa/3QIneuLKFFkuw3lT5gl8gmpsxCZsMjRXnjgyEx1cNykPAuWa63w/0FMWQJb35ieAzbvZMg69w+YFiQM9DAd3vkujgrOBCsj65PdBW+5Xpl3tR1a1S3gF60wUaZ9oC8RlHEVj3OxqaP4gYrs+4PKTb0qOuCCyHbzynIl+4Lre4RBN24eNnFCw1FAWn5uMmYVydNA5dBX6IEIlWTIbAzBHeNsSkG2j3GE36p9sOQBzRXV8RIn9iMJ0y3LHDlVGqNG72Va4gKYX/nebhzmJjYc5QvSnM5NpGrikzr1bw7xClbUqzuIo493Xe6w0IvRluRK9tMXDTfRk+XjySOqOyVe2ctSwYh8O1Zzsyh+THrOPj4X2vQcU2J//z5zbrf6QLlv6++p8g/ulQ+bsch4kfE/ko9vCtoN8fZBpHJlnS9H0oCVpsMw2CIOUTk9Q3RqvABq0ih2y/fGgJqv0UKHSHRg2lsYY3js0LMjUJUrMtVMm+dkR8sVfXHdvsKctXhunlrZHw4sAqmeMYimBpnicrjK22UERHeSUmVWXCJX8Oj1K4WlaPlCvTbtUpZzUwDT5YF9jNxTXudxEKx5A51Gfbz22uEC/ae+Tts9StSI6M3zlloVhG9LqvHmkbjhEPc8f8+S/MdXeKlLOfeigAM/HeymLE4Gl7jNIYLjLOZCy06A6A1umqXlLLuCOwrbaLzbTNsBooik1F0fXXHgk+vBtoo2jeNL8uF8td/jnwBefcG8z06PjLvEM3TY7u6e3Mi72gYC19G/0XYVaYJvKcabRxQVM2bKokvpsMfk4ntECXcioqXLPEoEYOkvlHZr4nr6nm+P2y0t0kOXzaBoKGeTYLgaJo97Y24R2h3OYGA1vt8kF9JlId7yAzZtiwVjcRLyyU4RzjrUxY1JmE51Bj651IV8FdW9r4dIuU9r8giKsVYwpWd4M3xPsVlOJ+tAKfvgw62YJ41UZVdEj9etkUn4nib05DCPE4zmiuyiPRDfttLRkFQVir4TwTk1mSu6j1BXRUl/aKlJgh9ZmKeRjjXZDKMmSDI2gvxmDrUl1JNL1aMRl4MoVb7xFSLmJo3eHQz3mNn1sBI4rW9OhjwYGm7uMS3MYS2QyGNbHfBXmd2iJOnPirlNJxvq6dY9MShRIep6Hq1aVxQZgdd+d8Zukxfy/FgzpwlSqCofOhgG8euMtw94mnrCUhGpGn3ZERsV8TE7tVNgagaJJwYVAdA4Gbyqk4472Fp+F1vV4f9CtD6QOqIzAT5vHPuWP1LElNuFAXpOVX45VDPUNRZ/EogOlaZ0DDAUfZwcy7r6B8A0Ku2deo5FYxkwLlx+pcTAlBQ5bFr9MpSkYr5hlo49w7yLo9vdhoO4xoGo5uK2O00/wVNNN/qa+gVIaQgbmVwUKbrvr8Nfq/m4WhCKdedGELS/WXkgt39cRVEqWaKgl+Sa/xGqbz60BUgq7C1mSsFhWL7HQsqBxGVjPWScNG29UMOSBwCFgbwYHMDYfdOXogptpvdeSvdxqmo4asu9Y8FdQkymqN+oN3CBlqEzHyRKFdMVk999t1xgaCQAAAADtPMwpIe604AABxk2A4AMA1IARy7HEZ/sCAAAAAARZWg==\" | base64 -d > atcoder.tar.xz && tar -Jxvf atcoder.tar.xz")
    let (output, ex) = gorgeEx("nim cpp -d:release -d:SecondCompile -d:danger --path:./ --opt:speed --multimethods:on --warning[SmallLshouldNotBeUsed]:off --checks:off -o:a.out " & fn)
    discard staticExec("rm -rf ./atcoder");doAssert ex == 0, output;quit(0)


when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/header/chaemon_header.nim
include atcoder/extra/header/chaemon_header


proc solve() =
  let N, L, R = nextInt()
  var
    g = Seq[N + 1: int]
    a = Seq[Table[int, int]] # a[n]: 合計nで分割したときのxor一覧 (v, n - v)で分けるとxになる
    ct = Seq[int]
  for n in 0 .. N:
    # g[n]を決める
    if n < L:
      g[n] = 0
    else:
      var u = 0
      while u < ct.len and ct[u] > 0: u.inc
      g[n] = u


    var s = initTable[int, int]()
    # 合計nを決める
    for i in 0 .. n:
      let j = n - i
      if j < i: break
      # i <= j
      let q = g[i] xor g[j]
      if q in s: continue
      s[q] = i
    a.add s
    # n -> n + 1にする
    # 許される合計はn - R .. n - Lから
    # n - R + 1 .. n - L + 1へ
    if n - L + 1 >= 0: # n - L + 1を足す
      for x, v in a[n - L + 1]:
        if ct.len <= x:
          ct.setLen(x + 1)
        ct[x].inc
    if n - R >= 0: # n - Rを除く
      for x, v in a[n - R]:
        ct[x].dec
  proc move(n, t:int):tuple[l, m, r:int] = # n個の連のgrundy数をtにする
    doAssert g[n] > t
    for y in L .. R:
      let s = n - y
      if s < 0: continue
      # 合計sでtにできるか?
      if t in a[s]:
        let
          l = a[s][t]
          r = n - l - y
        return (l, y, r)
    doAssert false
  block:
    for n in 1 .. N:
      for t in 0 ..< g[n]:
        let (l, m, r) = move(n, t)
        doAssert l >= 0 and r >= 0
        doAssert l + m + r == n
        doAssert m in L .. R
        doAssert (g[l] xor g[r]) == t
  var
    turn = 0 # 0: 自分
    board = Seq[N: true]
  proc query(x, y:int) =
    for i in y:
      doAssert x + i in 0 ..< N
      doAssert board[x + i]
      board[x + i] = false
  if g[N] != 0:
    echo "First"
  else:
    echo "Second"
    turn = 1
  while true:
    if turn == 0:
      var
        i = 0
        v = Seq[Slice[int]]
      while i < N:
        while i < N and not board[i]: i.inc
        if i >= N: break
        var j = i
        while j < N and board[j]:j.inc
        v.add i ..< j
        i = j
      var
        l = Seq[int]
        xs = 0
      for i in v.len:
        l.add(v[i].len)
        xs.xor= g[v[i].len]
      doAssert xs != 0
      let t = fastLog2(xs)
      # tビット目が1のものを探す
      var u = -1
      for i,l in l:
        if (g[l] and (1 shl t)) != 0:
          u = i;break
      doAssert u >= 0
      # u番目のグランディ数をg[l[u]] からg[l[u]] xor xsにする
      let
        G = g[l[u]] xor xs
        (l0, m0, r0) = move(l[u], G)
        x = v[u].a + l0
        y = m0
      # 出力
      # v[u].a .. v[u].b
      echo x + 1, " ", m0
      query(x, y)
    else:
      var a, b = nextInt()
      if a == 0:
        doAssert b == 0
        break
      elif a == -1:
        doAssert b == -1
        break
      let (x, y) = (a - 1, b)
      query(x, y)
    turn = 1 - turn

when not defined(DO_TEST):
  solve()
else:
  discard

