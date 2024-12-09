#!/bin/bash

link="http://10.0.17.30\Assignment.html"

press=$(curl -sL "$link" | \
#xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --value-of "//table[@id='press']//tr//td" | \
awk 'NR % 2 == 1')

cnt=$(echo "$press" | wc -l)
for (( i=1; i<="${cnt}"; i++ ))
do
var1=$(echo "$press" | head -n $i | tail -n 1)
done
#echo "$press" 
