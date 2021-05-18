
########################### SHELL SCRIPTS ###########################

# BASH = Bon Again SHell

# how to create a shell script 
# 1- open a new document file in any text editor
# 2- !/bin/sh  => this should be the first line a shell script, it shows the linux it is shell file
# 3- #  => any thing after this is a comment and will be ignored

# how to run a shell script 
# bash nameOfScript : bash Bobcript => this will run the script (if it has excute permission)
# 1- set the script to executable : chmod +x script.sh     
# 2- run the script : ./script.sh

echo -n "Hello"; 
echo " World"           # -n wil make sure we don't go to the next line
echo "$x is my thing "  # apple is my thing    
echo '$x is my thing'   # $x is my thing

########################### ECHO ###########################
!/bin/sh

a=babak
b="Habibnejad"
c=125

echo $a
echo $b
echo $c

declare -i d=123      # d is an integer
declare -r e=1000     # e is an read-only and can not be modified


echo $MACHTYPE      # shows type of the system
echo $HOSTNAME      # shows the host name
echo $BASH_VERSION  # shows current version of bash software
echo $0             # shows name of the running script

# Command substitution : save commands inside a variable
d=$(pwd)
echo $d

s=$(ls -l)
echo $s

# this command is for getting ping from a website :
a=$(ping -c 1 google.com | grep 'bytes from' | cut -d = -f 4)
echo $a

########################### mathematical operations ###########################
!/bin/bash

$((a+b))   # typical form of a mathematical operation in bash

d=2
e=$((d+2))
echo $e

((e++))
echo $e

((e--))
echo $e

((e+=3))
echo $e

((e-=6))
echo $e

((e*=4))
echo $e

((e/=2))
echo $e

f=$((1/3))
echo $f    # bash only works with integers, return 0

########################### comparing ###########################
!/bin/bash

# [[  ]]     1 => false   0 => true

[[ "cat" == "cat" ]]
echo $?

[[ "cat" = "dog" ]]     # both '=' and '==' work for compring strings
echo $?

[[ 20 -lt 100 ]]      # -lt = less than 
echo $?

[[ 25 -ge 25 ]]       # -gt = greater or equal >=
echo $?

a=""
b="catDog"

[[ -z $a && -n $b ]]      # -z  => check if the string is null         -n  => check if string is not null
echo $?

########################### editing strings ###########################
!/bin/bash

a="hello"
b=" World"
c=$a$b       # add two strings together
echo $c

# lenght of the string ${#a}
echo ${#a}
echo ${#c}

d=${c:4}    # the $c variable from its forth character
echo $d

e=${c:3:4}   # start at third character and show 4 characters after that
echo $e

f=${c: -4} # shows last 4 characters of string (backward)
echo $f

fruit="cherry banana apple tangerine banana cucumber banana orange"
echo ${fruit/banana/mouz}  # this will change first instnce of banana with mouz in variable fruit

echo ${fruit//banana/mouz}  # change all instances of banana with mouz in variable fruit

echo ${fruit/#cherry/gilas} # only replaces if the searched term is first inisde the variable

echo ${fruit/o*/sib}   # all words that start with o

########################### arrays ###########################
!/bin/bash

a=()
b=("apple" "cherry" "orange")

echo ${b[1]}

b[5]="kiwi"    # you don't need to populate every element of an array

b+=("mango")  # adds to the end of an array

echo ${b[6]}

echo ${b[@]}    # show all elements of an array

echo ${b[@]: -1}   # shows last element of an array

# array with key-value pairs :
declare -A myArray

myArray[color]=blue
myArray["my office"]="L A"   # if the key or value have space in them you should use ""

echo ${myArray[color]}
echo "the city that I live in is ${myArray["my office"]}"

# this is a  sign to show end of text and will not be shown  when you run the script
cat  << EndOfText     
fdfsdfdsf
dsfsdfsdf
dsfsdfsdf
EndOfText


# the '-' after '<<' removes the tabs from start of lines when showing them on the screen
cat <<- EnditBro     
 	dsfsdfsf
		weruwepruwe
toprtuoieurt
		zxcnv,zmv
EnditBro

########################### if ###########################
!/bin/bash

if
a=3
if [ $a -gt 4 ]; then
	echo "$a is greater than 4"
else
	echo "$a is not greater than 4"
fi


b="44this is my string!"
# [0-9]+ : is a regular expression and means if there is one or more number inside the string
if [[ $b =~ [0-9]+ ]]; then
	echo "There is a number inside the string : $b"
else
	echo "there is no number inside the string : $b"
fi

########################### while loop ###########################

# while loop works when the expression is true
i=0
while [ $i -le 10 ]; do
	echo i: $i
	((i++))
done

# until loop works when the expression is false
j=0
until [ $j -ge 10 ]; do
	echo j: $j
	((j++))
done

########################### for loop ###########################

for i in 1 2 3 4 5
do
	echo $i
done


for j in {1..10..2}
do
	echo $j
done


for (( z=0; z<=10; z++ ))
do
	echo $z
done


arr=("apple" "banana" "cherry")
for x in ${arr[@]}
do 
	echo $x
done


declare -A arrr
arrr["name"]="Bob Habib"
arrr["id"]="1031B"
# ! in ${!arrr[@]} means that $v is the key and not the value
# we put array element inside "" since there may be space in the string
for v in "${!arrr[@]}"
do
	echo $v: ${arrr[$v]}
done

########################### case ###########################
a="cat"

case $a in
	cat) echo "it's a cat !";;
	dog|puppy) echo "it's a dog";;   # it will accept either dog or puppy
	*) echo "no match :( ";;
esac

########################### function ###########################

function greeting {
	echo "Hi there $1"
	echo "it's a nice $2 ain't it?"
}

# how to call a function :
greeting Bob Day
greeting friend evening


# function that accepts array/list
function numberThings {
	i=1
	for f in $@; do      # $@ means all elemnts inside the list/array
		echo $i: $f
		((i+=1))
	done
}

numberThings $(ls) # passing command to the function

numberThings apple pineapple applePie 

########################### send data to script ###########################

echo $1
echo $2

# when you want to send a list/array of argument to the script:
for i in $@
do
	echo $i
done

echo "number of arguments: $#"  #  $# shows number of entered arguments

########################### send data with flag ###########################

# flags
# u: and p: means you write -u/-p and some data after them.
# in the case if you entered -u before data it will asign it to username and if it was -p it will be password
# $OPTARG is the data that you enter

while getopts u:p: option; do
	case $option in
		u) user=$OPTARG;;
		p) pass=$OPTARG;;
	esac
done

echo " $user  /  $pass "

########################### send data with read ###########################

echo "what is your name?"

# read command waits for user's input
read name

echo "what is your password?"

# read -s : it will not show what user has typed
read -s pass

# using read without echo command with 'read -p' , it will do everything in one line
read -p "what is your favorite animal?  " animal

echo "name : $name, pass : $pass, animal: $animal"


#this is a select menu and user enters the number of their selected item :
select favAnimal in "cat" "dog" "bird" "fish" "reptile"
do
	echo "you selected $favAnimal"
	break
done

########################### check read data ###########################

read -p "favorite animal? " a

# this will repeat the question untill user actually types something
while [[ -z $a ]]; do
	read -p "favorite animal? " a
done
echo "$a was selected"


read -p "what year [nnnn] ? " b

# here we check if user wrote a 4-digit number with regular expressions:
while [[ ! $b =~ [0-9]{4} ]]; do
	read -p "enter a valid year [nnnn] ? " b
done
echo "you selected year $b"

