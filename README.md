# Autograding

This repository contains various scripts used for grading CDA3101 assignments and automating
uploading grades to canvas. Currently, it is fairly limited as the user still has to export the
gradebook to their machine, run the autograde script, and reupload the modified gradebook csv file.
The goal is to add to the current script so that it uses canvas's API to access the gradebook, like other
UF associated software like Edugator (from COP3530), to automatically grade students assignments to reduce the
workload on graders.
Currently in the repository are shell scripts used in grading programming assignments one and two, that serve as
examples for similair scripts that should be written for future assignments. There is also a pa2-python.sh file that
demonstrates how a grading script should output each submission's grade, so that the python script can parse for the
associated UFID, grade, and whether or not the submission has been flagged for review.
Future commits to the repository will further increase the sophistication and extent of documentation.

## Use

As far as using the script, a shell script outputting:
  {a string containing UFID} {grade} {flagged}
This is the only condition for it to work, otherwise, the grading shell or batch script can be as complex as the
user desires.

## TODO

1. Update shell scripts to apply recent bug fixes and add comments, ideally remove current test cases
2. Add a sample directory that demonstrates how the script is intended to be run, and, with sample submissions that do not reflect current assignments
3. Integrated autograder.py with canvas's API to reduce user input
4. See if the emulator side of grading can also be completley run in a script
