# Autograding

This repository contains various scripts used for grading CDA3101 assignments and automating
uploading grades to canvas. Currently, there are shell scripts for certain assignments which produce reports for each submission, and a seperate file that is used in a python script that modifies the canvas gradebook.

The python script is probably fine, though I'd like to invoke qemu and the shell scripts in it to reduce the amount of manual work. Further, I'd like to make a script that is multithreaded, and invokes a simpler child script that simply grades and outputs one submission's report, this way I can both make the script run much faster (using more resources of the emulator) and I can reduce the complexity of writing a grading script for future TAs who will write them.

## Use

The user needs to manually fetch all submissions from canvas (can download a zip), and then load those onto the emulator, to then run the shell script on, fetch the output files from the emulator, post the report on teams/TA channel, and modify the gradebook with the python script, then upload the modified gradebook to canvas to post grades (which will then be reviewed for plagiarism/sanity checked).

## TODO

Like I said I'd like to make a parent shell script that deals with multithreading the grading, and a few example child shell scripts for existing assignments. I'd also like to enumerate what is good and what is bad in an assignment that is trying to use this script, e.g. recursive programs that deal with strings are bad as segfaulting the submission to check if recursive is impossible if it segfaults on a scanf call.
