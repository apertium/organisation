#lang scribble/manual

@(require scriblib/figure "references.rkt")

@title[#:tag "engine" #:version "3.5.2"]{The shallow-transfer machine
translation engine}

This chapter describes briefly the structure of the shallow-transfer machine
translation engine, which is largely based on that of the existing systems for
Spanish--Catalan @tt{interNOSTRUM}@~cite[canals01b]
@~cite[garridoalenda01p] @~cite[garrido99j] and for Spanish--Portuguese
@tt{Traductor Universia} @~cite[garrido03p] @~cite[gilabert03j], both developed
by the Transducens group of the Universitat d'Alacant.  It is a classical
indirect translation system that uses a partial syntactic transfer strategy
similar to the one used by some commercial MT systems for personal computers.

The design of the system makes it possible to produce MT systems that are
@emph{fast} (translating tens of thousands of words per second on ordinary
desktop computers) and that achieve results that are, in spite of the errors,
reasonably intelligible and easily correctable. In the case of related
languages such as the ones involved in the project (Spanish, Galician,
Catalan), a mechanical word-for-word translation (with a fixed equivalent)
would produce errors that, in most cases, can be solved with a quite
rudimentary analysis (a morphological analysis followed by a superficial, local
and partial syntactic analysis) and with an appropriate treatment of lexical
ambiguities (mainly due to homography). The design of our system follows this
approach with very interesting results. The Apertium architecture uses
finite-state transducers for lexical processing, hidden Markov models for
part-of-speech tagging and finite-state-based chunking for structural transfer.

The translation engine consists of an 8-module @emph{assembly line}, which is
represented in Figure \ref{fg:modules}.  To ease diagnosis and independent
testing, modules communicate between them using text streams.  This way, the
input and output of the modules can be checked at any moment and, when an error
in the translation process is detected, it is easy to test the output of each
module separately to track down the origin of the error. At the same time,
communication via text allows for some of the modules to be used in isolation,
independently from the rest of the MT system, for other natural-language
processing tasks, and enables the construction of prototypes with modified or
additional modules.

We decided to encode linguistic data files in
XML\footnote{\url{http://www.w3.org/XML/}}-based formats due to its
interoperability, its independence of the character set and the availability of
many tools and libraries that make easy the analysis of data in this format. As
stated in \cite{ide00}, XML is the emerging standard for data representation
and exchange in Internet. Technologies around XML include very powerful
mechanisms for accessing and editing XML documents, which will probably have a
significant impact on the development of tools for natural language processing
and annotated corpora.

@figure["fig:modules" "The eight modules that build the assembly line
        of the shallow-transfer machine translation system."
        @image["Apertium_system_architecture.png"] #:style
        center-figure-style ]
