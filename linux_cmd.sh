cd ~  # sends you to home directory

cd 'name'  # changes the directory to 'name'

mkdir 'name'  # creates the 'name' directory

mkdir -p folder1/folder2/folder3  # creates nested folders inside each other

rmdir 'name'  # remove the 'name' directory (if the directory is empty)

rm -r folder  # removes folder and everything inside it (for nested folders)

rm 'name'  # removes the file 'name'

rm *  # deletes all file and directories in current directory

ls  # lists all files in the current directory

ls -l  # lists all files with permissions, ownership, group, size in current directory

ls -lh  # same as above but shows size in kilobyte instead of bytes

ls -lh file1  # will show all propeties about this file

ls -a  # lists all files (including hidden files)

ls -la  # mix of "ls -l" and "ls -a"

cd ..   # go to parent directory

cd ../..  # go two directories back

cd -  # show info of prevoius directory

\n   # new line within paragraph

pwd   # shows the current directroy with it's full address

touch   # create an empty file

d: directory / c : character device / b : buffred device / l : soft link to the file 

touch text  # create a textfile named 'text' (only if there is NOT a file named 'text' in this directory)

touch {babak, ali, hasan, omid}  # will create four files with given names

touch file_{01..1000}   # creates files file_01, file_02, ..., file_1000

echo blahblahblah   # print the 'blahblahblah' on the screen

echo blahblahblah>text   # put the string 'blahblahblah' inside a text file named 'text'

echo {1..10..2}  # 1 3 5 7 9     
echo {1..10..3}  # 1 4 7 10    
echo {A..Z}      # A B C ... Z

cat text   # show content of a text file named text on the screen

touch text1 text2 text3   # create 3 text files named text1, text2, text3

cat text text2 text3   # shows text files one after another

mv tex* dir1/subdir1/   # move any file in the current directory with starting name 'tex' to the other specified directory

?  # every character is possible (but only one)

*   # what ever character is possible

[]   # a range of characters and numbers [A-Z] or [a-z] or [0-9]

mv filename1 filename2   # change name of file from first one to the second one

mv fileOne Directory1/  # moves a file to a directory

mv fileOne Directory1/fileTwo   # moves file to a directory and gives it a new name

cp fileOne fileTwo  # creates copy of a file

cp folder1/file1 folder2/fileCopy   # copies a file and creates a copy of it in another folder

nano file.text   # will open a text file in nano text editor (if doesnt exist it will create it)

ispell fileone   # will open the textfile and check all spells and show correct words if we have any mistakes

sort textOne   # sorts the textfile based on alphabet

<   # is an input stream that gets data from a textfile or command  :   prog1 < file.txt

>   # is an output stream that writes to a textfile : ls -a > textone : gets the list of files with permission in this folder and saves it inside a text file.

>>  # appends text to another textfile (the first one must be already created) i.e : cat text|tr s S >> text

tr s S  #  this command will change all character s in the textfile to S, i.e : tr r R<text1>text2 : here we got text from text1 then changed all r to R then created text2 and added the text to it.

clear   # clears the terminal from any written word

tree   # will show the folder system tree of the current folder and its subfolders

diff fileOne FileTwo   # compares two textfiles and when there is a difference it shows both lines in both files

passwd   # with this command you an change the password for this user

variable=randomName   # how to create variable in terminal

echo $variable  # how to echo variable 

info nameOfCommand   # gives information about that command

# if you press the 'up' arrow it will show all the prevoius written commands 

# if you want to write a file with space in it's name in the terminal use \ for spaces, i.e : best movies =>  best\ movies

exit   # will exit the command prompt

|   # pipe : gets output of one command and uses it as input of another command : cat diary | grep Bobby : it opens the textfile diary then searches for the word Bobby with grep command

prog1 | prog2 | prog3   # get output of program1 feed it to program2 then get output of program2 and feed it as input to program3 

prog1 && prog2  # if the first command runs succesfully then runs command two other wise it stops : ls -lh file1 && echo "file1 is here"

find log   # finds all files that have the name 'log' in current directory

man ls   # shows the manual page related to ls. you can leave that page by hitting key 'q'

more text1  # opens and shows the textfile inside the terminal

less text1  # opens and shows the textfile inside a reader application

date  # shows the current date inside the terminal

date +"%d-%m-%y"   # will show results like 17-02-2016

date +"%H-%M-%S"  # shows hours-minutes-seconds

Ctrl+z  # sends the current open program to background

bg   # shows list of all programs in background

fg 'numberOfProgram'  # sends the program with specific number to foreground (AKA maximize it)

bash name.sh  # how to open a shell script (.sh) file from terminal

Ctrl+c  # terminate the current program/command

tac text1   # displays text file in reverse order (end to start)

rw text1   # reads file from right to left (for arabic text)

cd  # will take u back to your home directory

# in linux use shift+insert for pasting (instead of Ctrl+p)

wget downloadLink  # will download the file from internet to the current directory

GRUB  # is the GRand Unified Bootloader, a very powerful newish BootLoader that can be used to boot most operating system on the intel platforms

/sbin/ifconfig   # shows the state of physical and virtual network configurations

soft link  # just links to another location on system. it doesn't have to always pin to another real file

sudo -i   # will change you from normal user to root (write 'exit' command to exit out of root access)

ls > /dev/null  # will send results to empty place

sudo ifconfig  # gives info about all network adapters and their ip and mac addresses

sudo dhclient  # it will release and renew the ip address

# this command will restart the network setting (use it if you have changed the network settings)
sudo /etc/init.d/networking restart  

# ================================= Install Programs =================================

sudo  # super user do

sudo apt-get update   # updates the apt-get tool

nameOfProgram -version  # how to check if u have already installed a program 
java -version  php5 -version  # if it is installed it will show the info about it.

sudo apt-get install nameOfPackage   # this will install the package that you want. i.e : 
sudo apt-get install java

# ================================= COMPRESS and DECOMPRESS files/folders =================================

gzip file1  # compresses the file into file1.gz

gunzip file1.gz  # decompresses the file1.gz back into file1

tar cvf name.tar folder1/   # this command will create a archive file named 'name.tar' from the folder 'folder1'

tar xvf name.tar   # will extract the archived file

tar cvf Boby.tar file1 file2 file3   # this command will create a tar file named Boby.tar from 3 other files

# ================================= HEAD and TAIL =================================

head -n nr  # displays the first number heading lines of text : 
ls -l | head -n 5

head -n -nr  # displays all lines except the last nr lines 
cat text.txt | head -n -5  # (shows all lines except last 5 lines)

tail -n nr  # displays the last nr lines
cat userLog | tail -n 5  # (shows the last 5 lines)

tail -n +nr  # displays from the line having number nr to the end of file 
ls -lah | tail -n +10   # (shows lines from line 10 to the end)

WC -l filename  # show number of lines in the file

find . -maxdepth | typed |wc -l   # will show the number of file in the current directory

head file.txt  # shows first few lines of the file

tail file.txt  # shows last few lines of the file

# ================================= Grep =================================

grep  # searches a string for some text or a word

grep "word" file  # searches for a specific word / text inside a text file 
grep "Bob" users.txt

grep "string" file_pattern  
grep "Bob" text*   # will search for word Bob in all files that start with word text

grep -i "sTrIng" file   # will do case-insensitive searching
grep "Bob" textfile  # will search for all variations of Bob, boB, BoB, BOB,...

grep "REGEX" file
grep "usern*" users.txt  # will search and find all strings like username, username1 , usernameX, ....

grep -w "string" file 
grep -w "ok" stroy.txt  # will only find full word ok and not okay or okaaay,....

grep -A nr "string" file  
grep -A 5 "Bob" users.txt  # will show nr lines after the first occurance of the word 

grep -B nr "string" file 
grep -B 3 "Joe"  # will show nr lines before occurance of the word

grep -C nr "string" file 
grep -C 2 "Claire" names.csv   #  will show 2 lines before and two line after the first occurance of word Claire

grep -c "string" file  
grep -c "poor" economy.text  # will show number of times it found the word inside the text file.

grep -v "string" file 
grep -v "good" story.txt  # will show all the lines that do NOT contain the word 'good'

wc -l  # will show the number of lines 
grep -v "good" story.txt | wc -l  # shows number of the lines that do not have the word 'good'

grep -o -b "string" file 
grep -o -b "randomWord" story.txt  # will show position of the matched string inside the line that happened

grep -n "string" file 
grep -n "teacher" list.txt  # will show the number of each line where this word occures

# ================================= Cut =================================

cut -c1,5 textfile  # shows from first to fifth character of each line of the text file

cut -b1,3 textfile   # shows first to third character of each line of the file

cut -d " " -f1  # will only show the first column of text file (columns defined by space between them)

cut -d " " -f1,2   # same as above but selects both fields one and two

cut -d : -f1,3   # will select fields one to three (fields defined by : between them)

# ================================= Sed =================================

sed -n 1,60p file.txt   # will print lines 1 to 60 of text file on the screen

sed 5,10d file.txt  # will hide lines 5 to 10 and show all other lines

sed -n /string/p file.txt  # will only show lines that contain the string

sed -n /string1/,/string2/p file.txt  # will show from the line that contains string1 and end with the line that contains string2

sed -n /^bob/p file.txt   # will only show the lines that start with string bob

sed s/string1/string2/g file.txt  # shows all the text but changes all string1 to string2 inside the file

sed 's/^/ /' file.txt   # adds a space at the start of each line when showing the text

sed '2,5s/^/ /' file.txt  # same as above but only for lines 2 to 5

sed '55,60s/^/\n/' file.txt  # adds one line before lines 55 to 60

sed '10,14s/$/\n/' file.txt  # adds one line after line 10 to 14

cat auth.txt | awk {'print $12'}  # this will show the 12th phrase of each line on the screen (divided by space)

# ================================= Find =================================

find <path> <search criteria> <action>  # syntax of a search command

find . -type f -name abc.txt  # will only search for files, in current directory (and the sub directories inside it), with the name abc.txt         find / -type d = will only search for folders in all the hard drive

find . -type d -iname bob  # will search in current directory for directories named bob in case-insensitive way

find . -type d -name *.txt  # finds all files with extention .txt in current directory and it's sub-directories

find / -type f -perm 0777   # will find all files with 777 permission 

find . -type f -perm 0755 -exec chmod 777 {} \;  # will find all files with permission 755 in current folder and change their permission to 777,   -exec = means execute

find . -mtime +1   # finds all files and folders that were modified in more than one day before (more than 24 hours)        
find . -mtime -1   # modified less than one day ago (in last 24 hours)        
find . -mmin -30   # modified less than 30 minutes ago

find . -type f -mmin +10 -mmin -30  # finds all files in current directory that were modified in more than 10 mins and less than 30 minutes ago

find / -size -1M  # finds all files and folders that their size is smaller than one megabyte

find / -size +10M -size -30M  # finds all files,folders with size bigger than 10mb and smaller than 30mb

find . -maxdepth 1 -name *.txt  # will only find files in current directory (and NOT sub-directories)

# ================================= Link =================================

ln -s addressOfFile addressOfLink   # creates a soft link between two files/directories     
ln -s abc.txt abc_soft.txt

ln addressOfFile addressOfLink  # creates a hard link

# links are deleted like normal files with "rm" command

soft link   # is just a pointing system like hyperlinks in web, it will not work if you delete the actuall file

hard link   # is actually a exact copy of the original file, even if you delete the file it will still be available

# ================================= USERS =================================

# whenever you create a new user, linux automatically creates a group for that user with the same name.

cat ./etc/passwd   # shows list of all users, only who have /bin/bash in the end are real users

cat ./etc/group  # shows list of all groups

cat ./etc/shadow   # shows password for all users (encrypted)

ls /home/   # lists home directory for all users of this system

sudo useradd name   # adds a new user to the system

sudo useradd -m -d /home/customName name   # adds user to the system with custom home directory name

sudo passwd name   # changes/gives a new password to the user

sudo userdel username  # will delete the user from this system

sudo usermod -L username  # locks the account so the user can not login to his account

sudo usermod -U username  # unlocks the user account

# ================================= CHMOD =================================

chmod # change mode

chmod code nameOfFile

3 digit code # user , group , others

# read => 4 , write => 2 , execute => 1 , 7 => read + write + execute    0 => no permission

chmod 777 nameOfFile  # means that everyone can do what ever they want

chmod 444 nameOfFile  # means that all users only have permission to read

# when u type "ls -a" the shown files either start with "-" or "d" : - => means file , d => means directory

# r => read  w => write  x => execute

rwx  # permission to read, write, execute

r--  # permission to read only         
rw-  # permission to read and write only      
--x  # permission to execute only

- rwx rw- r--  # this is a file, read/write/exceute for owner, read/write for group,  read-only for all others (i.e : permission to change a webpage in a website)


# u = user   g = group   o = other people

# how to add permission : 
chmod o+w fileOne   # this will add the writing permission to all other people for fileOne

# how to remove permission : 
chmod o-w fileOne   # this will remove the writing permission from all other people for fileOne

chmod g-w-x fileOne  # remove permission to write and execute from group

# ================================= CRON =================================

crontab -l  # lists all crons that this user has created

crontab -e   # edit / create cron

# system of writing a cron job :
# (minute) (hour) (day of month) (month of year) (week day) (the command to be executed) 

# minute = 1 to 60    hour = 1 to 24    day = 1 to 30     month = 1 to 12     week day = 1 to 7   

* * * * * echo "hi there" >> /home/bob/Desktop/text.txt  # will add a string to the text file every minute of hour of day of month and weekday (basically every minute)

sudo ls var/spool/crontab/  # will show list of all cron jobs for this user

15 10 1-10/2 * 5  echo "everything looks good?" >> /home/bob/Desktop/filetext.txt  #  min 15 of hour 10 of days 1,3,5,7,9 of every month and every friday(5 of 7) append the string to this address

* 12 12,13,14,15 * 3,7  # every minute of hour 12 of days 12,13,14,15 of every month and days 3 and 7 of the week

/etc/cron.allow  #  here you can ban users from creating crons

# if you are root, you can edit an spesific user's cron : crontab -e -u username


# ================================= SSH =================================

# how to connect to server computer through ssh :  
ssh username@ipaddress    i.e :  ssh root@52.49.96.196
# then  write yes (since it's first time connecting to this system) and then enter password to connect to the server 
# computer.

# passwords for websites can be hacked but SSH keys can not be hacked.

# this will generate two ssh codes (one for your computer and one for the public key)
ssh-keygen -t rsa   

# this command will set the ssh key for your server, after this when u want to log in the server it will automatically check ssh key on server with your private ssh and you dont need to write password.
ssh-copy-id username@ipaddress

# this will open the configuration files about the ssh with the nano text editor, inside the file there is a section 'PermitRootLogin' 
nano /etc/ssh/sshd_config
# change 'Yes' to 'without-password', then press Ctrl+x to save and quit the config file. from now the users can only 
# login to server with ssh.

reload ssh   # write this command whenever you make changes to ssh so it will be updated.

# ================================= SFTP ================================
# sftp is a combination of ftp and ssh, you can transfer files from your own computer to the server through the 
# ssh protocol.

# Upload file/folders to server :

1- sftp username@ipaddress : sftp root@52.19.92.15  # this will start the sftp connection to transfer files

2- cd ../..  # go to directories back so that you are in the root directory of the server, if you do ls -la you should see folders with root owner

3- cd var/www/html  # go to html folder, this is where all the files that will be shown in your website are saved at.

4- put addressOfFileOnYourPc : put Desktop/index.html  # this command will put files from your pc to the current folder inside the server (when you are in sftp mode)

# for puting a directory inside the server :
# create a directory(with same name) in server 
mkdir directroyName
# this will put everything inside that folder in the new folder that we created on server
put -r addressOfFolder : put Desktop/books 


# Download file/folders from server :
# will save the file from server to custom directory in our computer
get nameOfFile addressTobeSaved/newName : get index.html Desktop/random.html  
# will save entire content of a directory on server to new directory on our computer
get -r nameOfFolder addressTobeSaved/newName : get -r html Desktop/randomFolder  

# ================================= PROCCESS ================================
# a process is any running program or command

ps  # will show all the procceses running right now

PID  # is the number associated with this process

TIME  # is the time it took for cpu to run this process

# when you run a command in terminal you can't run any other command until the first process is done

Ctrl+c  # terminates the running process

command &  # will run the process in the background so you can run other commands in terminal : 
xlogo &

# a job is another kind of PID
jobs  # will show all running jobs with their job number

fg %job number  # sends a job from background to foreground, i.e : 
fg %1

Ctrl+z  # pause / stops a running process, you can not kill a process while it's paused

kill PID  # will terminate a process

kill 9 PID  # terminates a process immediately (use with caution), 9 here is a immediate kill signal

sudo killall proccessName  # will kill all the processes with this process name

pkill proccessName  # sends kill signal to all the processes that have full or part name of this proccessName

kill -STOP PID  # will pause a process

kill -CONT PID  # will continue the process

top  # lists all processes with their usage of cpu and memory

# 'init' is the first process in linux system, always have 1 pid

# all processes except 'init' have parent process. parent process clones (forkes) itself and the clone process calls 
# the needed child process to run

ps aux | grep proccessName  # will search and list all proccesses related to that process name

# 4 states of a proccess : 
# runnable => it can run the next time cpu has some free percentage 
# sleeping => the process is waiting for something (like user input or cd-rom input)
# zombie => the process is finishing what it's doing and is waiting to give back the results and be killed
# stopped => a process that has been paused by a signal by another process or the user and is wating to be continued

sudo apt-get install htop # installs htop which is a better version of top application to monitor proccesses

# Niceness of proccesses :
# when proccesses have high proirety they will be the most important procces for cpu/memory and vice versa
# highest proierty => -20     lowest proierty => 19
# if you set a proccess's niceness to 20 it will freeze the linux system since it will consume all power of the cpu

sudo renice -5 PID  # will reset the niceness of a running proccess to -5 (high proirety)

nice -n 15 nameOfProccess  # will lunch the process with nicness of 15 (low proirety)

/proc  # is the place that system saves information about all running proccesses in different folders

ls -l /proc  # will show list of all folders inside proc, each of them is named after a PID (number of a proccess)

ls -l /proc/1/  # shows info inside the PID one folder (init proccess is always 1), 
# comm => name of proccess 
# cmdline => address of where the proccess is being executed

# ================================= Hashing ================================

# how to check the HASHED file :
# when u download a file from internet if the file that you get is the same as the one on the site they both sould have 
# the same hash code. (otherwise some hacker is sending you a virus file)

# for SHA-1 hash write 'sha1sum nameoffile' command and it will give the hash code for the file.

# comparing the hash of a file with given hash : 
sha1sum bloodyFile | grep randomhash1213dfkjshjf43242lknf  
# if it returned the searched (greped) hash text then it is the same file.

# ================================= Partion and HardDrive ================================

# hard drives and devices on linux are called like : sda, sdb, sdc,....

# each partion of a hard drive is called like : sda1, sda2 or sdb1, sdb2,...

# file formats exclusive to linux are ext3, ext4

# fat32, nfts are cross platform file formats for both linux and windows

# how to create partions :
1- sudo apt-get install gparted  # it is a visual program to create partions

2- sudo gparted  # open the program

# 3- unmount the current partion and delete it

# 4- add new partion, align to 'mib' and as primary partion. for partion that you want to mount an linux operating system 
# use ext4 and for the one to use on both pc/linux use nfts or fat32

# ================================= Linux Directory Structure ================================

'''
        /bin   => user binaries
        /sbin  => system binaries
        /etc   => configuration files
        /dev   => device files
        /proc  => process information
        /var   => variable files
        /tmp   => temporary files
/ :
        /usr   => user programes
        /home  => home directories
        /boot  => boot loader files
        /lib   => system libraries
        /opt   => optional add-on apps
        /mnt   => mount directories
        /media => removable devices
        /srv   => service data
'''