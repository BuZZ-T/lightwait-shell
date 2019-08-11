# lightwait-shell

This repository contains scripts as simple status [trigger](https://github.com/BuZZ-T/lightwait#trigger). in the [lightwait-stack](https://github.com/BuZZ-T/lightwait).

Currently a Bash script and a Batch script with different amount of functionality is available.

 **Please note**: This is in a very early state of development. Rather stick to [lightwait-go-shell](https://github.com/BuZZ-T/lightwait-go-shell)!

## Setup

* Use the `lw.sh` script for Linux, Mac OS and Cygwin
* Use the `lw.bat` for Windows terminal
* Set the environment variable `LW_SERIAL` to 


Make the script available on the command line:

* Link it to a bin folder which is in the PATH variable
    * `ln -s /path/to/lw.sh /usr/local/bin/lw`
    * `ln -s /path/to/lw.sh ~/bin/lw`
* Add the folder containing the script to your PATH

## Usage

`lw <task> <task parameters>`
e.g.:

```bash
lw mvn clean install
lw java -jar calculation.jar
lw mkfs.vfat /dev/sdb1
lw rsync --numeric-ids -avze ssh /home/user user@example.com:/backups 
```

* It turns blue, when the task starts
* It turns green, once the task is succesfully finished
* It turns red if the task returns an error code other than 0
* Press Enter to complete the lw task. The LED turns off

## TODOs
* Add a `lw.ps1` script for Windows Powershell
* Rename the variable `LW_SERIAL` to `LW_TRANSMITTER`.
* Implement logic in the batch file
