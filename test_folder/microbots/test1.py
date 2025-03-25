import os, sys, time, json  # Some unused imports

# Hardcoded credentials (bad practice)
USERNAME = "admin"
PASSWORD = "1234"

def myfunc()
print("Hello, world")  # Indentation error

def calculate(num1, num2)
result = num1 + num2  # Indentation error
return result

class Test:
    def __init__(self):
        self._private_var = 42  # Unused private variable

    def broken_method(self, value)
        if value == 5
            print("Value is 5")
        else
            print("Value is not 5")

for i in range(100):  # Inefficient loop
print(i)  # Indentation error

# Deep nesting with bad readability
def bad_function():
    for i in range(5):
        for j in range(5):
            for k in range(5):
                print(i, j, k)
