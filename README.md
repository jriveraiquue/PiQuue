#PiQuue
A Compilation of Utilities for use with the **Smartthings API**  
&nbsp;
###Program Descriptions
PiQuue contains a set of scripts and programs that allow for streamlined control over _Smartthings Enabled_ smart home devices.  
This functionality is divided amongst **several programs**, the contents of which are described below.
&nbsp;
####gdev.sh
This script is a fundamental structure piece for many of the other programs listed here. Simply it sends a **GET-DEVICE** request to the Smartthings API and formats it for viewing or use in a script.  
The script itself only takes two optional flags, -h or --help, and -q. --help is self-explanitory in its function but -q actually maniuplates output. -q allows you to filter the **Output JSON** by ID or Name (currently). This is useful if you just want to grab all the Smartthings device names or IDs quickly in a script. This script will always return each unique device on a separate line and will use new lines to separate IDs and Names into groups based on the device in reference.  
Usage: `./gdev.sh [-q|-h|--help] [options]`
&nbsp;
####smtbt.sh
In contrast to gdev this script actually has a more linear use case. Specifically it is designed to stress-test batteries in _Smartthings Enabled_ smart locks.  
The script requires that you specify a device with the `-d` or `--device=` flags. These flags expect input in the form of a DeviceID or of the Device Name (Case sensitive), these can easily be found by running `./gdev.sh`.  
The other required flag is `-b` or `--battery=`, this flag expects an interger input between 1 and 100. The number you specify here will act as the break point for the script to self-terminate at. For instance if you were ot run `./smtbt.sh -d TEST01 -b 90`, the script would continue to stress the lock TEST01 until the battery depleted to or under 90%.  
Lastly the flags `--toggle-state` and `--debug` do exactly as they imply. `--toggle-state` toggles the specified lock from unlocked/locked to the opposite state, and `--debug` ouptuts additional data to STDOUT while the program is executing.  
Usage: `./smtbt.sh -d DEVICEID/NAME -b TARGETBATTERY [--debug --toggle-state -h|--help]`

