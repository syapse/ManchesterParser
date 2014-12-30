# (c) 2014 Syapse, Inc.
# See LICENSE.txt, MIT License

import sys

from antlr4 import *
from Erfurt_Syntax_ManchesterLexer import Erfurt_Syntax_ManchesterLexer
from Erfurt_Syntax_ManchesterParser import Erfurt_Syntax_ManchesterParser

def main(argv):
    input = FileStream(argv[1])
    lexer = Erfurt_Syntax_ManchesterLexer(input)
    stream = CommonTokenStream(lexer)
    parser = Erfurt_Syntax_ManchesterParser(stream)
    tree = parser.description()

if __name__ == '__main__':
    main(sys.argv)

