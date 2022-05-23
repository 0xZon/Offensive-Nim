#Simple nim script to open up a link
#To compile for windows
#nim c -d:mingw openLink.nim

import browsers

block: openDefaultBrowser("https://www.youtube.com/watch?v=dQw4w9WgXcQ")