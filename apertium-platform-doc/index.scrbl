#lang scribble/manual

@(require racket/date)

@margin-note{This is an early draft. Contribute to this documentation on
@hyperlink["https://github.com/taruen/organisation/tree/master/apertium-platform-doc"]{
Github}.}

@title[#:version "3.5.2"]{Documentation of the Open-Source Shallow-Transfer
 Machine-Translation Platform @emph{Apertium}}

@centered{AUTHORS}

Of version 2.0 of the documentation:

@centered{Mikel L. Forcada @linebreak[]
          Boyan Ivanov Bonev @linebreak[]
          Sergio Ortiz Rojas @linebreak[]
          Juan Antonio Pérez Ortiz @linebreak[]
          Gema Ramírez Sánchez @linebreak[]
	  Felipe Sánchez Martínez @linebreak[]
          Carme Armentano-Oller @linebreak[]
	  Marco A. Montava @linebreak[]
	  Francis M. Tyers @linebreak[]}

@centered{EDITOR}

@centered{Mireia Ginestí Rosell}

@centered{Departament de Llenguatges i Sistemes Informàtics @linebreak[]
Universitat d'Alacant}

Of this document:

@centered{Ilnar Salimzianov}

@smaller{Copyright © 2007 Grup Transducens, Universitat d'Alacant. Permission
 is granted to copy, distribute and/or modify this document under the terms of
 the GNU Free Documentation License, Version 1.2 or any later version published
 by the Free Software Foundation; with no Invariant Sections, no Front-Cover
 Texts, and no Back-Cover Texts. A copy of the license can be found in @url{
 http://www.gnu.org/copyleft/fdl.html}.}

Version 2.0 of the official Apertium documentation can be found
@hyperlink["http://xixona.dlsi.ua.es/~fran/apertium2-documentation.pdf"]{
here}. The LaTeX source file is archived on
@hyperlink["https://sourceforge.net/p/apertium/svn/HEAD/tree/trunk/apertium-documentation/apertium-2.0/"]{
Sourceforge}.

In addition, there is a lot of information on the
@hyperlink["http://wiki.apertium.org"]{wiki} of the project.

The goal of this document is two-fold:

@itemlist[

 @item{describe what has changed in Apertium since the above mentioned
  documentation has been published (especially as a result of contributions
  made by the Google Summer of Code students), and}

 @item{consolidate the most important information spread across many different
  wiki pages into a single document (with pointers to more information on the
  wiki and elsewhere).}

 ]

@local-table-of-contents[]

@include-section["introduction.scrbl"]

@include-section["stream-format-spec.scrbl"]

@include-section["../../apertium-lex-tools/docs/index.scrbl"]

@include-section["../../apertium-separable/docs/index.scrbl"]
