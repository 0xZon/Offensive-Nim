# RED NIM

To Compile the `.nim` files

```
    Compile for Linux
    nim c -r tcpReverseShell.nim
    
    Optimized for Size - Decreases size by about 40%
    nim c -d:strip --opt:size -r tcpReverseShell.nim
    Compile for Windows
    nim c -d:mingw -d:strip --opt:size tcpReverseShell.nim
    Establish listener on receiving host
    nc -lvp 8090
    References:
        https://trustfoundry.net/writing-basic-offensive-tooling-in-nim/

```
