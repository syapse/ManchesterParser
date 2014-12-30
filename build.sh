#!/bin/bash

# From antlr4 instructions
# OS X
# $ cd /usr/local/lib
# $ sudo curl -O http://www.antlr.org/download/antlr-4.4-complete.jar
# $ export CLASSPATH=".:/usr/local/lib/antlr-4.4-complete.jar:$CLASSPATH"
# $ alias antlr4='java -jar /usr/local/lib/antlr-4.4-complete.jar'
# $ alias grun='java org.antlr.v4.runtime.misc.TestRig'
# and then ...

antlr4 -Dlanguage=Python2 src/Erfurt_Syntax_Manchester.g

