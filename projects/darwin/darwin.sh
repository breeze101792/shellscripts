# /bin/bash
hs_print "Source Darwin(dw) project"
alias dwlsport="sudo lsof -i -P | grep LISTEN | grep :$PORT"
alias dwlsport4="sudo lsof -nP -i4TCP:$PORT | grep LISTEN"
