## Script

These two scripts are status trigger in the lightwait-stack.

### Setup

Use the `lw.sh` script for Linux, Mac OS and Cygwin and use the `lw.bat`.  
In both scripts, the variable `LW_SERIAL` in line 3 can be used to select the program for the serial communication.

Make the script available on the command line:

* Link it to a bin folder which is in the PATH variable
    * `ln -s /path/to/lw.sh /usr/local/bin/lw`
    * `ln -s /path/to/lw.sh ~/bin/lw`
* Add the folder containing the script to your PATH

Use:

* `python lightwait.py` for python
* `lightwait` for go on Linux or Mac
* `lightwait.exe` for go on Windows 

### Usage

`lw <task> <task parameters>`
e.g.:

    lw mvn clean install
    lw java -jar calculation.jar
    lw mkfs.vfat /dev/sdb1
    lw rsync --numeric-ids -avze ssh /home/user user@example.com:/backups 

* It turns blue, when the task starts
* It turns green, once the task is succesfully finished
* It turns red if the task returns an error code other than 0
* Press Enter to complete the lw task. The LED turns off