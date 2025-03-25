#!/bin/bash

VAR = "This is a test"  # Incorrect variable assignment
echo "Hello World"

if [ $1 -eq 10 ] then  # Missing semicolon or `then` on new line
  echo "Number is 10"
else
  echo "Not 10"
fi

# Inefficient command usage
cat file.txt | grep "hello"  # Useless cat
ls -l | grep txt | awk '{print $1, $9'  # Unmatched brace

# Unquoted variable - risk of word splitting
FILE=some file.txt
cat $FILE  # This will break if FILE has spaces

# Infinite loop
while true
do
  echo "Running..."
done
