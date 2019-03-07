#lang scribble/manual

@(require "references.rkt")

@title[#:tag "s:architecture" #:version "3.5.2"]{The shallow-transfer machine
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