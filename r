#!/usr/bin/env python
import sys
import os
import subprocess

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def colored(s, color):
    return color + s + bcolors.ENDC
args = sys.argv
branches = {}
folders = {}
info_f = os.environ["TOP"] + "/r-helper"

# load in file
f = open(info_f)
for s in f:
        s = s.strip()
        words = s.split(" ")
        if not(words[0] in branches):
            branches[words[0]] = []
        branches[words[0]].append(words[1])

        if not(words[1] in folders):
            folders[words[1]] = []
        folders[words[1]].append(words[0])
f.close()
# print (branches)
# print (folders)

f = open(info_f, "a+")
if (args[1] == "start"):
        if os.getcwd() in folders:
            if args[2] in folders[os.getcwd()]:
                print("That branch exists already")
                # Figure out some way to return
        f.write(args[2] + " " + os.getcwd() + "\n")
        subprocess.call("cd " + os.getcwd() + "/ ; " + "repo start " + args[2], shell=True)
if (args[1] == "start-all"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call("cd " + folder + "/ ; " + "repo start " + args[2], shell=True)
elif (args[1] == "status"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call("cd " + folder + "/ ; " + "git status ", shell=True)
            subprocess.call("cd " + folder + "/ ; " + "git changes", shell=True)
            print("")
elif (args[1] == "checkout"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call("cd " + folder + "/ ; " + "repo start " + args[2], shell=True)
            print("")
elif (args[1] == "branch"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call("cd " + folder + "/ ; " + "git branch ", shell=True)
            print("")
elif (args[1] == "sync"):
        subprocess.call("cd " + os.getcwd() + "/ ; " + "repo sync -j4 -c --no-tags ./", shell=True)
