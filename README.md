pretty-printers
===============

Generic pretty-printing combinators, partially inspired by Edward
Kmett's [parsers](https://github.com/ekmett/parsers) package. The
package is oriented towards printing source code. Suggestions on how
to adapt it for other purposes are welcome -- as long as they align
with the existing interface.

Motivation
----------

1. There's a lot of pretty-printing libraries on hackage with
   (slightly) different functionality and back-ends but similar
   interfaces:
   * pretty
   * wl-pprint
   * ansi-wl-pprint
   * mainland-pretty
   * marked-pretty
   * mpppc
   * wl-pprint-text

  We would like to exploit the latter characteristic and allow the
  users to use a single interface that is (hopefully) portable between
  libraries, similar to what the 'parsers' package does.
2. None of the existing libraries satisfy all the common requirements
   of software that generates source code:
   * generating "pretty" (human-readable) code with white spaces and
     indentation. This was the original purpose of pretty-printing
     libraries, so, of course, all of the existing libraries fulfill
     it.
   * generating minified source code, that omits unnecessary white
     space. The key aspect here is to allow specifying both the
     "pretty" and minified printers once and then generate different
     versions depending on a parameter. Right now if one wanted to
     write a minified version of a "pretty" printer he would have to
     rewrite it from scratch.
   * optionally printing AST annotations as comments. This is useful
     for debugging of the source-generating application as well as for
     feeding the output to various tools: documentation (JavaDoc,
     JSDoc, Haddock) or checking (Strobe, JML).
   * support for generation of source maps. Useful for writing
     compilers.

Approach
--------

1. The requirements for minified and annotated printing could be
   satisfied by introducing a simple concept of _optional_ elements in
   a document. The key requirement for optional elements is that their
   addition to (or, alternatively, removal from) the document does not
   change it's semantic. Document semantic can, for example, be
   defined by a parser or a grammar. So, if 'd' is a document and 'do'
   is 'd' with optional elements then 'parse d' should be equal to
   'parse do', for some definition of 'parse' and equality.

   Observe, that a pretty source representation is a minified
   representation with *optional* white space and newline characters
   added. As expected, the additional white-spaces should not change
   the semantics of the document and could be omitted. Similarly, an
   annotated source representation is a minified representation with
   *optional* comments added. Additionally, one might like to generate
   representations that are *both* pretty and annotated. One way to
   support this, which is currently adopted by the library, is to
   allow specifying a parameter to the 'optional' combinator that
   represents the circumstances under which the second argument should
   be output, such that:
         print [Opt1] $ optional Opt1 "x" = "x"
		 print [] $ optional Opt1 "x" = ""
		 print [Opt1, Opt2] $ optional Opt1 $ optional Opt2 "x" = "x"
		 print [Opt1] $ optional Opt1 $ optional Opt2 "x" = ""
		 print [Opt2] $ optional Opt1 $ optional Opt2 "x" = ""

   Additionally, this mechanism should allow specifying printers that
   can, for example, generate both a machine-readable and a
   human-friendly color- or font-highlighted HTML, LaTeX or ANSI
   terminal output (supported by ansi-wl-pprint, mpppc and
   marked-pretty). While one could argue that that would break the
   requirement of optional elements not altering the semantics, one
   could also devise a parser that first strips HTML tags, terminal
   color markers or LaTeX commands and then parses the text; for that
   parser, the additional markup would truly be optional.

2. Source map generation does not fit into the concept of optional
   document elements because in this case *two* documents need to be
   generated. One approach would be to 

