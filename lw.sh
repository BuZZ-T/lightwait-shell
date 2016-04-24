#!/bin/bash

# known variables to listen for:
# * LW_SUCCESS
# * LW_WARN
# * LW_RUNNING
# * LW_CONFIRM_EXIT: set to 1 to confirm to quit the bash script with enter. Set to 0 to disable it. Default is 1
# * LW_OFF_ON_EXIT: 

LW_SUCCESS_COLOR="green"
LW_WARN_COLOR="yellow"
LW_RUNNING_COLOR="blue"
LW_FAILED_COLOR="red"
LW_END_COLOR="off"

CMD=${0##*/} 

if [[ $1 == "-h" ]]; then
cat << EOF
usage: $CMD [-w|-c <green_line_string> <blue_light_string>] <task>
	-w: grab the std output with strict string compare (must match the complete line)
	-c: grab the std output with loose string compare (only needs to match part of the line, useful if the output is prefixed with timestamps)
	green_line_string: if the task print this string to the stdout, the light goes to green
	blue_line_string: if the task print this string to the stdout, the light goes back to blue
	task: the task (including parameters and flags) which should be executed
EOF
exit 0
fi

# uncomment for python version
#LW_SERIAL="python lw.py"
# uncomment for go version
# LW_SERIAL="lightwait"
# use just echo for testing
LW_SERIAL="echo"

if [[ $# < 1 ]]; then
	echo "no parameters given!"
	exit 1
fi

if [[ -n ${LW_SUCCESS+x} ]]; then
	echo "LW_SUCCESS is set: $LW_SUCCESS"
	SUCCESS_TEXT=$LW_SUCCESS
fi

if [[ -n ${LW_RUNNING+x} ]]; then
	echo "LW_RUNNING is set: $LW_RUNNING"
	RUNNING_TEXT=$LW_RUNNING
fi

# send the "started" signal
$LW_SERIAL $LW_RUNNING_COLOR &

# check for known frameworks to watch
case $1 in
	"--webpack")
		SUCCESS_TEXT="webpack: bundle is now VALID."
		WARN_TEXT="webpack: Compiled with warnings."
		RUNNING_TEXT="webpack: bundle is now INVALID."
		# "webpack: Compiling..."
		STRICT=true
		TASK=${@:2}
		;;
	"--jetty")
		SUCCESS_TEXT="jetty success"
		WARN_TEXT="jetty warn"
		RUNNING_TEXT="jetty running"
		TASK=${@:2}
		STRICT=false
		;;
	"-w")

		echo "-w length: $#"

		SUCCESS_TEXT=$2
		RUNNING_TEXT=$3
		TASK=${@:4}
		STRICT=true
		;;
	"-c")
		SUCCESS_TEXT=$2
		RUNNING_TEXT=$3
		TASK=${@:4}
		STRICT=false
		;;
	*)
		;;
esac

# test if all three variables exist
if [[ -n $SUCCESS_TEXT && -n $RUNNING_TEXT && -n $TASK ]]; then
	echo "$CMD: success on $SUCCESS_TEXT";
	echo "$CMD: running on $RUNNING_TEXT";
	echo "$CMD: warning on $WARN_TEXT";
	echo "$CMD: exec: $TASK"

	if [ $STRICT = false ]; then
		SUCCESS_TEXT=*"$SUCCESS_TEXT"*
		WARN_TEXT=*"$WARN_TEXT"*
		RUNNING_TEXT=*"$RUNNING_TEXT"*
	fi

	# exec the task in background and
	# pipe the output to file descripter 3
	exec 3< <($TASK)

	# read line from file descriptor 3 when available
	while read -r -u 3; do
		case "$REPLY" in
			$SUCCESS_TEXT)
				$LW_SERIAL $LW_SUCCESS_COLOR &
				;;
			$RUNNING_TEXT)
				$LW_SERIAL $LW_RUNNING_COLOR &
				;;
			$WARN_TEXT)
				$LW_SERIAL $LW_WARN_COLOR &
				;;
			*)
				;;
		esac
	done

	# close file descriptor
	exec 3<&-

else
	$@
fi

if [[ $? -ne 0 ]]; then
	$LW_SERIAL $LW_FAILED_COLOR &
else
	$LW_SERIAL $LW_SUCCESS_COLOR &
fi

if [[ -z $LW_CONFIRM_EXIT || $LW_CONFIRM_EXIT -eq 1 ]]; then
	read
fi

if [[ -z $LW_OFF_ON_EXIT || $LW_OFF_ON_EXIT -eq 1 ]]; then
	$LW_SERIAL $LW_END_COLOR &
fi
