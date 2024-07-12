#read csv file

import csv
import sys
import random



file = open("MOCK_DATA.csv", 'r')
reader = csv.reader(file)
s = []
reader = list(reader)
print(reader)
reader.pop(0)
fuel_type=["Diesel","Petrol","EV","CNG"]
Mantainance_state=["G","B"]
color=["Black","Gray","White","Silver","Blue"]
Number_plate=["UP"]
Alphabet=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P"]
plate=["HR","DL","MH"]
for i in range(1,101):
    tup=[]
    p1=random.randint(0,2)
    p2=random.randint(10,99)
    p3=random.randint(0,14)
    p4=random.randint(0,14)
    p5=random.randint(1000,9999)
    str1=plate[p1]   
    str1=str1+str(p2)    
    str1=str1+Alphabet[p3]
    str1=str1+Alphabet[p4]+str(p5)
   
    driver_id=random.randint(1,100)
    driver_id+=10000
    seat_accomadation=random.randint(1,6)

    p6=random.randint(0,3)
    p7=random.randint(0,4)
    p8=random.randint(0,1)
    tup.append(str(str1))
    tup.append(driver_id)
    tup.append(seat_accomadation)
    tup.append(fuel_type[p6])
    tup.append(color[p7])
    tup.append(Mantainance_state[p8])
    s.append(tup)
print(s)

count = 0
txt=open("Vehicle.txt",'w')
for i in s:
    count+=1

    
    txt.write(f"INSERT INTO vehicle(Number_Plate,Driver_ID,Seats_accomadation,Fuel,Color,Maintainance_state) VALUES(\"{i[0]}\",{i[1]},{i[2]},\"{i[3]}\",\"{i[4]}\",\"{i[5]}\");")
    txt.write("\n")
#     mycursor.execute(f"INSERT INTO driver(Driver_ID,Email_ID,Name,Phone_Number,Gender,Address,Avg_Rating,Driver_Status) VALUES({i[0]},\"{i[1]}\",\"{i[2]}\",{i[3]},\"{i[4]}\",\"{i[5]}\",{i[6]},\"{i[7]}\");")
#     print()
# print(count)