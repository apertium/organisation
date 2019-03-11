#lang scribble/manual

@(require "references.rkt")

@title[#:tag "engine" #:version "3.5.2"]{The shallow-transfer machine
translation engine}

This chapter describes briefly the structure of the shallow-transfer machine
translation engine, which is largely based on that of the existing systems for
Spanish--Catalan @tt{interNOSTRUM}@~cite[garrido03p]@~cite[canals01b]
@~cite[garridoalenda01p]@~cite[garrido99j] and for Spanish--Portuguese
@tt{Traductor Universia} @~cite[garrido03p] @~cite[gilabert03j], both
developed by the Transducens group of the Universitat d'Alacant.  It is a
classical indirect translation system that uses a partial syntactic transfer
strategy similar to the one used by some commercial MT systems for personal
computers.

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
