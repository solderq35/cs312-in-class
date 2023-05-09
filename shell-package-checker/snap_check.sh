#!/bin/bash

# Check if apt is installed and install it if necessary
if ! command -v apt &> /dev/null
then
    echo "apt is not installed. Installing apt..."
    sudo apt update
    sudo apt install apt
    echo "apt has been installed."
else
    echo "apt is already installed."
fi

# Check if yq is installed and install it if needed
if ! command -v yq &> /dev/null
then
    echo "yq is not installed. Installing yq..."
    sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
        sudo chmod +x /usr/bin/yq
    echo "yq has been installed."
else
    echo "yq is already installed."
fi

echo "Checked if apt was installed (package manager) and if yq was installed (library for reading yaml). Now let's install some packages from the packages.yaml file."

# Read package names from packages.yaml
packages=$(yq -r '.packages[]' packages.yaml)

# Loop through each package and check if it's installed
for package in $packages
do
    if command -v $package &> /dev/null
    then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing $package..."
        sudo apt update
        sudo apt install $package
        echo "$package has been installed."
    fi
done
