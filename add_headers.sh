#! /bin/bash

# usage:
# 	ls test*.txt | add_headers.sh
#  or
#	add_headers.sh test1.txt test2.txt ...
#
# assuming header data is stored in 'headers.txt' and 
# all headers start with a dash and a whitespace

# header file
HEADERFILE=headers.txt

# if headers file is missing a newline at the end, add it
if [ $(tail -c 1 $HEADERFILE) != "" ]; then
		echo "need to add new line .."
		echo -e "" >> $HEADERFILE
fi

# list of files via parameter or from stdin
files= read <<< echo
if [ $# -eq 0 ]; then
    files=$(</dev/stdin)
else
    files=$(echo $* )
fi

# loop through all files
for file in $files; do
	echo "processing $file ..."
	# backup
	mv $file ${file}.bak
	# add header to new file
	cat $HEADERFILE > ${file}
	# copy all lines not starting with dash
	sed "/^# /d" ${file}.bak >> ${file}
	# delete backup	
	rm ${file}.bak	
done
