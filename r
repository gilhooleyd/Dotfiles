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

def cdstring(folder):
    return "cd " + folder + "/ ; "
def cdCWDstring(folder):
    return "cd " + TOP + "/" + folder + "/ ; "

args = sys.argv
folders = []
TOP = ""
CWD = os.getcwd()

if not("TOP" in os.environ):
    print("PLEASE SET TOP VARIABLE")
    exit(1)
TOP = os.environ["TOP"]
info_f = TOP + "/r-helper"

# load in file
f = open(info_f, "r+")
for s in f:
        s = s.strip()
        if not(s in folders):
            folders.append(s)
f.close()

f = open(info_f, "a+")

if (args[1] == "start"):
        toplen = len(TOP)
        if TOP != CWD[:toplen]:
            print("Must be inside TOP")
            exit(1)
        folder = CWD[toplen:]
        f.write(folder + "\n")
        subprocess.call(cdCWDstring(folder) + "repo start " + args[2], shell=True)

elif (args[1] == "start-all"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call(cdCWDstring(folder) + "repo start " + args[2], shell=True)

elif (args[1] == "status"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call(cdCWDstring(folder) + "git status ", shell=True)
            subprocess.call(cdCWDstring(folder) + "git changes", shell=True)
            print("")

elif (args[1] == "checkout"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call(cdCWDstring(folder) + "repo start " + args[2], shell=True)
            print("")

elif (args[1] == "branch"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            extra = ""
            if len(args) >= 3:
                extra = " ".join(args[2:])
            subprocess.call(cdCWDstring(folder) + "git branch " + extra, shell=True)
            print("")

elif (args[1] == "sync"):
        subprocess.call(cdCWDstring(folder) + "repo sync -j4 -c --no-tags ./", shell=True)

elif (args[1] == "update"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call(cdCWDstring(folder) + "git rebase HEAD@{upstream}", shell=True)
elif (args[1] == "run"):
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            subprocess.call(cdCWDstring(folder) + " ".join(args[2:]), shell=True)
elif (args[1] == "rebase-all"):
        branches = subprocess.Popen(cdCWDstring(folders[0]) + "git branch",
                shell=True, stdout=subprocess.PIPE).communicate()
        for folder in folders:
            print(colored(folder, bcolors.OKGREEN))
            for branch in branches[0].split("\n"):
                if (branch == None):
                    continue
                branch = branch.replace("*", "")
                print(colored(branch, bcolors.OKGREEN))
                err = subprocess.call(cdCWDstring(folder) + " git checkout " +
                            branch + " ; git rebase HEAD@{upstream}", shell=True)
                if err != 0:
                    exit(1)

elif (args[1] == "sync-all"):
        subprocess.call(cdCWDstring(CWD) + "repo sync -j4 -c --no-tags", shell=True)

elif (args[1] == "save-all"):
        subprocess.call("mkdir -p " + args[2], shell=True)
        for folder in folders:
                print(colored(folder, bcolors.OKGREEN))
                subprocess.call("mkdir -p " + args[2] + "/" + folder, shell=True)
                subprocess.call(cdCWDstring(folder) + "git format-patch -o " + args[2] + "/"
                        + folder + "/ HEAD@{upstream}..", shell=True)

elif (args[1] == "restore-all"):
        subprocess.call("mkdir -p " + args[2], shell=True)
        for folder in folders:
                print(colored(folder, bcolors.OKGREEN))
                subprocess.call("mkdir -p " + args[2] + "/" + folder, shell=True)
                subprocess.call(cdCWDstring(folder) + "git am -3 " + args[2] + "/"
                        + folder + "/*", shell=True)

else:
    print ("COMMAND NOT SUPPORTED")
    exit(1)
