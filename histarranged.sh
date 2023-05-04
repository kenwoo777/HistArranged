#!/bin/bash


# histarranged.sh by ken woo v.1.0 copyleft
# the history is precious since keeping the efforts you learnt and for later looking up.
# it can 1) for keeping records unique. 2) able to handle the one which catting history files into. 3) few errors tolerance.

# !!!for beginning new history record only; otherwise old existing records will gone.!!!
# !!!only tested in Ubuntu.!!!

# need to set the following 3 lines in .bashrc at the outset.
# HISTSIZE=-1
# HISTFILESIZE=-1
# export HISTTIMEFORMAT="%F %T "

# if ran failed, (or better)change $( whoami ) to your username.

# !!!your $> history; must be in the following form:!!!
#  994709  2023-02-07 15:05:03 diff 001.txt .00MyHistBackup.sh
#  994710  2023-02-07 15:05:40 diff --color 001.txt .00MyHistBackup.sh
#  994711  2023-02-07 15:08:04 ls -la
#  994712  2023-02-07 15:10:40 vim 001.txt


cat /home/$( whoami )/.bash_history | sed ':a;N;$!ba;:c;s/\(#[0-9]*\)[[:space:]]*\(#[0-9]*\)/\2/g;tc;' | xargs -n2 -d'\n' | grep -v -q '^#.*'

if [ $? -eq 0 ]; then
    echo "The format out of order, please check first"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

TMPFILE=`mktemp /home/$( whoami )/00tmp.XXXXXXXXXX` || exit 1

cat /home/$( whoami )/.bash_history | sed ':a;N;$!ba;:c;s/\(#[0-9]*\)[[:space:]]*\(#[0-9]*\)/\2/g;tc;' | xargs -n2 -d'\n' | cat -n | tr -s [:blank:] " " | sed 's/[[:blank:]]*$//' | sort +1 | tac | sort +2 -u | sort +1 | cut -d " " -f3- | sed 's/\(#[0-9]*\) \(.*\)/\1\n\2/' > $TMPFILE

cp --remove-destination /home/$( whoami )/.bash_history /home/$( whoami )/.bash_history.bak
cat $TMPFILE > /home/$( whoami )/.bash_history

rm $TMPFILE


# end of sh
