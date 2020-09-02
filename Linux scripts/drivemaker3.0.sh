#!/bin/zsh

# Written by Kent DuBack at Pima Community College on 8/7/2020

# GNU Parallel must be installed!

# This is an improved version of Drivemaker using GNU parralel and dd which by default are installed on most distributions and can function more universally and across more drives than my previous script Drivemaker.sh. It searches for all usb drives and then writes the image to them, and parralelizes them.

# First we get a list of all the drives in the system that are usb by searching for them
udevadm | pee "udevadm info --query=all --name=sd"{a..z} "udevadm info --query=all --name=sd"{a..z}{a..z} | grep -E \(S=usb\|\ sd\) | tr -d 'N: ' | tr -d 'E: ID_BUS=' | grep -B1 usb | grep sd | time parallel -j+0 --progress 'gunzip </home/kduback/Downloads/SCCMstick.img.gz >/dev/{}'
