#!/bin/sh

printf "\n%s\n\n%s\n\n" "Shell Calculator" "Awaiting input:"
			
date >> /home/"$USER"/.calchist
			
while [ 1 ]; do
	
	read i 
			
	printf "%s\n" ""$i"" >> /home/"$USER"/.calchist
		
	printf "%s\n" "$(($i))" | tee -a /home/"$USER"/.calchist
done
