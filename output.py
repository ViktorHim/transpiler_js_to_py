a = 5
b = 0
c = 3.500000
d = True
g = False
str = "Hello WOrld!!!"
print(g,d)
while (a > 0):
    a -= 1
    b += 1
print(a)
print(str)
print("HI!!")
if (a > b):
    c = c + 10 * 2
elif (a < b):
    c = c - 10 / 5
else:
    c = c - 10 / 2
for i in range(0,3,1):
    a = b + c
    c = a + b
    b = a + c
if (((d and g) or g) and not d):
    d = False
print(a,b,c,d)
