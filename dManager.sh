#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Download Manager by github.com/mirkancal"
TITLE="Download Manager v1.0"
MENU="Choose one of the following options:"
DPATH="$HOME/Downloads/"
CHOICE=""

user_input=""

OPTIONS=(1 "Set the Path for Files"
         2 "Enter the Link(s)"
         3 "Download File(s)"
         4 "View History"
         5 "Delete History"
         6 "Exit")

function enter_links {
while [[ $user_input != 0 ]];
user_input=$(\
dialog --inputbox "Enter the link(s): (0 to exit)" 8 40 \
3>&1 1>&2 2>&3 3>&- \
)
if [[ $user_input != 0 ]]; then
    echo $user_input >> $HOME/lofurls.txt
else
    user_input=""
    break
fi

do
    continue

done

clear
}

function download_files {
wget -i $HOME/lofurls.txt -P $DPATH -q 2>&1 | \
stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
dialog --gauge "Downloading the files" $HEIGHT $WIDTH
cat $HOME/lofurls.txt >> $HOME/dmlog.txt
notify-send "Download completed" "Files have been downloaded"
}

function set_path {
DPATH=$(\
dialog --inputbox "Path to save files:(Current path: $DPATH)" $HEIGHT $WIDTH \
3>&1 1>&2 2>&3 3>&- \
)
}

function view_history() {
    dialog --textbox "$HOME/dmlog.txt" $HEIGHT $WIDTH
}

function delete_history() {
    > $HOME/dmlog.txt
}

function quit() {
if [[ -e $HOME/lofurls.txt ]]; then
    rm $HOME/lofurls.txt
fi
    exit
}

while [[ $CHOICE != 0 ]]; do
CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)


case $CHOICE in
        1)
            set_path
            ;;
        2)
            enter_links
            ;;
        3)
            download_files
            ;;
        4)
			view_history
			;;
        5)
            delete_history
            ;;
        6)
            quit
            ;;

esac
done
