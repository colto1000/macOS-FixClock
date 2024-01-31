# macOS Time Synchronization Fix

## About
This is a script (that I keep in `/Applications/Utilities/Scripts`) that you can run to fix a few common issues with macOS time synchronzation. I haven't quite figured out the root cause, although perhaps this is an issue with the CMOS battery? Upon some research, others have had similar issues, so I wanted to share a script I created to help speed up the fix for this issue.

## Usage
_Before the first run, you must allow this script execution permission with: `chmod +x FixClock.sh`_

**Run with `./FixClock.sh`** and enter your root password when prompted.

**Notes:** Use this script whenever you notice an issue with your machine's time synchronization, the script will not run automatically (yet). Feel free to create a Desktop shortcut by changing the extension to `.command` and placing the script wherever you'd like, or run with the full filepath (e.g. `/Applications/Utilities/Scripts/FixClock.sh`)

## How Does it Work?
The script performs the following elevated functions:

* Deletes `/var/db/timed/com.apple.timed.plist`, which stores information about the current time server
* Enables Automatic Clock Synchronization and Network Time
* Prints to console the current time zone and time server
* Soft reboots the machine without reopening any previously-opened windows

## Compatibility
I have only tested this script with macOS Sonoma 14.1.2, but I would anticipate this would work with macOS 10.7+.
