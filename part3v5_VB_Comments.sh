#!/bin/bash

#Author: Bianca Van Der Merwe
#ID: 10389192

echo "The aim is to be able to download ALL IN RANGE thumbnais"
 

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > rand.txt        #writting the html text into the rand.txt file
cat rand.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' | sed -e 's/^DSC0//' | sed -e 's/.jpg$//' > randlist.txt      
                                        #while looking at the rand.txt file, stip out all the html, look at everything that has the .jpg on the end
                                        #using sed - delete everything that starts with DS0 and ends with .jpg save it to randlist.txt

awk 'BEGIN {FS="^"; print "\n"}{ ORS=" "; print "\t"}{print ; if(++onr%10 == 0) print "\n"}' randlist.txt #while using the file seperate, print that on a new line
                                                                                                            # Output record separator prints a space between the output, and tab's then to the righy
                                                                                                            #in one line, if the vairables are more than 10 print it in a new line.
echo -e "\n\n"  #printed a new line for visual purposes



#grep "$minrange" | sed -e "/$minrange/d" randlist.txt > newrand.txt | awk 'BEGIN {FS="^"; print "\n"}{ ORS=" "; print "\t"}{print ; if(++onr%10 == 0) print "\n"}' newrandlist.txt
# read -p "what is the minimum: " minrange | grep "^.\?[0-9]*$" #setting loer bound


#VB: I suggest a) request lower bound and check it exists in your list in randlist.txt
#VB I suggest assigning $minrange to some variable, e.g $exists to then hand to grep and then count the results
#VB if count is 0 then the entered value is invalid, lopp back and have user try again
#VB all enclosed in a while true; do loop that can only "break" out of when a valid match in randlist is found, e.g

#VB SAMPLE ##########
while true; do
read -p "what is the minimum: " minrange
exists=$( grep $minrange "randlist.txt" | wc -l )
if [[ $exists -eq 0 ]]; then
    echo "Sorry, that is not a valid thumbnail name. Please try again."
else
    echo "Range minimum set is DSC0$minrange.jpg"
    break
fi
done
#VB /SAMPLE ##########

# Then I suggest repeating the process for the upper bound of the range, which is essentially the same code blcok with minor adjustments for $maxrange
# Then the retrieval component would be a loop soemthing like this:

#VB It's then here you would fo your IF $maxrange -le $minrange THEN sorry, that's not a valid range, please try again.
#VB But as time is short, you might elect to skip this nicety :-)

let maxrange=1693 #VB I'm just setting this temporarily for the demonstration below.

#VB SAMPLE ##########
for ((i = $minrange ; i <= $maxrange ; i++)); do
  isinlist=$( grep $i "randlist.txt" | wc -l )
    if [[ $isinlist -eq 0 ]]; then
        continue
    else
    wget https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC0$i.jpg # This is where you would hand the wget output to grep then awk to get the_
    # image size so you can output your message echo "Downloading DSC0$i.jpg with a file size of $2 (awk line item 2 for example)
    fi
done
#VB /SAMPLE ##########

# read -p "whatis the maximum: " maxrange | grep "^.\?[0-9]*$"  #setting upper bound                                                                              
                                                                 #unsure how to error check? Should i do a seperate if statement for both?
   

#if [ "$minrange" -lt "$maxrange" ]; then        #anything smaller than $minrange and anything bigger than $maxrange
 #   echo "lower bound is smaller"               #delete or ignore
#else
   # echo "upper bound is bigger"                #for anything else downloand
#fi