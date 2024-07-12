import csv
import sys
import random

ref_id=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","u","v","w","x","y","z"]
s=[]
for i in range(1,101):
    tup=[]
    p1=random.randint(0,24)
    p2=random.randint(0,24)
    p3=random.randint(0,24)
    val1=random.randint(10,99)
    val2=random.randint(10,99)
    val3=random.randint(10,99)
    full_referecne_id=ref_id[p1]+str(val1)+ref_id[p2]+str(val2)+ref_id[p3]+str(val3)
    amnt=random.randint(100,999)
    tup.append(full_referecne_id)
    tup.append(amnt)
    s.append(tup)

print(s)
count = 0

txt=open("Payment.txt",'w')
for i in s:
    count+=1

    
    txt.write(f"INSERT INTO payment(Reference_ID,T_ID,Customer_ID,Amount) VALUES(\"{i[0]}\",{i[1]},{i[2]},{i[3]}")
    txt.write("\n")
