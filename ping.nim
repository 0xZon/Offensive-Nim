#This script is a simple POC to test icmp requests using nim
#To compile
#nim c -d:mingw -d:strip --opt:size pinging.nim

import osproc

let ping = execProcess("cmd /c ping REMOTE_IP")