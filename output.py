a = 5
b = 0
c = 3.500000
while (a > 0):
    a -= 1
    b += 1
if (a > b):
    c = c + 10 * 2
else:
    c = c - 10 / 2
for i in range(0,3,2):
    a = b + c
    c = a + b
    b = a + c
