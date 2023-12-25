#! /usr/bin/env bash

function osInfo() {
    node=$(uname -n)
    op=$(uname)
    echo
    echo "host-name $node/$op"
}

function userInfo() {
    user=$(whoami)
    echo
    echo "$user"
}

function printItemMenu() {
    echo "---------------------------------------------------"
    echo "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo "---------------------------------------------------"
}

function listFilesDirs() {
    arr=(*)
    for item in "${arr[@]}"; do
        if [[ -f "$item" ]]; then
            echo "F $item"
            elif [[ -d "$item" ]]; then
            echo "D $item"
        fi
    done
}

function fileOperations() {
    filename=$1
    while [[ true ]]
    do
        echo
        echo "---------------------------------------------------------------------"
        echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
        echo "---------------------------------------------------------------------"
        read -r command
        
        case $command in
            0)
            break;;
            1)
                rm "$filename"
                echo "$filename has been deleted."
            break;;
            2)
                echo "Enter the new file name:"
                read -r newFilename
                mv "$filename" "$newFilename"
                echo "$filename has been renamed as $newFilename"
            break;;
            3)
                chmod 666 "$filename"
                echo "Permissions have been updated."
                echo $(ls -l | grep "$filename")
            break;;
            4)
                chmod 664 "$filename"
                echo "Permissions have been updated."
                echo $(ls -l | grep "$filename")
            break;;
            *)
                operation $command
            continue;;
        esac
    done
}
function operation() {
    arr=(*)
    for item in "${arr[@]}"; do
        if [[ -f "$item" ]]; then
            if [[ "$1" = "$item" ]]; then
                fileOperations $1
                return
            fi
            elif [[ -d "$item" ]]; then
            if [[ "$1" = "$item" ]]; then
                cd "$item"
                return
            fi
        fi
    done
    echo "Invalid input!"
}

function up() {
    cd ..
}

function fileDirOperations() {
    while [[ true ]]
    do
        echo
        echo "The list of files and directories:"
        listFilesDirs
        echo
        printItemMenu
        read -r command
        
        case $command in
            0)
            break;;
            "up")
                up
            continue;;
            *)
                operation $command
            continue;;
        esac
    done
}

function menu() {
    echo
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
}

function findExecutables() {
    echo "Enter an executable name:"
    read -r executable
    path=$(which "$executable")
    if [[ -z "$path" ]]
    then
        echo "The executable with that name does not exist!"
    else
        echo
        echo "Located in: $path"
        echo
        echo "Enter arguments:"
        read -r arguments
        $executable "$arguments"
    fi
}

function start() {
    echo "Hello $USER!"
    while [[ true ]]
    do
        menu
        
        read -r command
        
        case $command in
            0)
                echo "Farewell!"
                exit
            break;;
            1)
                osInfo
            continue;;
            2)
                userInfo
            continue;;
            3)
                fileDirOperations
            continue;;
            4)
                findExecutables
            continue;;
            *)
                echo "Invalid option!"
            continue;;
        esac
    done
}

start