#lang scribble/manual

@(require scriblib/figure)

@title[#:tag "modules-spec" #:version "3.5.2"]{Modules specification}

\section{Lexical processing modules}
\label{ss:modproclex}

\subsection{Module description }
\label{ss:funcproclex}

One of the most efficient approaches to lexical processing is based on
the use of finite-state transducers (FST)
\cite{mohri97a,roche97b}. FST are a type of finite-state automata,
which may be used as one-pass morphological analysers and generators
and may be very efficiently implemented. In this project, we have used
a class of FST called letter-transducers
\cite{roche97b,garrido02a,garrido99j}; in fact, any finite-state
transducer may always be turned into a letter-transducer. Garrido and
collaborators \cite{garrido99j,garrido02a} give a formal definition of
the letter transducers used in this project; describing them
informally, a letter-transducer is an idealised machine consisting of:
\begin{enumerate}

\item A (finite) set of states, that is, of situations in which the
transducer can be while it is reading, from left to right, the input
letters or symbols. Among the states of the set, we can distinguish:

\begin{enumerate}
\item A single initial state: this is the state in which the
transducer is before processing the first letter or the first symbol
of the input.
\item One or more acceptance states, which are only reached after
having completely read a valid entry and, therefore, are used to
detect valid words.
\end{enumerate}
\item A set (also finite) of state transitions consisting of:
\begin{enumerate}
\item the origin state
\item the destination state
\item the input letter or symbol
\item the output letter or symbol
\end{enumerate} To make possible that input and output have different
lengths at any time, it is allowed that there is no input symbol, that
there is no output symbol or that there is neither input nor output
symbol. This case is generally represented using a special symbol (the
empty symbol).
\end{enumerate}

Every time the transducer reads an entry symbol, it creates a list of
\emph{live} or \emph{active} states, each one of which has an
associated output (a sequence of symbols). The way the letter
transducer works is different for each type of lexical processing
operation. For example, in the morphological analysis, the transducer
tries to read the longest entry recognised by the dictionary
(``left-to-right, longest-match'' mode).
\begin{enumerate}
\item Beginning: the set of live states is given a single live state:
the initial state, with the empty word ("") as output associated to
the state.
\item When from one of the states in the current set of live states it
is possible to reach other states through transitions that do not have
input symbol, these states are added to the set of live states, and
are associated to the output obtained when extending the associated
outputs with the output symbol found in the corresponding
transitions. This expansion operation of the set of live states
continues until it is not possible to add more states.
\item A symbol from the input word is read.
\item A new set of live states is created, made with the states
reached through transitions that have that symbol as input, and this
states are associated to the outputs extended by adding the
corresponding output symbols found in the transitions.
\item If the current set has any live state, the process continues on
step 2.
\item The sets of live states are read backwards until a set is found
which contains acceptance states. The morphological analyses will be
the outputs associated to these states, and the reading position is
set to the position immediately after this set (so that it can be
processed again by the transducer in the next pass).
\end{enumerate} Not all acceptance states have the same
characteristics, and this fact adds more conditions to the acceptance
process, in order to be able to deal with unknown words or with words
that are joined to other words, as will be explained later.

The transducer reads the input word only once on average, from right
to left and symbol by symbol, and keeps a tentative list of possible
partial outputs that is updated and pruned as the input is being
read. When letter transducers are used as morphological analysers or
as lemmatizers, they read a surface form and write the resulting
lexical form(s). In this case, input symbols are the letters of the
surface form, and output symbols are the letters needed to write the
lemmas, as well as the letters and special symbols needed to represent
the morphological analysis, such as in \texttt{<n>}, \texttt{<f>},
\texttt{<p2>}, etc.

The transducers work in a similar way for other lexical processing
tasks.

\nota{La noció de LRLM (left-to-right, longest-match) (o ODSCML,
"izquierda a derecha, recortando el segmento concordante más largo")
ha de quedar clara en el funcionamient del morfològic i del trànsfer
estructural. Afegir coses de l'article de EAMT 2005.}

\subsubsection{Letter case handling in dictionaries}
\label{mayusc}

The same input word in a lexical processing module can be written
differently regarding letter case.  The most frequent cases are:

\begin{itemize}
\item The whole word is in lower case.
\item The whole word is in upper case.
\item The first letter is capitalised and the rest is in lower case
(typical case for proper nouns).
\end{itemize}

The transductions in the dictionary can also be found in these three
states.  The way in which one word is written in the dictionary is
used to discard possible analysis of the word, according to the
following rules:

\begin{itemize}
\item If the input letter is upper case and in the current analysis
state there are concordant transitions in lower case, these
transductions are made.
\item If the input letter is lower case and in the current state there
are not concordant transitions in lower case, the transductions are
not made.
\end{itemize}

Thanks to this policy, a surface form that is not capitalised can not
be analysed as a proper noun.

The case of an input word will be maintained in the output of the
translator unless it is decided not to do so. The case can be changed
in the structural transfer module; this option is useful, for example,
when there is a reordering of words or when a word is added before a
capitalised word at the beginning of a sentence, such as in the
translation of the Catalan phrase \emph{Vindran} into
English: \emph{They will come}.


\subsection{Data format: the dictionaries}
\label{ss:diccionarios}
\subsubsection{General criteria for dictionary design}

The experience of the Transducens group at the Universitat d'Alacant
in the creation of machine translation systems between Romance
languages (\texttt{es}, \texttt{ca} and \texttt{pt}) already operative
and publicly accessible has inspired the main characteristics of the
whole shallow-transfer machine translation system described in this
document, as well as its application to the Romance languages of Spain
(\texttt{es}, \texttt{ca} and \texttt{gl}). In some sense, it could be
stated that in the present project the only work was to adapt (rewrite
in a standardised and interoperable format) the specifications and
programs used in already operative projects.

In particular, the design of the dictionaries has been based in an
architecture that pretends to separate, as far as possible, the source
language from the target language, even knowing that these
dictionaries are translation-oriented and, therefore, that it is not
advisable to elaborate them completely separately.  The chosen format
is used for the specification of both morphological dictionaries
(monolingual) and bilingual dictionaries.

The format for dictionaries, as well as for the rest of linguistic
data (definition file for part-of-speech tagger and structural
transfer rules) is XML\footnote{\url{http://www.w3.org/XML/}}, an
international standard used in numerous natural language processing
projects which, thanks to the availability of many utilities and
libraries, it is becoming a very powerful tool for linguistic data
representation and exchange (see article \cite{ide00}).



Dictionaries are designed so that they can be compiled into
\textit{letter transducers }, for efficiency reasons. For more
information on letter transducers as a particular case of finite-state
transducers, see Section \ref{ss:funcproclex} or the article
\cite{garrido02a}.

The letter transducers that are generated from the system dictionaries
(morphological, bilingual and post-generation dictionaries) process
input character strings to produce output strings. According to this,
dictionaries are made of entries consisting of string pairs that
correspond to the inputs and outputs of the transducer.


The most powerful tool in these dictionaries is the definition and use
of \emph{paradigms}. Since in Romance languages a lot of lemmas share
the same inflection pattern (there are regularities in their
inflection), it is useful and straightforward to group these
regularities in inflection paradigms to avoid having to write all the
forms of every word. Paradigms allow the representation of dictionary
entries compactly and help optimise the speed for building a
dictionary. Once the most frequent paradigms in a dictionary are
defined, the linguist does not need to bother, in most cases,
with the whole inflection of a new term, since entering an inflective
word is generally limited to writing the lemma and choosing one
inflection pattern among the previously defined paradigms.
Furthermore, the use of paradigms reduces the memory requisites,
facilitates the construction of efficient letter transducers and
speeds up the compilation process \cite{ortiz05j}. We did not use
paradigms in bilingual dictionaries (although it is possible to)
because most of the inflection information is processed implicitly in
these dictionaries, as explained in page~\pageref{ss:bil}.



\subsubsection{Dictionary types}
 
In our system there are three types of dictionaries: morphological
(monolingual) dictionaries for each of the languages involved
(Spanish, Catalan and Galician); bilingual dictionaries for the
different translation pairs (Spanish--Catalan and Spanish--Galician),
and post-generation dictionaries for each of the languages (a
post-generation dictionary is not a typical dictionary, with lemmas
and morphological information, but is like a little dictionary of the
orthographic transformations that words may undergo when they come
together).  The structure of the three dictionary types is specified
by the same DTD (\emph{Document Type Definition}), which can be found
in Appendix \ref{ss:dtd_dics}.


\textbf{Morphological dictionaries} are used both for building
morphological analysers ---the translation system module used to
obtain all the possible lexical forms for a certain surface form in
the source language --- and morphological generators
---the module that generates the surface form in the target language
from the lexical form of each word---.  These two modules are obtained
from a single morphological dictionary, depending on the direction in
which it is read by the system: read from left to right, we obtain the
analyser, and read from right to left, the generator.

The block structure typical for these dictionaries is the following:

\begin{itemize}
\item \textit{An alphabet definition}.  This definition is used
exclusively for building the morphological analyser; specifically, it
enables the morphological analyser to appropriately tokenize unknown
words and the ones in the conditional sections (see the description of
the element \texttt{<section>} in page \pageref{ss:section}); the
morphological generator does not need this definition.

\item \textit{A definition of symbols}.  It consists of a declaration
of the grammatical symbols that will be used in dictionary entries
(you can find in Appendix \ref{se:simbolosmorf} a list with the
grammatical symbols used in this project).
\item \textit{A definition of paradigms}.  Paradigms need to be
defined here in order to be used in the dictionary sections or in other
paradigms.
\item \textit{One or more dictionary sections with conditional
  tokenization}, type \texttt{standard}. To include most of the words
  of the dictionary.
\item \textit{One or more dictionary sections with unconditional
  tokenization}.  To include certain words that follow a regular
  pattern or that are tokenized regardless the text directly after
  them (see description of the element \texttt{<section>} in page
  \pageref{ss:section}). In the Catalan morphological dictionaries,
  words requiring an unconditional tokenization are distributed in two
  sections: one for the forms that require the introduction of a blank
  immediately after (due to processing requirements of the lexical
  forms), like the apostrophized forms \emph{l'} or \emph{d'}, and
  another one for punctuation marks, numbers and other signs.

\end{itemize}

\textbf{Bilingual dictionaries} represent in the system the lexical
transfer process, that is, the assignment of the TL lexical form that
corresponds to each SL lexical form. Two \emph{products} are obtained
from each bilingual dictionary, depending on the direction in which it
is read by the system: when the dictionary is read from left to right,
we obtain the lexical transfer module in one translation direction,
and when it is read from right to left, in the other direction. For
the bilingual dictionaries of our project, it has been established
that Spanish will be put always on the left side of the entries, and
the rest of the languages (Catalan and Galician), on the right
side. Thus, for example, the bilingual Spanish--Galician dictionary
will be read from left to right for the translation
\texttt{es}--\texttt{gl} and from right to left for the translation
\texttt{gl}--\texttt{es}.  In applications like the ones in this
project, these dictionaries do not have paradigms: they are build with
generic entries which almost always have no more information than
lemma and part of speech, and there is no inflection information.

The block structure used in the bilingual dictionaries of this project
is the following:

\begin{itemize}
\item \textit{A definition of symbols}.  It consists of a declaration
of the grammatical symbols that will be used in dictionary entries.
\item \textit{A single dictionary section}.  Where bilingual
correspondences are specified.
\end{itemize}

Since 2007, bilingual dictionaries allow the specification of more
than one TL translation, so that a lexical selection module (see
Section \ref{se:seleccio_lex}) can choose the most suitable equivalent
according to the context. To that end, an attribute has been added to
bilingual dictionaries. You can find its description in section
\ref{dic_lextor}.


\textbf{Post-generation dictionaries} are used to perform some
transformations (orthographic changes, contractions, apostrophation,
etc.) required after surface forms in the target language have been
generated and come into contact with each other.  Since this kind of
operation can be expressed as a translation of character strings, it
has been decided to use the same type of dictionaries. It is
implicitly assumed that the parts of the text whose processing has not
been specified are copied just as they arrive. In these dictionaries,
the definition of paradigms is useful to express systematic changes in
the word contact phenomena. Unlike the other dictionary types, these
do not include grammatical symbols, since they process surface forms.

The block structure of post-generation dictionaries is the following:
\begin{itemize}

\item \textit{A definition of paradigms}. To use in entries.
\item \textit{A dictionary section}.  Where the patterns for
post-generation operations are specified.
\end{itemize}


The following table contains an overview of the possible reading
directions of dictionaries and their application to the Romance
languages in this project:

\begin{center}
 \begin{tabular}{|l|l|l|} 
\hline 
Dictionary & Reading direction & Function \\ 
\hline 
Morphological & left--right & analysis for \texttt{es}, \texttt{ca} and \texttt{gl}\\ 
              & right--left & generation for \texttt{es}, \texttt{ca} and \texttt{gl}\\\hline 
Bilingual     & left--right & translation for \texttt{es-ca} and \texttt{es-gl}\\ 
              & right--left & translation for \texttt{ca-es} and \texttt{gl-es}\\\hline 
Post-generation & left--right & post-generation for \texttt{ca}, \texttt{es} and \texttt{gl}\\\hline

\end{tabular}
\end{center}



\subsubsection{Description of the dictionary format}
\label{formatodics} This section presents the main elements of the
format in which dictionaries are built. The formal definition (a DTD)
can be found in Appendix ~\ref{ss:dtd_dics}.  Section \ref{dic_lextor}
describes the characteristics of a bilingual dictionary that works in
an Apertium system with lexical selection module.  Finally, from pages
\pageref{ss:morfgen} to %\pageref{ss:bil} y 
\pageref{ss:postgen} there
is a description of the different particularities of entries for the
three dictionary types (morphological, bilingual and post-generation).



\paragraph{Element for dictionary \texttt{<dictionary>}}
 
This is the root element and includes the whole dictionary.  It
contains an alphabetic character definition, a definition of symbols
(which are the morphological tags for the words), a definition of
inflection paradigms and one or more dictionary sections, which
contain the entries for the lexical forms (consisting of pairs made of
surface form--lexical form). Figure \ref{fig:dictionary} shows the
basic block structure of a generic dictionary.

\begin{figure}
\begin{small}
\begin{alltt}
<?\textbf{xml} \textsl{version}="1.0" \textsl{encoding}="utf-8"?>
<\textbf{dictionary}>
  <\textbf{alphabet}>abcdefghijk ... ABCDEFGH ... çñáéíóú</\textbf{alphabet}>
  <\textbf{sdefs}>
    <!-- ... -->
  </\textbf{sdefs}>
  <\textbf{pardefs}>
    <!-- ... -->
  </\textbf{pardefs}>
  <\textbf{section} ...>
    <!-- ... -->
  </\textbf{section}>
  <!-- ... -->
</\textbf{dictionary}>
\end{alltt}
\end{small}
\caption{Use of the elements \texttt{<\textbf{dictionary}>} and
\texttt{<\textbf{alphabet}>}}
\label{fig:dictionary}
\end{figure}


\paragraph{Element for alphabet \texttt{<alphabet>}}

It is used to specify a definition of alphabetic characters.  The
purpose of this specification is enabling the modules that process the
input by means of letter transducers to tokenize it in individual
words.\nota{Parlar dels mots desconeguts. Cita \ref{ss:section} -
Mikel?}

In the present design, the definition of an alphabet only has sense in
morphological dictionaries, since it is needed for the
analysis. Figure \ref{fig:dictionary} shows a use example for this
element.


\paragraph{Element for symbol definition section \texttt{<sdefs>}} It
groups all the symbol definitions in a dictionary
(\texttt{<\textbf{sdef}>}).  There is an example of its use in Figure
\ref{fig:sdefs}.

\paragraph{Element for symbol definition \texttt{<sdef>}}

It is an empty element (it does not delimit any content): it is used
to specify, through the values of the attribute \texttt{\textsl{n}},
the names of the grammatical symbols that are used in the dictionary
to morphologically label lexical forms. In Figure \ref{fig:sdefs} you
can find a use example for this element. Refer to Appendix
\ref{se:simbolosmorf} if you need a list with all the grammatical
symbols used in the dictionaries of this project.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{sdefs}>
  <\textbf{sdef} \textsl{n}="n"/>
  <\textbf{sdef} \textsl{n}="det"/>
  <\textbf{sdef} \textsl{n}="sg"/>
  <\textbf{sdef} \textsl{n}="pl"/>
  <!-- ... -->
</\textbf{sdefs}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{sdefs}>}}
\label{fig:sdefs}
\end{figure}

\paragraph{Element for dictionary section \texttt{<section>}}
\label{ss:section}

It contains the words that will be recognised by the dictionary.  The
reason to divide a dictionary in sections is that some forms ---for
example, the ones coming from the identification of certain regular
patterns, or some forms that pertain to a specific dialect--- may need
a different processing.

One of the problems that the definition of sections in a dictionary
helps to solve is the tokenization procedure during morphological
analysis.  Most of the forms are tokenized following a conditional
criterion: identifying if the character being processed is followed by
a non-alphabetic character ---that is, not defined in
\texttt{<\textbf{alphabet}>}---. However, there are other forms, like
the Catalan apostrophized words \emph{l'} or \emph{d'}, that need an
unconditional tokenization model: there is no need to analyse what
comes after them, since, if it is an alphabetic character, it will
belong to the \textit{next} word. The forms that require unconditional
tokenization are included in a specific section of the
dictionary. Other kinds of processing can also be solved through these
divisions.



The value of the attribute \texttt{\textsl{type}} is used to express
the kind of string tokenization applied in each dictionary section:
the possible values of this attribute are: \texttt{standard}, for
almost all the forms of the dictionary (conditional mode),
\texttt{preblank} and \texttt{postblank}, for the forms that require 
an unconditional tokenization and the placing of a blank (before and
after, respectively), and \texttt{inconditional}
for the rest of forms that require unconditional tokenization.

The attribute \texttt{\textsl{id}} is used to assign an identifier (a
name) to the dictionary sections.

\begin{figure}
\begin{small}
\begin{alltt} 
<\textbf{section} \textsl{id}="principal" \textsl{type}="standard">
<!-- ... -->
</\textbf{section}>
<\textbf{section} \textsl{id}="patterns" \textsl{type}="inconditional">
<!-- ... -->
</\textbf{section}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{section}>}}
\label{fig:section}
\end{figure}

\paragraph{Element for entries \texttt{<e>}}

An entry is the basic unit of a dictionary or of a paradigm
definition.  Entries consist of a concatenation in any order of string
pairs \texttt{<\textbf{p}>}, identity transductions
\texttt{<\textbf{i}>}, references to paradigm \texttt{<\textbf{par}>}
or regular expressions \texttt{<\textbf{re}>}.  The structure and
meaning of these elements is explained later in this section (in pages
~\pageref{ss:p}, \pageref{ss:i}, \pageref{ss:par} and \pageref{ss:re}
respectively).

\label{restric}Two optional attributes are used with this entry.  The
first one is \texttt{\textsl{r}} (for \textit{restriction}), which
specifies if the entry has to be considered only when reading the
dictionary from left to right (\texttt{LR}) or when reading it from
right to left (\texttt{RL}).  If nothing is specified, it is assumed
that the entry must be considered in both directions.

In morphological dictionaries, the restriction \texttt{LR} causes that
a LF is analysed but not generated (for example, when the LF belongs
to a dialectal variant that we wish to recognise but not to generate)
and the restriction \texttt{RL} causes that a word is generated but not
analysed (needed, for example, for forms with post-generator
activation mark, see page \pageref{ss:a} for more details).

In bilingual dictionaries, the restrictions \texttt{LR} and
\texttt{RL} cause that the translation is done only in one direction:
for example, in a bilingual \texttt{es}--\texttt{ca} dictionary,
\texttt{LR} indicates that the LF is only translated from Spanish to
Catalan, and \texttt{RL} only from Catalan to Spanish. Let's
illustrate it with an example: the Spanish adverbs \emph{aún} and
\emph{todavía} ("still") are translated into Catalan as the same word,
\emph{encara}. We can only translate the Catalan adverb \emph{encara}
as one of both words into Spanish (there is no difference in meaning);
we decide to translate it as \emph{todavía}. In this case, we have to
write two entries in the bilingual dictionary: the entry that matches
\emph{aún} with \emph{encara} needs to have the restriction
\texttt{LR} (translation only from \texttt{es} to \texttt{ca}) and the
one that matches \emph{todavía} with \emph{encara} does not need to
have any restriction (translation in both directions).

Direction restrictions are also necessary in bilingual dictionaries
when we have words with gender to be determined ("GD") or number to be
determined ("ND") (consult page ~\pageref{ss:bil} for more
information).

The other optional attribute in entries is the lemma name
\texttt{\textsl{lm}}. Due to the employment of paradigms to represent
the inflection regularities of lexical units, an entry in
morphological dictionaries contains the part of the lemma that is
common to all the inflected forms, that is, it contains the lemma cut
at the point in which the paradigm regularity begins (for example, the
Spanish adjectives \emph{distinto}, \emph{absoluto} and \emph{marino}
appear in entries as \emph{distint}, \emph{absolut} and \emph{marin},
since the rest of the inflected forms is common to all of them and
specified in a paradigm).  This fact can make the dictionary difficult
to understand.  Therefore entries have this attribute, which contains
the whole lemma of the lexical form, so that the dictionary becomes
more understandable and linguists can solve problems quickly.  In
bilingual dictionaries, which normally do not have references to
paradigms,\footnote{They could have references to paradigms, but we
did not judge it necessary for the languages involved \nota{atenció:
ex--, vice--?}.} this attribute is not used.


\paragraph{Element for string pair \texttt{<p>}}
\label{ss:p}

This basic element of dictionaries is used in any kind of entry to
indicate the correspondence between two strings; this
correspondence specifies a lexical transformation that will be carried
out by a state path in the resulting finite-state transducer
\cite{garrido99j}.

It is defined by a pair of internal elements: The left element
(\texttt{<\textbf{l}>}) and the right element (\texttt{<\textbf{r}>}).
Its structure is shown in Figure \ref{fig:p}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{p}>
  <\textbf{l}><!-- ... --></\textbf{l}>
  <\textbf{r}><!-- ... --></\textbf{r}>
</\textbf{p}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{p}>}}
\label{fig:p}
\end{figure}

A pair \texttt{<\textbf{p}>} must include these two parts although one
can be empty, which means deleting (or inserting) a string. The
elements \texttt{<\textbf{l}>} and \texttt{<\textbf{r}>} have the same
internal structure and the same requisites.  They can contain text and
references to grammatical symbols (which, for the languages of the
present project, inflected by suffixation, are usually placed at the
end in any amount).  Outside the tags \texttt{<\textbf{l}>} and
\texttt{<\textbf{r}>} of a string pair there is nothing.


\paragraph{Element for reference to symbol \texttt{<s>}}

References to symbols (or tags) are used to specify the morphological
information of a LF and are used in any place inside a string pair,
that is, inside the elements \texttt{<\textbf{l}>} and
\texttt{<\textbf{r}>}, as if they were individual characters; for the
languages of our project, however, they are put at the end of the
pairs and always in the same order for the same word type.  This order
is decided by the linguist according to how he/she wishes to
characterise morphologically the LF in the dictionaries, and must be
the same in all the dictionaries of a system if we want that the
lexical and structural transfer operations work correctly. So, for
example, in the Romance language dictionaries of this project, a noun
has in the first place the symbol for part of speech (\textit{n},
noun), then for gender (\textit{m}, masculine, \textit{f}, feminine,
\textit{mf}, masculine--feminine), and finally for number
(\textit{sg}, singular, \textit{pl}, plural, \textit{sp},
singular--plural).  The list in Appendix \ref{se:simbolosmorf}
contains all the grammatical symbols used in the dictionaries of this
project and shows the order which has been established for each type
of word.

In morphological dictionaries, references to symbols are used in
paradigms as well as in entries which do not include any reference to
a paradigm. In bilingual dictionaries, usually only the first symbol
of each LF is specified, since the rest is automatically copied from
the source language LF to the target language LF (in the case they are
identical in both languages).

To specify which symbol we are referring to, we use the (mandatory)
attribute \texttt{\textsl{n}}.  The symbol must be defined in the
symbol definition section (\texttt{<\textbf{sdefs}>}).




\paragraph{Element for identity transduction \texttt{<i>}}
\label{ss:i}

It is a way to write a string pair in which left side and right side
are identical.  For example, the two entries shown in Figure
\ref{fig:i} are completely equivalent. The advantage of writing
entries with this element is that the result is more compact and more
readable.

\begin{figure}
\begin{small}
\begin{alltt}
[1]

<\textbf{e} \textsl{lm}="perro">
  <\textbf{p}>
    <\textbf{l}>perr</\textbf{l}><\textbf{r}>perr</\textbf{r}>
  </\textbf{p}>
  <\textbf{par} \textsl{n}="abuel/o__n"/>
</\textbf{e}>

[2]

<\textbf{e} \textsl{lm}="perro">
  <\textbf{i}>perr</\textbf{i}>
  <\textbf{par} \textsl{n}="abuel/o__n"/>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{i}>} entries [1] and [2]
are equivalent}
\label{fig:i}
\end{figure}



\paragraph{Element for paradigm definition section \texttt{<pardefs>}}

This element includes all the paradigm definitions of a dictionary,
each definition in an element \texttt{<\textbf{pardef}>}, as shown in
Figure \ref{fig:pardefs}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{pardefs}>
  <\textbf{pardef} \textsl{n}="abuel/o__n"> 
    <!-- ... -->
  </\textbf{pardef}> 
  <!-- ... -->
</\textbf{pardefs}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{pardefs}>}}
\label{fig:pardefs}
\end{figure}



\paragraph{Element for paradigm definition \texttt{<pardef>}}


It defines an inflection paradigm in the dictionary.  A paradigm can
be understood as a small dictionary of alternative transformations
that can be concatenated to parts of words (or to entries of another
paradigm) to specify regularities in the lexical processing of the
dictionary entries, such as inflection regularities. To specify these
regularities, each paradigm is a list of entries \texttt{<\textbf{e}>}
like the ones in the dictionary, that is, it has the same structure as
a dictionary section \texttt{<\textbf{section}>}; therefore, paradigm
entries consist of a pair (\texttt{<\textbf{p}>}) with left side
(\texttt{<\textbf{l}>}) and right side (\texttt{<\textbf{r}>}). These
elements can contain text or grammatical symbols
\texttt{<\textbf{s}>}.


As in symbol definitions, paradigm definitions have an attribute
\texttt{\textsl{n}} which specifies the paradigm name, so that it can
be referred to inside dictionary entries. In a dictionary entry,
therefore, one only needs to indicate the corresponding paradigm name
in order that all its possible forms get specified.

The example of paradigm definition pointed out in Figure
\ref{fig:pardefs} appears developed in Figure \ref{fig:pardef}.  The
following table shows the information expressed by the paradigm:

\begin{center}
 \begin{tabular}{|l|c|l|} 
\hline 
Root (SF and LF) & Ending (SF) & Analysis (LF) \\ 
\hline 
\texttt{abuel} & \texttt{o} &\texttt{o<n><m><sg>}\\ 
\texttt{abuel} & \texttt{a} &\texttt{o<n><f><sg>}\\ 
\texttt{abuel} & \texttt{os} &\texttt{o<n><m><pl>}\\ 
\texttt{abuel} & \texttt{as} &\texttt{o<n><f><pl>}\\ 
\hline
\end{tabular}
\end{center}


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{pardef} \textsl{n}="abuel/o__n">
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>o</\textbf{l}>
      <\textbf{r}>o<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
    </\textbf{p}>
  </\textbf{e}>
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>a</\textbf{l}>
      <\textbf{r}>o<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
    </\textbf{p}>
  </\textbf{e}>
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>os</\textbf{l}>
      <\textbf{r}>o<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
    </\textbf{p}>
  </\textbf{e}>
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>as</\textbf{l}>            
      <\textbf{r}>o<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
    </\textbf{p}>
  </\textbf{e}>      
</\textbf{pardef}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{pardef}>} to define the
  inflective morphology of Spanish nouns with four endings, such as
  \emph{abuelo, -a, -os, -as} ("grandfather, grandmother") }
\label{fig:pardef}
\end{figure}

This paradigm is assigned to all Spanish nouns (\texttt{n}) that
inflect like \emph{abuelo}, such as \emph{alumno}, \emph{amigo} or
\emph{gato}, and is designed to be used as a \textit{suffix} in
dictionary entries.  In general, paradigms can be applied to any
position of a dictionary entry (if it makes sense, of course).  We can
think of paradigms as transducers that are inserted at the point where
they are specified.  Figure \ref{fig:pardef2} shows an example of paradigm
defined to be used as a prefix. It is the paradigm used to analyse and
generate Spanish words beginning with \emph{ex}, \emph{ex-}, etc.,
like \emph{ex-presidente}, \emph{exministro}, \emph{ex director},
etc., with all the orthographic variations (\emph{ex} with hyphen,
without hyphen and joined, without hyphen and with a blank
\texttt{<\textbf{b}/>}, see page~\ref{s3:b}); the output lemma simply
adds \emph{ex} without hyphen nor blank to the accompanying lemma. The
direction restrictions (\texttt{"LR"}) that appear in the example are
used to determine which form will the translator generate. The empty
identity transduction (\texttt{<\textbf{i}/>}) is necessary in this
case to analyse and generate the word without the prefix \emph{ex}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{pardef} \textsl{n}="ex">
  <\textbf{e} \textsl{r}="LR"><\textbf{p}><\textbf{l}>ex<\textbf{b}/></\textbf{l}><\textbf{r}>ex</\textbf{r}></\textbf{p}></\textbf{e}>
  <\textbf{e}><\textbf{i}>ex</\textbf{i}></\textbf{e}>
  <\textbf{e} \textsl{r}="LR"><\textbf{p}><\textbf{l}>ex-</\textbf{l}><\textbf{r}>ex</\textbf{r}></\textbf{p}></\textbf{e}>
  <\textbf{e}><\textbf{i}/></\textbf{e}>
</\textbf{pardef}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{pardef}>} in the paradigm
  for the prefix \emph{ex}.}
\label{fig:pardef2}
\end{figure}


Entries in a paradigm can contain references to other paradigms
provided that these have been defined upper in the file.  On the other
hand, for the moment a paradigm definition can not include itself
neither directly nor indirectly.

Paradigms are used in morphological dictionaries for the analysis and
generation of lexical forms. For the language pairs of this project,
there is no need to define paradigms in bilingual dictionaries (see
page~\pageref{ss:bil}).

From Apertium 2 on, there is a new type of paradigm, called
metaparadigm, that allows the definition of paradigms with variations
according to the value of an attribute specified in each entry that
refers to that paradigm. Section \ref{ss:metaparadigmas} describes the
characteristics and use of metaparadigms.



\paragraph{Element for reference to a paradigm \texttt{<par>}}
\label{ss:par}

It is used inside an entry to indicate which inflection paradigm,
among the ones defined in \texttt{<\textbf{pardefs}>}, follows the
entry. Thanks to the references to paradigms there is no need to write
all the inflected forms of a lemma in a morphological dictionary
entry.  The attribute \texttt{\textsl{n}} is used to specify the name
of the paradigm we want to refer to.

The result of inserting a reference to a paradigm in an entry is the
creation of so many string pairs as cases specified in the
paradigm. For example, the entry in Figure \ref{fig:par}, with a
reference to the paradigm "\texttt{abuel/o\_\_n}" (defined in Figure
\ref{fig:pardef}), is equivalent to an entry where each string pair of
the paradigm is concatenated to the lemma (that is, an entry with
every inflected form of the lemma), as shown in Figure
\ref{fig:lema_par}. In this figure, you can see that the paradigm
delivers always in the right string (\texttt{<\textbf{r}>}) the lemma
(\emph{perro}) with the grammatical symbols that apply to the surface
form, since it is from the lemma that transfer operations are carried
out.


The appropriate use of paradigms, besides enabling the creation of
compact dictionaries, improves compilation speed and reduces memory
requirements during this process, since in compilation it is possible
to create a single data structure for each one of most paradigms
\cite{ortiz05j}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="perro">
  <\textbf{i}>perr</\textbf{i}>
  <\textbf{par} \textsl{n}="abuel/o__n"/>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{par}>}}
\label{fig:par}
\end{figure}

\begin{figure}
\begin{small}
\begin{alltt}
 <\textbf{e}>
   <\textbf{p}>
     <\textbf{l}>perro</\textbf{l}>
     <\textbf{r}>perro<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
   </\textbf{p}>
 </\textbf{e}>
 <\textbf{e}>
   <\textbf{p}>
     <\textbf{l}>perra</\textbf{l}>
     <\textbf{r}>perro<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
   </\textbf{p}>
 </\textbf{e}>
 <\textbf{e}>
   <\textbf{p}>
     <\textbf{l}>perros</\textbf{l}>
     <\textbf{r}>perro<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
   </\textbf{p}>
 </\textbf{e}>
 <\textbf{e}>
   <\textbf{p}>
     <\textbf{l}>perras</\textbf{l}>            
     <\textbf{r}>perro<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
   </\textbf{p}>
 </\textbf{e}>      
\end{alltt}
\end{small}
\caption{Entry equivalent to the one in Figure \ref{fig:par}, that
  shows the result of inserting the reference to paradigm
  \texttt{<\textbf{par}>} with the paradigm defined in Figure
  \ref{fig:pardef}.}
\label{fig:lema_par}
\end{figure}



\paragraph{Element for regular expression \texttt{<re>}}
\label{ss:re}

In natural languages too there are patterns that can be recognized as
regular expressions: for example, punctuation marks, numbers (Latin or
Roman), e-mail or web page addresses, or any kind of code identifiable
through these mechanisms.


For this cases we use the string contained in the tag
\texttt{<\textbf{re}>}.  The compiler reads the regular expression
definition and transforms it in a transducer that is inserted in the
rest of the dictionary and that translates all the strings that match
the expression into identical strings.

The syntax of the present implementation of these regular expressions
processes a subgroup of Unix regular expressions, which includes the
operators \texttt{*}, \texttt{?}, \texttt{|} and \texttt{+}, as well
as groupings through parentheses and optional character ranks, for
example \texttt{[a-zA-zñú]} or its negated versions, like
\verb![^a-z]!.

By analogy, they can be seen as \texttt{<\textbf{i}>} elements, with
the difference that they can identify strings which may be infinite
(like numbers).

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{re}>[0-9]+([.,][0-9]+)?(\%)?</\textbf{re}>
  <\textbf{p}><\textbf{l}/><\textbf{r}><\textbf{s} \textsl{n}="num"/></\textbf{r}></\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Us of the element \texttt{<\textbf{re}>} in an entry for the
detection of Arabic numbers.}
\label{fig:e}
\end{figure}

Figure \ref{fig:e} shows the way to tag quantities expressed as Arabic
numbers in the dictionary.


\paragraph{Element for blank block \texttt{<b>}}
\label{s3:b}

It is used to express the presence of blanks between the words of a
multiword (see page~\pageref{ss:multipalabras} for an explanation on
multiwords). It can be inserted in the \texttt{<\textbf{i}>},
\texttt{<\textbf{l}>} and \texttt{<\textbf{r}>} elements.  In Figure
\ref{fig:b} you can see the entry for the Spanish multiword expression
\emph{hoy en día} ("nowadays"): the blanks between words are expressed
as \texttt{<\textbf{b}/>} elements inside the left and right strings.
\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="hoy en día">
  <\textbf{p}>
    <\textbf{l}>hoy<\textbf{b}/>en<\textbf{b}/>día</\textbf{l}>
    <\textbf{r}>hoy<\textbf{b}/>en<\textbf{b}/>día<\textbf{s} \textsl{n}="adv"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{b}>}}
\label{fig:b}
\end{figure}

Blanks can consist of normal space characters or of document format
information blocks encapsulated by the de-formatter
(\textit{superblanks}, see Section \ref{ss:formato}).


\paragraph{Element for post-generator activation \texttt{<a>}}
\label{ss:a} The element \texttt{<\textbf{a}>} for the activation of
the post-generator is used to indicate that a word in target language
may undergo orthographic transformations due to the contact with other
words; for example, being apostrophized, contracted, written without
intermediate spaces, etc.  These transformations need be carried out
after the generation of the target language surface forms, as until
then words are isolated and it is not possible to know which words
will get in contact . Therefore, these operations must be carried out
by the module next to the generator, which is called
post-generator. In order to signal which words are to be processed by
the post-generator, this element is used in the surface form side of
these entries in the morphological dictionary.

The example in Figure \ref{fig:a} shows its use, in a Catalan
morphological dictionary, for the preposition \textit{de}, which, when
appearing before a singular or plural masculine definite article
(\textit{el, els}), forms a contraction (\textit{del, dels}).  The
presence of the tag \texttt{<\textbf{a}/>} causes the activation of
the post-generator, which checks whether the preposition is followed
by one of the words that cause it to contract and, if it is so, makes
the contraction (see page~\pageref{ss:postgen} for more details). The
restriction \texttt{RL} indicates that this is an only-generation
entry, since it does not make any sense for the analysis.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{r}="RL" \textsl{lm}="de">
   <\textbf{p}>
      <\textbf{l}><\textbf{a}/>de</\textbf{l}>
      <\textbf{r}>de<\textbf{s} \textsl{n}="pr"/></\textbf{r}>
   </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{a}>} in a morphological
dictionary}
\label{fig:a}
\end{figure}



\paragraph{Element for group marking \texttt{<g>}}

This element is used, inside the \texttt{<\textbf{l}>} and
\texttt{<\textbf{r}>} elements, to define groups that require a
special treatment beyond the normal word by word processing. It is
used in inflective multiwords to signal the beginning and the end of
the group of invariable lexical forms (one or more) that are adjacent to the
inflected word and that, together with it, build an inseparable
unit. In Section~\ref{ss:multipalabras} you will find a detailed
explanation of the different multiword types, and in Figure
\ref{fig:hacertilin} of that section you can see an example of its
use.



\paragraph{Element for joining of lexical forms \texttt{<j>}}
\label{ss:j}

This element is used only in the right side of an entry
(\texttt{<\textbf{r}>}) to indicate that the words that form a
multiword are treated as individual lexical forms and, therefore, have
a grammatical symbol each. This way, this multiword will be processed
as a unit by the analyser and by the tagger until it reaches the
auxiliary module \texttt{pretransfer} (see section
\ref{se:pretransfer}), which is responsible for separating the lexical
forms it is made of so that they reach the transfer module as
independent forms. If the linguist wants that these forms reach the
generator as joined forms, building again a multiword, it is necessary
to define a structural transfer rule that groups them in a multiword
(see Section \ref{formatotransfer}). If, on the contrary, these joined
forms must be only for the analysis, the entry must have the
restriction \texttt{LR}.

In Section~\ref{ss:multipalabras} you will find a more detailed
explanation of this element. An example of its use can be found in
Figure \ref{fig:cont} of the mentioned section.

\subsubsection{Modification of bilingual dictionaries for the new
lexical selection module}
\label{dic_lextor}

In 2007, a new module has been added to the Apertium system: the
lexical selection module, which is described in section
\ref{se:seleccio_lex}.

In order for them to work in a lexical selection system, bilingual
dictionaries must be slightly modified so that they allow the
specification of more than one translation in target language. The
only change is the addition of two new attributes to the element
\texttt{<e>}.  Although these new attributes can be used in all the
dictionaries of a system, they only make sense in a bilingual
dictionary entry.


In Appendix~\ref{dixdtd} there is the part of the DTD \texttt{dix.dtd}
\nota{MG: no caldria ajuntar les dues DTDs en una de sola?}  where the
element \texttt{e} used for dictionary entries is defined.  The new
attributes are:
\begin{description}
\item[slr (\emph{sense from left to right})] is used to specify the
\emph{translation mark} when there is more than one translation from
left to right for the lemma specified in the left side of an
entry. The attribute can receive any value; however, the recommended
action is to assign as value the lemma contained in the right part
\texttt{<r>} (the translation of the lemma).
\item[srl (\emph{sense from right to left})] is used to specify the
\emph{translation mark} when there is more than one translation from
right to left for the lemma specified in the right side of an entry.
As before, the attribute can receive any value, but the recommended
action is to assign as value the lemma contained in the left part
\texttt{<l>} (the translation of the lemma).
\end{description}

Furthermore, in both cases the value of the attribute can end in a
white space and the letter ``D'' to indicate that this is the default
translation, that is, the translation that will be chosen when there
is not enough information to make a decision. It is compulsory that,
for entries that have more than one equivalent in target language, one
of the equivalents, and only one, is marked with the letter ``D'' for
\emph{default}.

The following example shows how the new attributes are used.  We take
as example a bilingual English-Catalan dictionary, with the following
entries having more than one translation in the target language:
\begin{itemize}
\item \emph{look}: can be translated into Catalan as \emph{mirar}
(default) or as \emph{semblar} (according to the English senses
\emph{view/seem}),
\item \emph{floor}: can be translated into Catalan as \emph{pis}
(default) or as \emph{terra} (according to the English senses
\emph{level of building/ground}),
\item \emph{pis}: can be translated into English as \emph{flat}
(default) or as \emph{floor}.
\end{itemize}

This information is represented by means of the two attributes
described:\label{entrades_lextor}
\begin{alltt}
\begin{small}
<e srl="flat D">
   <p>
      <l>flat<s n="n"/></l>
      <r>pis<s n="n"/><s n="m"/></r>
    </p>
</e>

<e slr="pis D" srl="floor">
   <p>
      <l>floor<s n="n"/></l>
      <r>pis<s n="n"/><s n="m"/></r>
   </p>
</e>

<e slr="terra">
   <p>
      <l>floor<s n="n"/></l>
      <r>terra<s n="n"/><s n="m"/></r>
   </p>
</e>

<e slr="mirar D">
   <p>
      <l>look<s n="vblex"/></l>
      <r>mirar<s n="vblex"/></r>
   </p>
</e>

<e slr="semblar">
   <p>
      <l>look<s n="vblex"/></l>
      <r>semblar<s n="vblex"/></r>
   </p>
</e>
\end{small}
\end{alltt}


%\settocdepth{paragraph}

\subsubsection{Particularities of the different dictionary types}
\label{ss:morfgen}

Dictionary entries have different characteristics depending on the
dictionary type. Although some of these characteristics have been
presented in the previous sections, we are going to describe them here
more exhaustively.


\paragraph{Morphological dictionaries}

In these dictionaries, used to generate the system's morphological
analysers and generators, it is necessary to mark with
\texttt{<\textbf{a}/>} those surface forms which, once generated, may
need certain orthographic transformations due to the contact with
other words; these operations are carried out by the post-generator.
As these marks are only generated, the entries containing them must be
only for the generation, which means that need to have the restriction
\texttt{\textsl{r}=}\verb!"RL"! (from right to left).  Figure
\ref{fig:a} shows an entry containing this element.



\paragraph{Bilingual dictionaries}
\label{ss:bil}

As explained before, we have not used paradigms in the bilingual
dictionaries of our system; these dictionaries are built with generic
entries in which, almost always, only part of speech is specified, and
which do not have inflection information. For example, in the
\texttt{es-ca} dictionary, the entry for the Spanish words
\textit{pan}, \textit{panes} ("bread"), translated into Catalan as
\textit{pa}, \textit{pans}, would be as shown in Figure \ref{fg:pan}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>pan<\textbf{s} \textsl{n}="n"/></\textbf{l}>
    <\textbf{r}>pa<\textbf{s} \textsl{n}="n"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Bilingual dictionary entry for the translation \emph{pan}
(\texttt{es})--\emph{pa} (\texttt{ca})}
\label{fg:pan}
\end{figure}


As you can see in the figure, only the first grammatical symbol
\texttt{<\textbf{s} \textsl{n}="\ldots}\texttt{"}\texttt{/>} of each
word is specified, since the unspecified symbols that come after the
specified ones in the bilingual dictionary are copied from the source
lexical form to the target lexical form. This entry, therefore, works
both for \textit{pan} (singular) and for \textit{panes} (plural): the
morphological analyser delivers the lemma (\emph{pan}) followed by the
grammatical symbols that apply to the analysed surface form (\emph{n m
sg} or \emph{n m pl} as applicable), and the symbols that are not
specified in the bilingual entry (\emph{m sg} or \emph{m pl}) are
copied to the target language. This is valid for both translation
directions.  The idea is to specify the information indispensable to
differentiate the entries, and the rest is \textit{deduced}
(copied). It is important to bear this in mind, because, when there
are differences between the grammatical symbols of a lexical form from
SL to TL, these differences must be specified in the bilingual
dictionary.  For example, when between source word and translated word
there is a gender or number change, one has to specify the grammatical
symbols in order (the order in which these symbols appear in the
morphological dictionaries)\footnote{To know which grammatical symbols
have been used in the dictionaries and in which order, see Appendix
\ref{se:simbolosmorf}.} until the symbol that changes between SL and
TL is reached.

For example, to translate the Spanish word \textit{cama}, feminine
noun, into the Catalan word \textit{llit}, masculine noun, the entry
in the bilingual dictionary must be as shown in Figure
\ref{fg:cama}. The gender must be specified (\emph{f}, \emph{m})
because, if not, the symbols for gender and number would be copied
from the SL lexical form into de TL lexical form. Therefore, when
translating from \texttt{es} to \texttt{ca}, we would obtain the
lexical form \emph{llit} with the symbols \texttt{n f sg} or \texttt{n
f pl}. In both cases, the generator would receive as input a word that
is impossible to generate, since the Catalan morphological dictionary
does not contain any entry with lemma \emph{llit} and feminine gender.


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>cama<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/></\textbf{l}>
    <\textbf{r}>llit<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Bilingual dictionary entry for the translation \emph{cama}
(\texttt{es})--\emph{llit} (\texttt{ca})}
\label{fg:cama}
\end{figure}


In this example, the number symbols are not specified; therefore, it
works for the correspondence \textit{cama--llit} (singular) as well as
for \textit{camas--llits} (plural).  However, when there is a number
change, the only way is to specify also the gender if the order used
in all the dictionary for grammatical symbols is \emph{gender,
number}.



By means of a direction restriction \texttt{r} we can indicate which
translations are to be done only in one direction and not in the other
one (see the description of the restrictions \texttt{LR} and
\texttt{RL} in page \pageref{restric}).  This is necessary when the
correspondence between two lexical forms is not symmetrical; in such
case, in the bilingual dictionary two or more entries have to be
created and a direction restriction must be applied, like in the
example shown in Figure~\ref{fg:postre}. In this example, when
translating from Spanish to Catalan (\texttt{LR}), we must generate
only plural forms, since the word \textit{postres} ("dessert" ) in
Catalan does not have singular form.  But, on the other hand, we will
translate into Spanish only in plural form (although in Spanish the
word has singular and plural forms), since it is not possible to
determine, from the Catalan word, whether the number should be
singular or plural.

\begin{figure}[htbp]
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{r}="LR">
  <\textbf{p}>
    <\textbf{l}>postre<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sg"/></\textbf{l}>
    <\textbf{r}>postres<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>

<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>postre<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{l}>
    <\textbf{r}>postres<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Entries in the Spanish-Catalan bilingual dictionary for the
correspondence \emph{postre}--\emph{postres} ("dessert")}
\label{fg:postre}
\end{figure}


\label{pg:GD} There is another problem due to grammatical divergences
between two languages that is resolved with the help of two special
symbols, \texttt{GD} (for \textit{gender to be determined}) and
\texttt{ND} (for \textit{number to be determined}), symbols which have
to be defined in the symbol section of the bilingual dictionary. This
problem arises when the grammatical information of a SL lexical form
is not enough to determine the gender (masculine or feminine) or the
number (singular or plural) of the TL lexical form.  Let's put an
example: the Spanish adjective \textit{común} ("common") is masculine
and feminine at the same time (and, therefore, masculine--feminine,
\texttt{mf}), but in Catalan the adjective has different forms for the
masculine, \textit{comú}/\textit{comuns}, and the feminine,
\textit{comuna}/\textit{comunes}.  In the bilingual dictionary, the
entry should be as shown in Figure~\ref{fg:comuna}: in the \texttt{LR}
direction (from Spanish to Catalan), the gender information is not
\texttt{m}, \texttt{f} nor \texttt{mf} but \texttt{GD}; this
\textit{gender to be determined} will be determined next by the
structural transfer module, by means of the application of the
suitable transfer rules (usually, rules for the agreement between the
lexical forms in a pattern; see Section \ref{ss:transfer} to obtain a
detailed description of transfer rules). In an analogous way, a
similar mechanism exists for singular--plural using the symbol
\texttt{ND} (for example, in Spanish \textit{análisis} ("analysis") is
singular and plural, whereas in Catalan the singular form is
\textit{anàlisi} and the plural form \textit{anàlisis}).


\begin{figure}[htbp]
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{r}="LR">
  <\textbf{p}>
    <\textbf{l}>común<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>comú<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="GD"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>

<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>común<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>comú<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>

<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>común<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>comú<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="f"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Entries in the Spanish--Catalan bilingual dictionary for the
  correspondence \emph{común}--\emph{comú} ("common"), the first one
  for the translation from Spanish to Catalan and the two others for
  the translation from Catalan to Spanish}
\label{fg:comuna}


\end{figure}



\paragraph{Post-generation dictionaries}
\label{ss:postgen}



In the morphological dictionary, the lexical forms which, once
generated, may undergo contraction, apostrophation or other
transformations, depending of which words are in contact with them in
the output text, must have the post-generator activation mark
(\texttt{<\textbf{a}/>}, see page \pageref{ss:a}) in the generation
entry (\texttt{RL} direction).  It is essential that the surface forms
marked with the post-generator activation mark are identical in the
morphological and the post-generation dictionaries of the same
translator. In the post-generation dictionary, all entries begin with
this activation mark.


In Figure~\ref{fg:postgen} there is an extract of the Spanish
post-generator; the example shows how the contraction for \textit{de}
and \textit{el} is done, to form the word \textit{del}.  The paradigm
\texttt{puntuación} not defined in the example contains the
non-alphabetic characters that can appear in a text. We can see in the
example that the entry for the preposition \emph{de} has the mark
\texttt{<\textbf{a}/>}. The paradigm assigned to this entry,
"\texttt{el}", is the one defined just above. According to this entry,
when the system receives as input the left string of the entry (the part
between \texttt{<\textbf{l}>}) concatenated to the left string of
the paradigm (that is, when the input is
\texttt{"}\texttt{<a/>\textbf{de}<b/>\textbf{el}<b/>"} or
\texttt{"}\texttt{<a/>\textbf{de}\\<b/>\textbf{el}[puntuación]}\texttt{"}),
the module delivers as output string (the part between \texttt{<r>}
elements) the string \texttt{"}\textbf{del}\texttt{"} followed by the
blanks represented with \texttt{<b/>} or by the symbols represented
with \texttt{[puntu\-a\-ción]}. Note that, in the module output, all
the marks \texttt{<\textbf{a}/>} have been removed.





\begin{figure}[htbp]
\begin{small}
\begin{alltt} 
<\textbf{dictionary}>
<\textbf{pardefs}>
  ... 
  <\textbf{pardef} \textsl{n}="el">
    <\textbf{e}>
      <\textbf{p}>
        <\textbf{l}>el<\textbf{b}/></\textbf{l}>
        <\textbf{r}>l<\textbf{b}/></\textbf{r}>
      </\textbf{p}>
    </\textbf{e}>
    <\textbf{e}>
      <\textbf{p}>
        <\textbf{l}>el</\textbf{l}>
        <\textbf{r}>l</\textbf{r}>
      </\textbf{p}>
      <\textbf{par} \textsl{n}="puntuación"/>
    </\textbf{e}>
  </\textbf{pardef}>
  ... 
</\textbf{pardefs}>
<\textbf{section} \textsl{id}="main" \textsl{type}="standard">
  ... 
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}><\textbf{a}/>de<\textbf{b}/></\textbf{l}>
      <\textbf{r}>de</\textbf{r}>
    </\textbf{p}>
    <\textbf{par} \textsl{n}="el"/>
  </\textbf{e}>
  ... 
</\textbf{section}/>
</\textbf{ditionary}>
\end{alltt}
\end{small}
\caption{Post-generation dictionary data to perform the contraction
  for Spanish \emph{de} + \emph{el} = \emph{del} .}
\label{fg:postgen}
\end{figure} \nota{en l'exemple, "el" no ha de portar la marca
d'activació oi? - l'he treta de l'exemple, treure-la dels diccionaris
(Mikel?)}


%\settocdepth{subsubsection}


\subsubsection{Multiword lexical units}
\label{ss:multipalabras}


The designed dictionary format allows the creation of
\textit{multiword lexical units} ---in short, \textit{multiwords}---
of different kinds, depending on the problem to be approached.

In this project we have considered three basic types of multiwords:
\begin{enumerate}
\item The most simple case are \textit{multiwords without inflection},
  which consist of only one lexical form: the lemma is made of two or
  more invariable orthographic words but it is tagged as a unit.
  Figure \ref{fig:msf} shows an example of invariable multiword (the
  Spanish expression \emph{hoy en día}, "nowadays"): It is made of
  three words separated by a blank (\texttt{<\textbf{b}/>}) and,
  although it actually consists of an adverb, a preposition and a
  noun, it is tagged as an adverb as a whole, since it acts as one.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="hoy en día">
  <\textbf{p}>
    <\textbf{l}>hoy<\textbf{b}/>en<\textbf{b}/>día</\textbf{l}>
    <\textbf{r}>hoy<\textbf{b}/>en<\textbf{b}/>día<\textbf{s} \textsl{n}="adv"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Example of multiword without inflection in the morphological
dictionary}
\label{fig:msf}
\end{figure}

\item A more complicated issue is the case of \textit{compound
  multiwords}, made of more than one lexical form, each one with its
  grammatical symbols. The words they are made of are considered not
  to build a semantic unit like in the previous case, but to appear
  together building a unit due to contact reasons (phonetic or
  orthographic reasons). In this category we include
  \textit{contractions} and \textit{enclitic pronouns} accompanying
  verbs.  To mark this phenomenon we use the tag \texttt{<\textbf{j}>}
  described in page~\pageref{ss:j}. You can see an example in
  Figure~\ref{fig:cont}, in which the analysis of \emph{del} delivers
  a lexical multiform made of two lexical forms: \emph{de},
  preposition, and \emph{el}, singular masculine definite determiner,
  linked with the \texttt{<\textbf{j}/>} element. The analyser and the
  part-of-speech tagger handle this multiwords as a unit; however,
  before entering the transfer module, they are processed by an
  auxiliary module called \texttt{pretransfer} (see section
  \ref{se:pretransfer}) which is responsible for separating the
  lexical forms they are made of. This way, they reach the transfer
  module as independent forms; the linguist has to decide whether they
  have to be joined again (which must be done in the structural
  transfer module) or they have to remain as independent forms through
  the next modules.


  In our system, the elements forming a contraction continue as
independent forms, and the post-generator is responsible for making
the contractions in the target language if it is necessary. On the
other hand, enclitic pronouns are joined again to the verb by means of
a structural transfer rule (see Section \ref{ss:transfer}), so the
verb plus its enclitic pronouns get into the generation module as a
single lexical multiform, its components joined with a
\texttt{<\textbf{j}/>}. Therefore, entries containing enclitic
pronouns must not have any direction restriction, as can be seen in
the example in Figure \ref{fig:encl}, which shows a part of the
paradigm for the Spanish verb "dar" ("to give"), specifically the
entry for the infinitive form joined to an enclitic pronoun.


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="del" \textsl{r}="LR">
  <\textbf{p}>
    <\textbf{l}>del</\textbf{l}>
    <\textbf{r}>de<\textbf{s} \textsl{n}="pr"/><\textbf{j}/>
     el<\textbf{s} \textsl{n}="det"/><\textbf{s} \textsl{n}="def"/>
     <\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{Entry in the morphological dictionary for the analysis of a
contraction (the Spanish contraction \emph{del})}
\label{fig:cont}
\end{figure}

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>ar</\textbf{l}>
    <\textbf{r}>ar<\textbf{s} \textsl{n}="vblex"/><\textbf{s} \textsl{n}="inf"/><\textbf{j}/></\textbf{r}>
  </\textbf{p}>
  <\textbf{par} \textsl{n}="S__cantar"/>
</\textbf{e}>
\end{alltt}
\end{small}
\caption{A fragment of the inflection paradigm for the Spanish verb
\emph{dar} ("to give"), which shows the entry for the infinitive form
followed by an enclitic pronoun. Enclitic pronouns are contained in
the paradigm \texttt{S\_\_cantar}. Note that, unlike in Figure
\ref{fig:cont}, this entry is both for analysis and generation.}
\label{fig:encl}
\end{figure}



\item The most complicated case in our system is the case of
  \textit{multiwords with inner inflection} inside the lemma (or
  "split lemma" forms), like the example shown in Figure
  \ref{fig:echardemenos}. The lemma of this kind of multiwords has one
  part with inflection (the \emph{lemma head}) followed by one
  invariable part (the \emph{lemma tail}).  The invariable part has to
  be put between \texttt{<\textbf{g}>} elements, so that it can be
  moved to the position immediately after the lemma head to obtain the
  whole lemma of the multiword. For example, the lemma of the Spanish
  multiwords \emph{echó de menos} ("he/she missed"), \emph{echándole
  de menos} ("missing him/her"), etc.  has to be \emph{echar de menos}
  ("to miss"), since this form will be the one searched in the
  bilingual dictionary to find its translation.  This means that the
  invariable lemma tail (\emph{de menos}) has to be moved after the
  uninflected lemma head (\emph{echar}). This moving backwards will be
  done by the auxiliary module \texttt{pretransfer} (see section
  \ref{se:pretransfer}) which runs before the structural transfer
  module.

  To understand the example in Figure \ref{fig:echardemenos}, you have
  to be aware that the paradigm defining the verb \emph{echar}
  includes, besides the verb inflection, the enclitic pronouns that
  can appear at the end of the inflected forms of the verb; in the
  output lexical multiform, this enclitic pronouns are joined using
  the empty element \texttt{<\textbf{j}/>}.



\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="echar de menos"> 
  <\textbf{i}>ech</\textbf{i}>
  <\textbf{par} \textsl{n}="aspir/ar__vblex"/> <!-it includes enclitic pronouns -->
  <\textbf{p}>
    <\textbf{l}><\textbf{b}/>de<\textbf{b}/>menos</\textbf{l}>
    <\textbf{r}><\textbf{g}><\textbf{b}/>de<\textbf{b}/>menos</\textbf{g}></\textbf{r}>
  </\textbf{p}> 
</\textbf{e}>
\end{alltt}
\end{small}
\caption{A morphological dictionary entry containing a
  \texttt{<\textbf{g}>} group.}
\label{fig:echardemenos}
\label{fig:hacertilin}
\end{figure}



When the translation is also a \emph{split lemma} (for example, the
translation of "to miss" in Catalan is \emph{trobar a faltar}, with
forms like \emph{trobem a faltar}, \emph{trobar-lo a faltar}, etc.),
it is necessary to place again the lemma tail in its original place,
after the inflected form plus the enclitic pronouns (if any), and
indicate the correspondence of these invariable parts of the lemma
(\emph{de menos}, \emph{a faltar}) at both sides of the
translation. So, in the example of Figure ~\ref{fig:echardemenos}, the
\texttt{<\textbf{g}>} element is used to mark the group
`\texttt{<b/>de<b/>menos}' in the morphological dictionary, whereas in
the bilingual dictionary (see Figure~\ref{fig:menosfaltar}), the
\texttt{<\textbf{g}>} element is used to establish the correspondence
between the groups ``\texttt{<b/>de<b/>menos}'' and
``\texttt{<b/>a<b/>faltar}''. \nota{I com serà el cas de ``dirección
general'' - ``direcciones generales''?}

If the translation is not a \emph{split lemma}, you do not need to
insert any \texttt{<\textbf{g}>} element in the target language
string.

\end{enumerate}

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>echar<\textbf{g}><\textbf{b}/>de<\textbf{b}/>menos</\textbf{g}><\textbf{s} \textsl{n}="vblex"/></\textbf{l}>
    <\textbf{r}>trobar<\textbf{g}><\textbf{b}/>a<\textbf{b}/>faltar</\textbf{g}><\textbf{s} \textsl{n}="vblex"/></\textbf{r}>
  </\textbf{p}> 
</\textbf{e}>
\end{alltt}
\end{small}
\caption{A bilingual dictionary entry containing two corresponding
\texttt{<\textbf{g}>} groups.}
\label{fig:menosfaltar}
\end{figure}

\subsubsection{Metaparadigms}
\label{ss:metaparadigmas}


\nota{Marco diu: Especificar la DTD?}


When developing the dictionaries for the Occitan translator, we were
faced with a new need: we wanted to be able to specify paradigms for
verbs that had a same inflection pattern but whose root changed in the
different inflected forms.  With the existing paradigm system, a new
paradigm had to be created for each of these verbs, since it was only
possible to specify an inflection regularity pattern for a group of
verbs with invariable root. With metaparadigms, it is possible to
specify the inflection regularity as well as verb root variations.

At the same time, metaparadigms allow the specification, in a single
paradigm, of variations in the grammatical symbols of a lemma.  That
is, several lemmas can refer to a same metaparadigm even if they have
different grammatical symbols. Whereas for Occitan, metaparadigms have
allowed having a same paradigm for entries with root variations, for
English, these have allowed having a same paradigm for entries with
variations in their grammatical symbols.


Related with this, we created the concept of metadictionary: it is a
dictionary which contains metaparadigms as well as the normal
paradigms used so far. The name of a metadictionary is
\texttt{apertium-PAIR.}$L_1$\texttt{.metadix}
(for example, for the English monolingual dictionary in the
Apertium-en-ca system, \texttt{apertium-en-ca.en.metadix}).  When
linguistic data are compiled these dictionaries are pre-processed, so
that they have the appropriate format for the dictionary compiler.

\paragraph{Specification of metaparadigms}

Metaparadigms are defined in the \texttt{<\textbf{pardefs}>} section
of the monolingual dictionary, the same section where also the rest of
the dictionary paradigms are defined. A metaparadigm, just like a
paradigm, has a name specified in the attribute \texttt{n}.  This name
will have the same characteristics as in the other paradigms, with the
difference that the variable part of the lemma root will be in brackets and
in capital letters, as you can see in this example:

\begin{alltt} 
<\textbf{pardef} n="m/é[T]er\_\_vblex">
\end{alltt}

This is the definition of a verb paradigm, where the inflection
endings have a variable part in the root.  The inflection paradigms
specified inside this metaparadigm have to present inflection only in
the part at the right of the brackets, for example like the one
specified in the paradigm:

\begin{alltt} 
<\textbf{par} n="mét/er\_\_vblex"/>
\end{alltt}


In conclusion, a complete example of metaparadigm definition would be:


\begin{alltt}
<\textbf{pardef} n="m/é[T]er__vblex">
  <\textbf{e}> 
    <\textbf{p}> 
      <\textbf{l}>e</\textbf{l}>
      <\textbf{r}>é</\textbf{r}> 
    </\textbf{p}>
    <\textbf{i}><prm/></\textbf{i}> 
    <\textbf{par} n="sent/eria__vblex"/>
  </\textbf{e}> 
  <\textbf{e}> 
    <\textbf{i}>é<prm/></\textbf{i}>
    <\textbf{par} n="mét/er__vblex"/> 
  </\textbf{e}> 
</\textbf{pardef}>

\end{alltt}


The tag \texttt{<\textbf{prm}/>} is the marker that is used to place
the variable text part (the root variation) in the paradigm
definition.


Once a metaparadigm is defined, we may want that a verb uses it. To do
so, in the verb entry (inside a \texttt{<\textbf{e}>} element) we must
indicate the suitable metaparadigm and, through the attribute
\texttt{prm}, define with which letters we want to replace the
variable part specified in brackets. For example:

\begin{alltt} 
<\textbf{e} lm="acuélher"> 
  <\textbf{i}>acu</\textbf{i}>
  <\textbf{par} n="m/é[T]er__vblex" prm="lh"/> 
</\textbf{e}>

\end{alltt}

This entry defines the Occitan verb \emph{acuélher} ("to receive") and
specifies that its inflection paradigm is the one defined by the
metaparadigm \texttt{m/é[T]er\_\_vblex}, but replacing \texttt{T} with
\texttt{lh}; that is, the letters following \emph{acu} will be
\emph{élher} instead of \emph{éter}.



As mentioned before, metaparadigms can also be used for entries which
have some variation in their grammatical symbols. The way to specify
them is basically the same: the variable part must be specified in the
entry with the attribute \texttt{sa}, whereas in the paradigm the tag
\texttt{<\textbf{sa}>} has to be placed where the optional grammatical
symbol should appear.

For example, we have the following metaparadigm:

\begin{alltt}
<\textbf{pardef} n="house__n">
  <\textbf{e}> 
    <\textbf{p}> 
      <\textbf{l}/> 
      <\textbf{r}><\textbf{s} n="n"/><sa/><\textbf{s} n="sg"/></\textbf{r}> 
    </\textbf{p}>
  </\textbf{e}>
  <\textbf{e}> 
    <\textbf{p}> 
      <\textbf{l}>s</\textbf{l}>
      <\textbf{r}><\textbf{s} n="n"/><sa/><\textbf{s} n="pl"/></r>
    </\textbf{p}> 
  </\textbf{e}>
</\textbf{pardef}>

\end{alltt}


and the following entry:

\begin{alltt} 
<\textbf{e} lm="time"> 
  <\textbf{i}>time</\textbf{i}>
  <\textbf{par} n="house__n" sa="unc"/> 
</\textbf{e}>
\end{alltt}

where \emph{unc} means that the noun is uncountable.

In the metaparadigm, the tag \texttt{<\textbf{sa}>} shows the place
where the grammatical symbol is to be placed if an entry contains the
attribute \texttt{sa} with a value, as happens in the entry for
\emph{time}.


A dictionary which contains entries like the ones described here is
called metadictionary and must be pre-processed in order to generate a
dictionary that follows the DTD for Apertium 2, since the engine does
not allow the direct use of metaparadigms. The next section describes
how is this pre-processing like.




\paragraph{Pre-processing of the metadictionary}


A metadictionary is an XML file to which two XSLT style sheets are
applied, in order to pre-process the metaparadigms and obtain a
dictionary with all the paradigms derived from the metaparadigms.  The
first style sheet, \texttt{buscaPar.xsl}, produces the list of verbs
that use metaparadigms and deletes the possible repetitions of
metaparadigms to be expanded. This style sheet generates, in
combination with the sheet \texttt{principal.xsl}, a second style
sheet called \texttt{gen.xsl}, which processes the metadictionary with
the list of metaparadigms to be expanded and generates a dictionary in
Apertium 2 format. Basically, what this generated style sheet does is:

\begin{enumerate}


\item In verb entries, if a verb uses a metaparadigm, this
metaparadigm is replaced by the corresponding expanded and
deparametrized paradigm. Thus, the previous example entry:

\begin{alltt}
<\textbf{e} lm="acuélher">
  <\textbf{i}>acu</\textbf{i}>
  <\textbf{par} n="m/é[T]er__vblex" prm="lh"/>
</\textbf{e}>
\end{alltt}

	would be deparametrized and expanded into:

\begin{alltt} 
<\textbf{e} lm="acuélher">
  <\textbf{i}>acu</\textbf{i}>
  <\textbf{par} n="m/élher__vblex"/>
</\textbf{e}>
\end{alltt}


\item On the other hand, since from the first pass the system knows
which paradigms have to be created from metaparadigms, these are
created.  In the previous example, from the metaparadigm:

\begin{alltt}
<\textbf{pardef} n="m/é[T]er__vblex">
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>e</\textbf{l}>
      <\textbf{r}>é</\textbf{r}>
    </\textbf{p}>
    <\textbf{i}><prm/></\textbf{i}>
    <\textbf{par} n="sent/eria__vblex"/>
  </\textbf{e}>
  <\textbf{e}>
    <\textbf{i}>é<prm/></\textbf{i}>
    <\textbf{par} n="mét/er__vblex"/>
  </\textbf{e}>
</\textbf{pardef}>     
\end{alltt}

	the system would generate the paradigm
	\texttt{"m/élher\_\_vblex"} :

\begin{alltt}
<\textbf{pardef} n="m/élher__vblex">
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}>e</\textbf{l}>
      <\textbf{r}>é</\textbf{r}>
    </\textbf{p}>
    <\textbf{i}>lh/></\textbf{i}>
    <\textbf{par} n="sent/eria__vblex"/>
  </\textbf{e}>
  <\textbf{e}>
    <\textbf{i}>élh</\textbf{i}>
    <\textbf{par} n="mét/er__vblex"/>
  </\textbf{e}>
</\textbf{pardef}>  
\end{alltt}

\end{enumerate}

After the metadictionary has been processed according to these steps,
a .dix dictionary is generated which follows the DTD for Apertium 2
and which can already be compiled.

 
In the case of our second example, where the variable part was the
sequence of grammatical symbols in the paradigm, the style sheets
would be applied and, from the value \emph{unc} specified in the
attribute \texttt{sa}, the following paradigm would be generated:

\begin{alltt}
<\textbf{pardef} n="house__n__unc">
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}/>
      <\textbf{r}><\textbf{s} n="n"/><\textbf{s} n="unc"/><\textbf{s} n="sg"/></\textbf{r}>
    </\textbf{p}>
 </\textbf{e}>
 <\textbf{e}>
   <\textbf{p}>
     <\textbf{l}>s</\textbf{l}>
     <\textbf{r}><\textbf{s} n="n"/><\textbf{s} n="unc"/><\textbf{s} n="pl"/></r>
   </\textbf{p}>
 </\textbf{e}>
</\textbf{pardef}>

\end{alltt}

for nouns the morphological analysis of which should be (in data
stream format):


\begin{alltt} 
time<n><unc><sg>
\end{alltt}

In this case, metaparadigms allows the use of the same paradigm for
entries with the same inflection but with a slightly different
morphological analysis.

It is important to note that, when a dictionary uses metaparadigms
and, accordingly, its name has the extension \texttt{.metadix}, this
will be the file where dictionary changes have to be made (adding,
changing or deleting entries or paradigms), since the file
\texttt{.dix} is automatically generated from this one every time
linguistic data are compiled and, therefore, any changes made in the
latter will be overwritten during compilation.

\subsubsection{Analysis characters}
\label{acx}

Version 3 of the Apertium platform includes Unicode support; however,
this lead to a new problem: alternate characters. Unicode supports
several character sets, which include several characters that look
identical or almost identical, but which have a different numeric value.

As a solution, equivalent characters can be specified in a file that
complements the morphological dictionary. As the morphological 
dictionary is compiled, whenever a character mentioned in the 
analysis character specification is encountered, its equivalents are
included as though they had been specified using entries specified with
the \texttt{LR} restriction within the dictionary. 

\begin{figure}
\begin{small}
\begin{alltt}
<?\textbf{xml} \textsl{version}="1.0"?>
<\textbf{analysis-chars}>
  <\textbf{char} \textsl{value}="'">
    <\textbf{equiv-char} \textsl{value}="\&#x2019;"/>
    <\textbf{equiv-char} \textsl{value}="\&#x2BC;"/>
  </\textbf{char}>
  <\textbf{char} \textsl{value}="\&#183;">
    <\textbf{equiv-char} \textsl{value}="."/>
  </\textbf{char}>
</\textbf{analysis-chars}>
\end{alltt}
\end{small}
\caption{Analysis character specification file}
\label{fg:acxsample}
\end{figure}

A sample analysis characters specification file can be seen in Figure
\ref{fg:acxsample}. It's worth noting that the analysis characters
file can only be used when there is a 1:1 mapping between individual
characters; in the case of multiple characters, it would be better to
use the example given earlier, in Figure \ref{fig:pardef2}

\subsection[Automatic generation of the modules]{Automatic generation
of the lexical processing modules}
\label{se:compiladoresdic}


The four lexical processing modules (morphological analyser, lexical
transfer, morphological generator and post-generator) are compiled
from dictionaries by means of a single compiler based
on letter transducers \cite{roche97}. This compiler is much faster
than the ones used in the systems \textsf{interNOSTRUM}
\cite{canals01b,garridoalenda01p,garrido99j} and \textsf{Traductor
Universia} \cite{garrido03p, gilabert03j}, thanks to the use of new
compiler building strategies and the minimization of partial
transducers during the building process \cite{ortiz05j}.

The division of dictionary entries into lemma and paradigm enables the
effective construction of minimal letter transducers. The compiler
makes the most of the factorization allowed by paradigms in order to
speed up the construction. Taking into account that, in most European
languages, word variations occur at the end or the beginning of words,
we took advantage of this fact to improve the construction speed of
the minimal transducer.

Paradigms are also minimized before being inserted in the big
transducer in order to reduce the size of the big transducer before
its minimization.  Since, before minimizing, the paradigms of the
dictionaries for the languages we have dealt with usually have just a
few hundreds of states, the minimization of these paradigms is a very
fast process.

If we assume that an entry can have at any point a reference to a
paradigm, we could decide to copy at this point the transducer
calculated in the paradigm definition. The method used in
\emph{Apertium} is based on the idea that it is not always necessary
to copy, because in certain cases it is possible to reuse a paradigm
that was already copied.  In particular, two or more entries that
share a paradigm as a suffix can reuse the same copy of this paradigm;
the same can be said when it is as a prefix. However, generally it is
not possible to reuse paradigms if they are located in intermediate
positions of different entries, since new suffixes (or prefixes) can
be added to existing entries, which causes the information inserted in
the transducer not to be consistent with the dictionary, and therefore
the generated transducer would be incorrect (it would add string pairs
that are not present in the formal language defined by dictionaries).

Minimal letter transducers are built as explained next. From a string
transduction it is possible to build a \textit{sequence of letter
transductions} $S(s:t)$ with length $N = \max(|s|,|t|)$ which is
defined as follows for each element $1 \leq i \leq N$:


\begin{equation}
\label{eq:transletras} S_i(s:t)=\left\{
\begin{array}{ll} 
(s_i:\theta) & \textrm{if } i \leq |s| \wedge i > |t| \\ 
(\theta:t_i) & \textrm{if } i \leq |t| \wedge i > |s| \\
(s_i:t_i) & \textrm{in other cases}
\end{array}\right.
\label{e:montaje}
\end{equation}
 
It should be emphasized that the construction design forbids the
existence of a $(s:t)$ that is equal to $(\epsilon:\epsilon)$, which
is crucial for the consistence of the building method.

The building method uses two procedures: the \textit{assembly}
procedure inferred from equation \ref{e:montaje}, and the minimization
procedure, which is executed by a conventional minimization algorithm
\cite{vandesnepscheut93b} for deterministic finite state automata,
which consists of inverting, determining, inverting again and
determining again, taking as the alphabet of the automaton to be
minimized the Cartesian product of $L$ and as empty transition the
$\left(\theta:\theta\right)$.


\begin{figure}
\begin{center}
\includegraphics[width=10cm]{fig1}
\end{center}
\caption{Building of the dictionary as prefix acceptor and link to
paradigms through transitions $\left(\theta:\theta\right)$.}
\label{fig:construccion}
\end{figure}

\begin{figure}
\begin{center}
\includegraphics[width=8cm]{fig2}
\end{center}
\caption{Minimized paradigm "-es \textbf{n m}" used in Figure
\ref{fig:construccion}.}
\label{fig:paradigmapan}
\end{figure}

\begin{figure}
\begin{center}
\includegraphics[width=8cm]{fig3}
\end{center}
\caption{Minimized paradigm "z/-ces \textbf{n m}" used in Figure
\ref{fig:construccion}.}
\label{fig:paradigmavez}
\end{figure}



Figure \ref{fig:construccion} shows a simplified example of the
assembly process.  Transductions, composed as in the equation
\ref{e:montaje}, are inserted one by one in a transducer in the form
of a \textit{prefix acceptor} or \textit{trie}, that is, in a way that
there is only one node for each common prefix of the group of
transductions that form the dictionary.  With the suffixes of the
transductions (that are not shared) new states are created.  In the
point where there is a reference to a paradigm, a replica of this
paradigm is created and a link is created to the dictionary entry
which is being inserted in the transducer by means of a null
transduction $\left(\theta:\theta\right)$.

Each paradigm, as it can be seen as a little dictionary, has been
built according to this same procedure and been minimized to reduce
the size of the content when building the big dictionary. In Figures
\ref{fig:paradigmapan} and \ref{fig:paradigmavez} you can see the
state of the paradigms used in Figure \ref{fig:construccion} after its
minimization.



\section{Part-of-speech tagger}
\label{ss:tagger}

\subsection{Module description }
\label{functagger}


The part-of-speech tagger is based on first-order hidden Markov
models~\cite{rabiner89}, that is, on statistical data. The states of
the Markov model represent parts of speech, and the observable
parameters are ambiguity classes~\cite{cutting92a}, formed by groups
of parts of speech.

In spite of working with statistical information, the training and
behaviour of the tagger improve with the application of restrictions
that forbid certain sequences of parts of speech (in the first-order
models, these sequences can only include two parts of speech). For
example, in Spanish or Catalan a preposition can never be followed by
a verb in personal form; this restriction is of great help when the
word after a preposition is ambiguous and one of its possible analyses
is a verb in personal form (e.g., \emph{de trabajo}, \emph{en
libertad}, etc.).  Restrictions are explicitly declared in the tagger
definition file, sometimes in the form of \emph{prohibitions} and
sometimes of \emph{obligations}.

The morphological tags which the tagger works with are not the same as
the ones used in the morphological analyser. Usually, the information
delivered by the analyser is too detailed for the purposes of the
part-of-speech disambiguation (for example, for most purposes, it
suffices to group in the same category all common nouns, regardless of
their gender and number). The use of finer-grained tags does not improve the
results, whereas it increases the number of parameters to be estimated
and intensifies the problem of lack of linguistic resources such as
manually disambiguated texts. For this reason, in the tagger file one
has to specify how to group the \emph{fine-grained} tags delivered by the
morphological analyser into more general \emph{coarse} tags ---which
we will call \emph{categories}--- that will be used in the
part-of-speech disambiguation. Apart from coarse categories, one can
also define lexicalized tags. Basically there are two types of
lexicalizations described in bibliography: one type adds new
observables and the other one, in addition, adds new states to the
Markov model~\cite{pla04}; the tagger in Apertium uses the latter
lexicalization type.

It is important to note that, in spite of working with \emph{coarse}
categories, the tagger outputs fine-grained tags like the ones from the
morphological analyser. Sometimes it may occur that the morphological
analyser delivers, for a certain word, two or more fine-grained tags that can
be grouped under the same tagger category: e.g. in Spanish
\emph{cante} can be the 1st or the 3rd singular person of the
subjunctive present of the verb \emph{cantar} ("to sing"); both fine-grained
tags, \texttt{\emph{<vblex><prs><p1><sg>}} and
\texttt{\emph{<vblex><prs><p3><sg>}}, are grouped under the tagger
category \ \texttt{VLEXSUBJ} (\emph{subjunctive verb}). In this case,
one of both fine tags is discarded; in the tagger definition file it
is possible to define which fine-grained tag, among the ones that compose a
coarse tag, will be delivered after disambiguation.




\subsection{Data for the part-of-speech tagger}
\label{datostagger}
\subsubsection{Introduction}
\label{ss:introtagger} We describe next the format of the files that
specify how to group the \emph{fine-grained} tags delivered by the
morphological analyser into more general \emph{coarse} tags.  In this
files, moreover, one can specify \emph{restrictions} that help in the
estimation of the statistical model underlying the process of lexical
disambiguation, as well as preference rules to be applied when two
fine-grained tags belong to the same category.


The tagger assumes that, in the input stream, lexical forms will be
appropriately delimited, as described in the format specification for
the data stream between modules (Section \ref{se:flujodatos}). In
brief, the format of the data delivered by the morphological analyser
is the following:
\begin{equation}
\label{eq:formaanalizada}
  \begin{array}{rcl} 
  \mbox{analysedform}&\to& \mbox{lexicalmultiform}\; 
  [\; \mbox{lexicalmultiform} \; ]^* 
\\
  \mbox{lexicalmultiform}&\to& \mbox{lexicalform}\; [\;\mbox{lexicalform}\; ]^*\;\mbox{lemma-queue?} \\
  \mbox{lexicalform}&\to&\mbox{lemma}\;\mbox{finetag}\\
  \mbox{lemma-queue}&\to&\mbox{lemma}\\
  \mbox{finetag}&\to&\mbox{morphsymbol}\;[\;\mbox{morphsymbol}\;]^* \\
  \end{array}
\end{equation}
\label{formaanalizada}

where:


\begin{itemize}
\item \emph{analysedform} is all the information delivered for each
surface form in the output of the morphological analyser
\item \emph{lexicalmultiform} is a sequence of one or more lexical
forms followed, optionally, by an invariable queue as happens in some
multiwords (like the Spanish expression \emph{cántale las cuarenta}).
\item \emph{lexicalforms}\footnote{Separated from each other by a
delimiter which corresponds to the \texttt{<j/>} element (see page
\pageref{ss:j}).} are units made of one lemma and one or more
grammatical symbols (which compose the fine-grained tag) with the output
information of the analyser
\item \emph{lemma-queue} is made of one or more lemmas
  \footnote{Separated from each other by the \texttt{<b/>} element
  (see page~\pageref{s3:b}).} that are the invariable part of a
  multiword. The queue of a multiword is made of the lemma or lemmas
  with no inflection that follow the lemmas with inflection. For
  example, the Spanish multiword \emph{cantar las cuarenta} ("to
  lecture", "to reproach") can take the forms \emph{cántale las
  cuarenta}, \emph{(le) cantaré las cuarenta}, \emph{cantándole las
  cuarenta}, etc. In this case, the queue would be \emph{las cuarenta}
  (see page~\pageref{ss:multipalabras} for more information).

\item \emph{finetag} is made of one or more grammatical symbols
(\emph{símbologram}).
\end{itemize}

For example, the entry for the Spanish ambiguous surface form
\emph{correos} would have two lexical multiforms; the first lexical
multiform would have one single lexical form, with lemma \emph{correo}
("post office") and a fine tag made of the grammatical symbols
\emph{common noun}, \emph{masculine}, \emph{plural}; the second
lexical multiform would be a sequence of two lexical forms, one with
lemma \emph{correr} ("to move") and a fine tag made of the grammatical
symbols \emph{lexical verb}, \emph{imperative}, \emph{second person},
\emph{plural}, and the other one with lemma \emph{vosotros} ("you")
and fine tag made of the grammatical symbols \emph{pronoun},
\emph{enclitic}, \emph{second person}, \emph{masculine-feminine},
\emph{plural}.

\nota{An  explanation of how a word containing more than one
  lexical form is treated when no multilexical form is defined for it
  should be added}

\subsubsection{Format specification}
\label{formatotagger} The format of the file (encoded in XML) is
specified by the DTD that can be found in
Appendix~\ref{ss:DTD_desambiguador}.


The meaning of the different tags is the following:
\begin{description}
\item[\texttt{tagger}]: is the root element; its mandatory attribute
\texttt{name} is used to specify the name of the tagger generated from
the file.
\item[\texttt{tagset}]: defines the \emph{coarse} tagset or categories
with which the tagger works. Categories are defined by the fine-grained tags
output by the morphological analyser.
\item[\texttt{def-label}]: defines a category or coarse tag (whose
  name is specified in the mandatory attribute \texttt{name}) by means
  of a list of fine tags defined with one or more \texttt{tags-item}
  elements; an optional attribute \texttt{closed} indicates whether
  this is a closed category; if this is the case, it is assumed that
  an unknown word can never belong to this category.\footnote{Closed
  categories are those that do not grow when new words are created:
  prepositions, determiners, conjunctions, etc.}
  
  The more specific categories \emph{must} be defined before the more
  general ones.  When the definition of a general category implicitly
  includes that of a specific category defined before, it is
  understood that it refers to all cases \emph{except} the ones
  defined by the more specific category.
 
\item[\texttt{tags-item}]: is used to define a fine-grained tag by means of a
sequence of grammatical symbols. The sequence of grammatical symbols
that make up the fine tag is specified in the mandatory attribute
\texttt{tags}. In this sequence, symbols are separated by a dot, and
the asterisk ``\texttt{*}'' is used to express that any sequence of
symbols may appear in its place. It is also possible to define
lexicalized categories, specifying the lemma of the word in the
attribute \texttt{lemma}.
  
\item[\texttt{def-mult}]: defines special categories
(\emph{multicategories}) made of more than one category, in order to
deal with entries with more than one lexical form, like in the example
given in the previous section. Each category is defined as a set of
valid sequences (\texttt{sequence}) of previously defined categories
or of fine-grained tags.  It is designed for contractions, verbs with enclitic
pronouns, etc.

\item[\texttt{sequence}]: defines a sequence of elements, which can be
categories (\texttt{label-item}) or fine-grained tags
(\texttt{tags-item}). Using fine-grained tags directly is useful if one wishes
to use a sequence of grammatical symbols that is not part of any
previously defined fine tag \nota{MG: en comptes de 'fine tag' no es
refereix aquí a 'category'?} or that represents a greater
specialization of a defined fine tag \nota{ídem: category}.
  
\item[\texttt{label-item}]: is used to refer to a category or coarse
tag previously defined, to be specified in the mandatory attribute
\texttt{label}.
  
\item[\texttt{forbid}]: this (optional) section is aimed to define
restrictions as sequences of categories \texttt{label-sequence} that
can not occur in the language involved. In the current version, due to
the fact that the tagger is based on first-order hidden Markov models,
sequences can only be made of \emph{two} \texttt{label-items}.
  
\item[\texttt{label-sequence}]: defines a sequence of categories
(\texttt{label-item}).

\item[\texttt{enforce-rules}]: this (optional) section allows defining
restrictions in the form of obligations.
  
\item[\texttt{enforce-after}]: defines a restriction that forces that
a certain category can only be followed by the categories belonging to
the set of categories defined in \texttt{label-set}. Note that this
kind of restrictions is equivalent to defining several forbidden
(\texttt{forbid}) sequences (\texttt{label-sequence}) with the
category defined in the mandatory attribute \texttt{label} and the
rest of categories that do not belong to the set defined in
\texttt{label-set}. For this reason, this kind of restriction must be
used very cautiously.
  
\item[\texttt{label-set}]: defines a set of categories
(\texttt{label-items}).

\item[\texttt{preferences}]: used to define priorities in terms of
which fine-grained tag must be delivered in the tagger output when two or more
fine tags are assigned to the same category.
  
\item[\texttt{prefer}]: specifies that, in case of conflict between
different fine-grained tags assigned to the same category, the tagger must
output the tag specified in the mandatory attribute \texttt{tags}. If
a category contains more than one of the fine tags included in these
\texttt{prefer} elements, the tag defined in the first place will be
the selected one.
\end{description}

Figures~\ref{fg:exemple_desambiguador1}
and~\ref{fg:exemple_desambiguador2} contain an example with the most
significant parts of a tagger specification file defined by the DTD
just described.

% DTD moguda a Apèndix


\begin{figure}[htbp]
  \begin{small}
    \begin{alltt} 
<?\textsl{xml} \textsl{version}="1.0" \textsl{encoding}="iso-8859-1"?>
<!\textsl{DOCTYPE} \textbf{tagger} SYSTEM "tagger.dtd">
<\textbf{tagger} \emph{name}="es-ca">
<\textbf{tagset}>
   <\textbf{def-label} \textsl{name}="adv">
      <\textbf{tags-item} \textsl{tags}="adv"/>
   </\textbf{def-label}>
   <\textbf{def-label} \textsl{name}="detnt" \textsl{closed}="true">
      <\textbf{tags-item} \textsl{tags}="detnt"/>
   </\textbf{def-label}>
   <\textbf{def-label} \textsl{name}="detm" \textsl{closed}="true">
      <\textbf{tags-item} \textsl{tags}="det.*.m"/>
   </\textbf{def-label}>
   <\textbf{def-label} \textsl{name}="vlexpfci">
      <\textbf{tags-item} \textsl{tags}="vblex.pri"/>
      <\textbf{tags-item} \textsl{tags}="vblex.fti"/>
      <\textbf{tags-item} \textsl{tags}="vblex.cni"/>
   </\textbf{def-label}>   
   <\textbf{def-mult} \textsl{name}="infserprnenc" \textsl{closed}="true">
      <\textbf{sequence}>
         <\textbf{label-item} \textsl{label}="vserinf"/>
         <\textbf{label-item} \textsl{label}="prnenc"/>
      </\textbf{sequence}>
      <\textbf{sequence}>
         <\textbf{label-item} \textsl{label}="vserinf"/>
         <\textbf{label-item} \textsl{label}="prnenc"/>
         <\textbf{label-item} \textsl{label}="prnenc"/>
      </\textbf{sequence}>
   </\textbf{def-mult}>   
   <\textbf{def-mult} \textsl{name}="prepdet" \textsl{closed}="true">
      <\textbf{sequence}>
         <\textbf{label-item} \textsl{label}="prep"/>
         <\textbf{tags-item} \textsl{tags}="det.def.m.sg"/>
      </\textbf{sequence}>
   </\textbf{def-mult}>
</\textbf{tagset}>
<!-- ... -->
    \end{alltt}
  \end{small}
  \caption{Example of a tagger definition file (continues in
  Figure~\ref{fg:exemple_desambiguador2}).}
  \label{fg:exemple_desambiguador1}
\end{figure}


\begin{figure}[htbp]
  \begin{small}
    \begin{alltt} 
<!-- ... -->
<\textbf{forbid}>
   <\textbf{label-sequence}>
      <\textbf{label-item} \textsl{label}=="prep"/>
      <\textbf{label-item} \textsl{label}=="vlexpfci"/>
   </\textbf{label-sequence}>
   <!-- ... -->
</\textbf{forbid}>
<\textbf{enforce-rules}>
   <\textbf{enforce-after} \textsl{label}=="prnpro">
      <\textbf{label-set}>
         <\textbf{label-item} \textsl{label}=="prnpro"/>
         <\textbf{label-item} \textsl{label}=="vlexpfci"/>
         <!-- ... -->
      </\textbf{label-set}>
   </\textbf{enforce-after}>
   <!-- ... -->
</\textbf{enforce-rules}>
<\textbf{preferences}>
   <\textbf{prefer} \textsl{tags}="vblex.pii.p3.sg"/>
   <\textbf{prefer} \textsl{tags}="vbser.pii.p3.sg"/>
   <!-- ... -->
</\textbf{preferences}>
</\textbf{tagger}>
    \end{alltt}
  \end{small}
  \caption{Example of a tagger definition file (comes from
  Figure~\ref{fg:exemple_desambiguador1}).}
  \label{fg:exemple_desambiguador2}
\end{figure}

\subsection{Some questions about the training of the part-of-speech
tagger} The training of the part-of-speech tagger can be made both in
a supervised manner, using manually disambiguated texts, and a
unsupervised manner, using ambiguous texts.

When the training is made with ambiguous texts (unsupervised), the
format of the required text can be automatically obtained from a plain
text corpus in the chosen language using the system's morphological
analyser; in this case, the format of the text forms will be like the
one defined in the figure~\ref{eq:formaanalizada2} (its description
can be found in page~\pageref{formaanalizada}). As the chart shows,
each analysed surface form can have more than one analysis (an
\emph{analysedform} can give as a result more than one
\emph{lexicalmultiform}).


\begin{equation}
\label{eq:formaanalizada2}
  \begin{array}{rcl} \mbox{analysedform}&\to&
\mbox{lexicalmultiform}\; [\; \mbox{lexicalmultiform} \; ]^* \\
\mbox{lexicalmultiform}&\to& \mbox{lexicalform}\;
[\;\mbox{lexicalform}\; ]^*\;\mbox{lemma-queue?} \\
\mbox{lexicalform}&\to&\mbox{lemma}\;\mbox{finetag}\\
\mbox{lemma-queue}&\to&\mbox{lemma}\\
\mbox{finetag}&\to&\mbox{morphsymbol}\;[\;\mbox{morphsymbol}\;]^* \\
  \end{array}
\end{equation}
\label{formaanalizada2}

For the supervised training we need manually disambiguated text. The
format of the text forms in this case will be like the format
delivered by the morphological analyser (see
Section~\ref{se:flujodatos}) except that, being the text already
disambiguated, a surface form can never produce more than one lexical
form, as shown in Figure~\ref{eq:formadesambiguada} (a
\emph{disambiguatedform} will consist always of a single
\emph{lexicalmultiform}).
\begin{equation}
\label{eq:formadesambiguada}
  \begin{array}{rcl}
  \mbox{disambiguatedform}&\to&\mbox{lexicalmultiform}\\
  \mbox{lexicalmultiform}&\to&\mbox{lexicalform}\;[\;\mbox{lexicalform}\;]^*\;\mbox{lemma-queue?}\\
  \mbox{lexicalform}&\to&\mbox{lemma}\;\mbox{finetag}\\
  \mbox{lemma-queue}&\to&\mbox{lemma}\\
  \mbox{finetag}&\to&\mbox{morphsymbol}\;[\;\mbox{morphsymbol}\;]^* \\
  \end{array}
\end{equation}
 

Finally, we need also the dictionary of the involved language to train
the tagger. This dictionary is used to determine, in combination with
the tagset specification, the different ambiguity classes with which
the tagger will work.

Figure \ref{fig:dependencias} shows the dependency diagram for the
training and the use of the tagger.

\nota{Aquest esquema canviarà amb el nou tagger - Sergio}

\begin{figure}
\begin{center}
\includegraphics[width=15cm]{diagram}
\end{center}
\caption{Dependency diagram for the part-of-speech tagger.}
\label{fig:dependencias}
\end{figure}


\newpage

\section[Transfer pre-processing]{Auxiliary module: transfer
pre-processing module}
\label{se:pretransfer}
\subsection{Justification} The transfer pre-processing module
\texttt{pretransfer} is in charge of separating compound multiwords
(see page~\pageref{ss:multipalabras}) and shifting certain parts of
multiwords with inner inflection or \emph{split lemma} forms.  This
module processes the tagger output and generates an entry suitable for
the transfer module.  The processing performed by this module is
necessary for different reasons:

\begin{itemize}
\item So that the transfer module can process these units separately
in order to deal with, for example, the movement of clitic pronouns
when changing from enclitic to proclitic and vice versa.
\item So that the bilingual dictionary only has to store information
about the lemmas to be translated.  If the particles that make up a
multiword are included jointly in the bilingual dictionary, the
dictionary would have to store an entry for each of the different
combinations.  By separating compound multiwords and processing multiwords with
inner inflection, we can avoid having
entries including inflection variations in the bilingual dictionary.
\end{itemize}

\subsection{Behaviour and example}

The program replaces each \texttt{<j/>} in the dictionary, that is,
each \texttt{+} in the data stream, by a symbol for word end, a blank
and a symbol for word beginning.  Moreover, if the form is a multiword
with split lemma, the queue is moved to the position between the first
word of the multiword and its first grammatical symbol.

The task of generating an output which has the original order accepted
by the generator, is left to the rules of the transfer
module, which are also responsible for creating the compound
multiwords which may be required in the target language.  In general,
the generator works with the same multiwords as the morphological
analyser, and with the elements in the same order; that is the reason
why this task has to be done in the transfer module.

We show below the result of applying this process to the compound
multiword \textit{darlo} ("give it" in Spanish):

\begin{small}
\begin{alltt}
\$ pretransfer
^dar<vblex><inf>+lo<prn><enc><p3><m><sg>\$     \(\longleftarrow\) \textrm{input} 
^dar<vblex><inf>\$ ^lo<prn><enc><p3><m><sg>\$     \(\longleftarrow\) \textrm{output}
\end{alltt}
\end{small}

As can be seen, it consists only in dividing the lexical forms of a
compound multiword into individual lexical forms.

When the input is a multiword with split lemma, the process is as
shown in the following example for the Spanish multiword
\textit{echarte de menos} ("to miss you"):

\begin{small}
\begin{alltt} 
\$ pretransfer
^echar<vblex><inf>+te<prn><enc><p2><m><sg># de menos\$ 
^echar# de menos<vblex><inf>\$ ^te<prn><enc><p2><m><sg>\$
\end{alltt}
\end{small}

Here, besides dividing into lexical forms, the module moves the
invariable lemma queue into the mentioned position.  As you can see,
semantic units are maintained after the movement of the invariable
queue, since we can consider \textit{echar de menos} a verbal unit
with own meaning.




\section{Lexical selection module}
\label{se:seleccio_lex}


\subsection{Introduction}


When the Apertium system is used to translate between less related
languages than the ones dealt with in the first stages of the engine,
the question of lexical selection becomes significant, because there
are more cases, and more critical, in which a source language word can
have more than one different translation in the target language. For
this reason we created a new module, the lexical selection module,
which deals with this problem.

Before going into its characteristics, we will see how the problems of
\emph{multiple equivalence} (the fact of existing more than one
possible translation in target language for a source language lexical
form) are tackled in Apertium in two ways.

On the one hand, we have the situation where there is no big
difference in meaning between the multiple equivalents in the target
language, and the fact of choosing one or the other can not lead to
any translation error. We could say that between these equivalents
there is a synonymy or quasi-synonymy relation. In such a case, the
linguist chooses one of the lemmas as a translation (generally the
most frequent or usual), and adds a direction restriction to the other
lemmas (with the attributes \texttt{LR} or \texttt{RL}) so that they
are translated in the opposite direction but not in the direction
where there are multiple equivalents.


On the other hand, we have the case where there is a clear difference
in meaning between the multiple equivalents, which can lead to
translation errors if the inappropriate lemma is chosen. These are the
cases dealt with the new lexical selection module. The linguist has to
encode entries with the attributes \texttt{slr} or \texttt{srl}
described in the next section, thus identifying the different
translation options; then, the lexical selection module, by means of
statistical methods, chooses the translation which is most suitable in
a given context.



Sometimes it is not easy to decide whether a multiple equivalence
situation should be solved in one way or the other. For example, if
there is difference in the meaning of two or more lemmas in the target
language, but we think that the lexical selection module will not be
capable of choosing the right translation by means of the context, we
will follow the first method: choose a fixed translation (the most
general, the most suitable in the maximum number of situations) and
add a direction restriction to the rest of translations.  In the other
cases, we will encode the entries so that the decision is left to the
lexical selection module.


When we use an Apertium system without lexical selection module, the
only way to add entries with different possible translations is the
first one, that is, choosing an only translation and marking the other
equivalences with a direction restriction.  In the event that we use
bilingual dictionaries with multiple translations, encoded with the
attributes \texttt{slr} or \texttt{srl}, in a system that does not
have any lexical selection module, a style sheet will
convert these entries designed for a lexical selection module into
entries with direction restrictions \texttt{LR} or \texttt{RL}, so
that one of the multiple equivalents (the one chosen as default entry
by the linguist) becomes the fixed translation of the source language
lemma.



As examples of bilingual equivalencies that should have a direction
restriction, we can give the translation pairs \texttt{ca-es}
\emph{encara -- aún/todavía} ("still") and \emph{sobtat --
súbito/repentino} ("sudden"), the first one of which could be encoded
like this:
\begin{alltt}
\begin{small}

<e r="LR">
   <p>
      <l>aún<s n="adv"/></l>
      <r>encara<s n="adv"/></r>
   </p>
</e>
<e>
    <p>
      <l>todavía<s n="adv"/></l>
      <r>encara<s n="adv"/></r>
    </p>
</e>
\end{small}
\end{alltt}

As examples of the second case (multiple equivalents with big
difference in meaning) we have the pairs \texttt{es-ca} \emph{hoja --
full/fulla} ("sheet/leaf") and \emph{muñeca -- nina/canell}
("doll/wrist"), as well as the \texttt{en-ca} examples shown in page
\pageref{entrades_lextor}, where it is described how to specify these
multiple equivalents in the bilingual dictionary.




\begin{figure} {\footnotesize \setlength{\tabcolsep}{0.5mm}
\begin{center}
\begin{tabular}{ccccccccc} \\
\parbox{0.95cm}{source language text} \\ $\downarrow$ \\
\framebox{\parbox{1.0cm}{de-for\-matter}} $\rightarrow$ &
\framebox{\parbox{0.6cm}{morph. anal.}}  $\rightarrow$ &
\framebox{\parbox{1.0cm}{POS tagger}} $\rightarrow$ &
\framebox{\parbox{0.6cm}{lex. select.}} $\rightarrow$ &
\framebox{\parbox{0.85cm}{struct. transf.}} $\rightarrow$ &
\framebox{\parbox{0.6cm}{morph. gen.}}  $\rightarrow$ &
\framebox{\parbox{1.2cm}{post\-generator}} $\rightarrow$ &
\framebox{\parbox{1.0cm}{re-for\-matter}} \\ & & & & $\updownarrow$ &
& & $\downarrow$ \\ & & & & \framebox{\parbox{0.8cm}{lex. transf.}} &
& &
\parbox{0.95cm}{target language text} \\
\end{tabular}
\end{center} }
\caption{The nine modules that build the assembly line in the version
  2 of the machine translation system Apertium.}
\label{fig:moduls}
\end{figure}

Figure~\ref{fig:moduls} shows the new assembly line of the version 2
of Apertium.\footnote{This figure substitutes the figure
\ref{fg:modules} in page \pageref{pg:modules} which represents the
version 1 of Apertium.} \nota{MG: caldria canviar la figura de la
pàgina 6 per aquesta d'aquí?} The module in charge of the lexical
selection (lexical selector) runs after the part-of-speech tagger and
before the structural transfer module; therefore, this new module
works only with source language information.


Section~\ref{se:preprocessament} next describes the pre-processing
that must be done on a bilingual dictionary  containing more than
one translation per entry (whether the system uses a
lexical selector or not), and Section~\ref{se:lextor} describes
how the lexical selector works and how it has to be trained.


 
\subsection{Pre-processing of the bilingual dictionaries
}\label{se:preprocessament}

Bilingual dictionaries have been modified to allow the specification
of more than one translation per entry (refer to Section
\ref{dic_lextor} to learn how to write such dictionary entries); this
fact makes it necessary to pre-process these dictionaries, since the
Apertium engine works with compiled dictionaries in which there is
only one possible translation for each word.

The pre-processing of dictionaries is done automatically during
compilation, therefore the final user does not need to perform any
specific action.


\subsubsection{Pre-processing without lexical selection module}

When bilingual dictionaries with multiple equivalents are used in a
system where there is no lexical selection module, the pre-processing
is done by the application of the style sheet
\texttt{translate-to\--de\-fault\--e\-qui\-va\-lent.xsl}.  This style
sheet turns dictionaries with multiple translations per entry into
dictionaries with only one translation per entry; to do this, it
chooses as translation the entry marked as default, and adds a
direction restriction (\texttt{LR} or \texttt{RL} as applicable) to
the other entries, so that they are only translated in the translation
direction where there is no equivalent multiplicity.  The style sheet
is called from the \texttt{Makefile}.


To put an example, the result of applying the style sheet on the first
three entries shown in page \pageref{entrades_lextor} is the
following:

\begin{alltt}
\begin{small}
<e>
   <p>
      <l>flat<s n="n"/></l>
      <r>pis<s n="n"/><s n="m"/></r>
   </p>
</e>

<e r="LR">
   <p>
      <l>floor<s n="n"/></l>
      <r>pis<s n="n"/><s n="m"/></r>
   </p>
</e>

<e r="RL">
   <p>
      <l>floor<s n="n"/></l>
      <r>terra<s n="n"/><s n="m"/></r>
   </p>
</e>
\end{small}
\end{alltt}

\subsubsection{Preprocessing with lexical selection module}

If the Apertium system works with a lexical selection module, the
bilingual dictionary must be pre-processed in order to obtain:
\begin{itemize}
\item a monolingual dictionary that, for each source language word
(for example \emph{look}) delivers all the possible translation marks
or equivalents (\texttt{look\_\_mirar D} and
\texttt{look\_\_semblar}); this dictionary will be used by the lexical
selection module; and

\item a new bilingual dictionary that, given a word with the lexical
selection already done (for example \texttt{look\_\_semblar}) delivers
the translation (\emph{semblar}); this will be the bilingual
dictionary to be used in the lexical transfer.

\end{itemize}


This pre-processing is automatically done by means of the following
software during dictionary compilation:
\begin{itemize}
\item \texttt{apertium-gen-lextormono}, that receives three
parameters:
  \begin{itemize}
  \item the translation direction for which you want to generate the
  monolingual dictionary used in the lexical selection; \texttt{lr}
  for the translation left to right, and \texttt{rl} for the
  translation right to left;
  \item the monolingual dictionary to be pre-processed; and
  \item the file where the output monolingual dictionary has to be
  written.
  \end{itemize}

\item \texttt{apertium-gen-lextorbil}, that receives three parameters:
  \begin{itemize}
  \item the translation direction (\texttt{lr} or \texttt{rl}) for
    which you want to generate the bilingual dictionary to be used by
    the lexical transfer module;
  \item the bilingual dictionary to be pre-processed; and
  \item the file where the output bilingual dictionary has to be
  written.
  \end{itemize}
\end{itemize}

\subsection{Execution of the lexical selection
module}\label{se:lextor}

The module responsible for the lexical selection runs after the
part-of-speech tagger and before the structural transfer (see
Figure~\ref{fig:moduls} in page~\pageref{fig:moduls}); therefore, it
uses only information from the source language. However, during the
training of the module, target language information is also used.


\subsubsection{Training}\label{se:entrenament}

To train the lexical selection module, a corpus in the source language
and another one in the target language are required; they do not need
to be related. Both corpora must be pre-processed before the
training. This pre-processing, consisting in analysing the corpora and
performing the POS disambiguation, can be done  with
\texttt{apertium-prepro\-cess\--cor\-pus\--lex\-tor}.

The training of the module that performs the lexical selection
consists of the following tasks:\footnote{The training of the models
used for the lexical selection has been automated in all the packages
using it. Furthermore, all the software mentioned has its UNIX manual
page}



\begin{enumerate}
\item Obtain the list of words that will be ignored when performing
lexical selection (\emph{stopwords}). This list can be done manually
or using \texttt{apertium-gen-stopwords-lextor};
\item Obtain the list of (source language) words that have more than
one translation in the target language, using
\texttt{apertium-gen-wlist-lextor};
\item Translate to the target language all the words obtained in the
previous step, using \texttt{apertium-gen-wlist-lextor-translation};
\item Running \texttt{apertium-lextor --trainwrd} and using the target
language pre-processed corpus, train a word co-occurrence model for
the words obtained in the previous step;
\item Running \texttt{apertium-lextor --trainlch} and using the source
language pre-processed corpus, the dictionaries generated by the
programs mentioned in Section~\ref{se:preprocessament} and the word
co-occurrence models calculated in the previous step, train a
co-occurrence model for each of the translation marks of those words
that can have more than one translation in the target language.
\end{enumerate}

\subsubsection{Use}\label{se:us} 

The word co-occurrence models
calculated for each translation mark as described in the previous
section provide the information required to perform lexical selection
with information from the context.

Lexical selection is done by \texttt{apertium-lextor --lextor}; the
formats used to communicate with the rest of the modules of the
translation engine are:

\begin{description}
\item [Input:] text in the same format as the input for the structural
transfer module, that is, text analysed and disambiguated, with
invariable queues of multiwords moved before morphological tags.
\item [Output:] text in the same format, but with the translation mark
to be used when executing lexical transfer.
\end{description}


The following example illustrates the input/output formats used by the
lexical selector (we have assumed in the example that only the English
verb \emph{get} has more than one translation equivalent in the
dictionaries):
\begin{itemize}
\item Source language text (English): \emph{To get to the city centre}
\item Lexical selector input: \verb!^To<pr>$!
\verb!^get<vblex><inf>$! \verb!^to<pr>$! \verb!^the<det><def><sp>$!
\verb!^city<n><sg>$! \verb!^centre<n><sg>$!
\item Translation marks in the en-ca bilingual dictionary for the verb
\emph{get}: \texttt{rebre}, \texttt{agafar}, \texttt{arribar},
\texttt{aconseguir D}
\item Lexical selector output: \verb!^To<pr>$!
\verb!^get__arribar<vblex><inf>$! \verb!^to<pr>$!
\verb!^the<det><def><sp>$!  \verb!^city<n><sg>$!
\verb!^centre<n><sg>$!
\end{itemize}


\newpage
\section{Structural transfer module}
\label{ss:transfer}


\nota{Faena per fer (mlf):
  \begin{itemize} 
  \item Hi ha bastants vacil·lacions en la terminologia usada per a
  referir-se a conceptes i en els noms usats per als programes.
\item He intentat substituir en cada cas l'expressió \emph{per
defecte} per una altra més adequada; però caldrà distingir en quin cas
ens trobem en cada cas.
  \end{itemize}}

\subsection{Introduction}

In 2007, Apertium incorporated a more advanced structural transfer system than 
the one used until then; it became necessary when we started developing
 machine translators for less related language pairs in
comparison with the ones dealt with before, such as 
the \emph{English}--\emph{Catalan} translator.

This enhanced transfer system is made of three modules, the first one
of which can be used in isolation in order to run a
\textbf{shallow-transfer} system (which is the transfer system used so
far for related language pairs such as \emph{Spanish}--\emph{Catalan} or
\emph{Spanish}--\emph{Galician}).  When the system is used for less
related language pairs and, therefore, an 
\textbf{advanced transfer} becomes necessary, the three transfer modules will be executed.

The two transfer systems differ in the number of passes over the input
text.  The shallow-transfer system makes structural transformations
with a single pass of the rules, which detect sequences or
\emph{patterns} of lexical forms and perform on them the required
verifications and changes. On the other hand, the advanced transfer
system works with a new architecture that allows to detect
\emph{patterns of patterns} of lexical forms with three passes, done
by its three modules.

We describe next the characteristics of the structural transfer system.  Section
\ref{functransfer} describes the shallow-transfer system and Section
\ref{apertium2}, the advanced transfer system.  The description of the
shallow-transfer system is also applicable to the first module of the
advanced transfer system, with the differences mentioned in that
section.  Section \ref{formatotransfer} describes the format used to
create rules in both systems. In Section \ref{noutransfer} there is a
detailed description of how the three modules of the advanced transfer
system work, and finally, Section \ref{ss:preproceso_transfer}
describes the pre-processing required by the modules.


\subsection{Shallow-transfer}
\label{functransfer}


In this system, only the first of the three modules that compose the
advanced transfer system is used. This module is called
\emph{chunker}.

The design of the language and the compiler used to generate the
structural transfer module is largely based upon the MorphTrans
language described in \cite{garridoalenda01p} and used by the MT
systems \textsf{interNOSTRUM}
\cite{canals01b,garridoalenda01p,garrido99j} (Spanish--Catalan) and
\textsf{Traductor Universia} \cite{garrido03p, gilabert03j}
(Spanish--Portuguese), developed by the Transducens group at the
Universitat d'Alacant.


The transfer process is organized around patterns representing
fixed-length sequences of source language lexical forms (SLLFs) (see
page~\pageref{pg:FSFL} for a description of lexical form (LF)); a
sequence follows a certain pattern if it contains the sequence of lexical forms
of the pattern.  Patterns do not need to be constituents or
phrases in the syntactic sense: they are mere concatenations of
lexical forms that may need a conjoint processing additional to the
simple word-for-word translation, due to the grammatical divergences
between SL and TL (gender and number changes, reorderings,
prepositional changes, etc). The catalogue of patterns defined for a
certain language is selected with a view to covering the most common structural
transformations.  When source language and target language
are syntactically similar, as is the case between Spanish, Catalan and
Galician, simple rules based on sequences of lexical categories
achieve a reasonable translation quality.

The transfer module detects, in the SL, sequences of lexical forms
that match one of the patterns previously defined in the pattern
catalogue, and processes them applying the corresponding structural
transfer rule, doing at the same time the lexical transfer by reading
the bilingual dictionary.

The \emph{pattern detection} phase occurs as follows: if the transfer
module starts to process the $i$-th SLLF of the text, $l_i$, it tries
to match the sequence of SLLFs $l_i, l_{i+1}, \ldots$ with all of the
patterns in its pattern catalogue: the longest matching pattern is
chosen, the matching sequence is processed (see below), and processing
continues at SLLF $l_{i+k}$, where $k$ is the length of the pattern
just processed. If no pattern matches the sequence starting at SLLF
$l_i$, it is translated as an isolated word an processing restarts at
SLLF $l_{i+1}$ (when no patterns are applicable, the system resorts to
word-for-word translation). Note that each SLLF is processed only
once: patterns do not overlap; hence, processing occurs left to right
and in distinct "chunks".


In the \emph{pattern processing } phase, the system takes the detected
sequence of SLLFs and builds (using a program to consult the bilingual
dictionary) a sequence of TL lexical forms (TLLFs) obtained after the
application of the operations described in the rule associated to the
detected pattern (reordering, addition, replacement or deleting of
words, inflection changes, etc.). The information that does not change
is automatically copied from SL to TL. The resulting data, that is,
the lemmas with their associated morphological tags, are sent to the
generator, which creates the inflected forms.



For instance, the Spanish sequence \emph{una señal inequívoca} ("an
unmistakable signal"), that would go from the tagger to the transfer
module in the following format~\footnote{The example has been
presented in a way that it does not contain superblanks with format
information, so that the linguistic side of the transformation is
clearer. See Chapter \ref{se:flujodatos}.}:\\

\begin{alltt}
\begin{small} 
\textasciicircum\textbf{uno}<det><ind><f><sg>\$
\textasciicircum\textbf{señal}<n><f><sg>\$
\textasciicircum\textbf{inequívoco}<adj><f><sg>\$
\end{small}
\end{alltt}


\noindent{would be detected as a pattern by a rule for
determiner--noun--adjective.} The transfer module would consult the
bilingual dictionary to get the Catalan equivalents and, as it would
detect a gender change in the word \emph{señal} (its Catalan
translation \emph{senyal} is masculine), it would propagate this
change to the determiner and the adjective to deliver the output
sequence:\\

\begin{alltt}
\begin{small} 
\textasciicircum\textbf{un}<det><ind><m><sg>\$
\textasciicircum\textbf{senyal}<n><m><sg>\$
\textasciicircum\textbf{inequívoc}<adj><m><sg>\$
\end{small}
\end{alltt}

\noindent{which the generation module would turn into the Catalan
inflected sequence: \emph{un senyal inequívoc}.}

The task of most rules is to ensure gender and number agreement in
simple noun phrases (determi\-ner--noun, determiner--noun--adjective,
determiner--adjective--noun, determiner--adjective, etc.), provided
that there is agreement between the SLLFs of the detected
pattern. These rules are required either because the noun changes its
gender or number between SL and TL (as in the previous example) or
because gender or number in the TL have to be determined due to the
fact that it was ambiguous in SL for some of the words (for example,
the Catalan determiner \emph{cap} can be translated into Spanish as
\emph{ningún} (masc.) or \emph{ninguna} (fem.) depending on the
accompanying noun: \emph{cap cotxe} (\texttt{ca}) $\rightarrow$
\emph{ningún coche} (\texttt{es}) and \emph{cap casa} (\texttt{ca})
$\rightarrow$ \emph{ninguna casa} (\texttt{es})). Furthermore, there
other rules defined to solve frequent transfer problems between
Spanish, Catalan and Galician, such as, among others:

\begin{itemize}
  

\item rules to change prepositions in certain constructions: \emph{in
Barcelona} (\texttt{es}) $\rightarrow$ \emph{a Barcelona}
(\texttt{ca}); \emph{consiste en hacer} (\texttt{es}) $\rightarrow$
\emph{consisteix a fer} (\texttt{ca});

\item rules to add/remove the preposition \emph{a} in certain Galician
modal constructions with the verbs \emph{ir} and \emph{vir}: \emph{vai
comprar} (\texttt{gl}) $\rightarrow$ \emph{va a comprar}
(\texttt{es});

\item rules for articles before proper nouns: \emph{ve la Marta}
  (\texttt{ca}) $\rightarrow$ \emph{viene Marta} (\texttt{es});

\item lexical rules, for instance, to decide the correct translation
of the adverb \emph{molt} (\texttt{ca}) into Spanish (\emph{muy,
mucho}) or of the adjective \emph{primeiro} (\texttt{gl}) or
\emph{primer} (\texttt{ca}) into Spanish (\emph{primer, primero});

\item rules to displace atonic or clitic pronouns, whose position in
Galician is different to that in Spanish (proclitic in Galician and
enclitic in Spanish or vice versa): \emph{envioume} (\texttt{gl})
$\rightarrow$ \emph{me envió} (\texttt{es}); \emph{para nos dicir}
(\texttt{gl}) $\rightarrow$ \emph{para decirnos} (\texttt{es}).

\end{itemize}



\emph{Multiwords} (its different types are described in
page~\pageref{ss:multipalabras}) are processed in a special way in
this module:

\begin{itemize}
\item \emph{Multiwords without inflection}, made of only one lexical
form, do not need any special processing, since they are treated like
other LFs.
\item In the case of \emph{compound multiwords}, that is, multiwords
formed by more than one \emph{lexical form}, each one with its own
grammatical symbols and joined to each other with the element
\texttt{<j>} in the dictionary entry (which corresponds to the symbol
'+' in the data stream), the auxiliary module \texttt{pretransfer}
(see \ref{se:pretransfer}), located before this module, separates the
different lexical forms so that they reach the transfer module as
independent LFs. If we want to join them again so that they reach the
generator as multiwords (as is the case of enclitic pronouns in our
system), it has to be done by means of a transfer rule, using the
\texttt{<\textbf{mlu}>} element (described later, in section
\ref{ss:mlu}). In page~\pageref{regla_verbo2} you can find an example
of a rule for joining enclitic pronouns to the verb.
\item As for \emph{multiwords with inner inflection}, the
\texttt{pre\-trans\-fer} module moves the lemma queue (the invariable
part) to place it after the lemma head (the inflective form), thus
making possible to find the multiword in the bilingual
dictionary. This kind of multiwords must be processed by a structural
transfer rule which replaces the lemma queue in its proper
position. This is done by using, in the output of the rule, the attributes
\texttt{lemh} ``lemma head'' and \texttt{lemq} ``lemma queue'') of the
\texttt{<\textbf{clip}>} element. See page~\pageref{ss:lu} for a more
detailed description of the use of this element, and page
\pageref{regla_verbo1} to see two rules where these attributes are
used.
\end{itemize}


\subsection{Advanced transfer}
\label{apertium2}

The shallow-transfer architecture described in the previous section is
based, as we have seen, in the automatic handling of word
co-occurrence patterns by means of rules defined by the user. This
model considers two levels from the point of view of the nature of
data: a basic level we call \textit{lexical level}, which handles
words and the tasks of consulting and changing its characteristics
(lemma and tags), besides translating individual lemmas by asking the
bilingual dictionary; and another level we call \textit{word pattern
level}, which is in charge of doing, when applicable, reorderings of
the words that build these patterns, as well as changes in the
properties of words that depend on the specific pattern that has been
detected. All this process of detection and manipulation of words and
patterns is carried out in a single pass.

In contrast, the new advanced transfer architecture is defined as a
transfer system in three levels and three passes. The first two
levels, lexical and pattern level, are the same ones of the
shallow-transfer system. The new added level is a level of
\emph{patterns of patterns} of words. The aim of this new processing
level is to allow the handling and interaction of patterns of words in
a similar way as words are handled in the patterns of the shallow
system. With this new structure we intend to achieve a more
appropriate handling of all transformations that may be required when
translating from one language to another. We want to emphasize that
the definition of word patterns in the shallow-transfer system does
not need to be the same as the definition of word patterns in the
advanced system: we pretend that, in the latter, patterns have a
\textit{spirit} of phrases that does not exist in the previous
system. Therefore we will use the term \textit{chunk} to refer to word
sequences in the advanced transfer system.

The advanced transfer system is organized in three passes. According
to the Apertium processing mode, these three passes are carried out by
three different modules (programs):

\begin{itemize}
\item \texttt{chunker}: identifies chunks, translates word for word,
and carries out required reorderings and morphosyntactic data
propagation inside the chunk (for example, to maintain
agreement). Besides, it creates the chunks that will be processed by
the next module.  The \texttt{chunker} has the option of running as a
single module in a shallow-transfer system.  This is controlled by an
attribute in the \texttt{<transfer>} element.


\item \texttt{interchunk}: this module receives the chunks generated
by the \texttt{chunker} and is able to reorder them, modify the
``syntactic information'' associated to each chunk and, finally,
output the chunks in the new order and with the new properties,
creating new chunks if needed.
\item \texttt{postchunk}: it receives the chunks modified by the
interchunk and carries out final tasks concerning modification of the
words contained in each chunk and printing of the text contained in
chunks in the format accepted by the generator.
\end{itemize}


In the following lines we specify the format of the chunks that
circulate between the modules of the transfer system (Section
\ref{sec:format}) and the letter case handling in chunks (Section
\ref{ss:majuscules}), which is different from case handling of
individual lexical forms in a shallow-transfer system.


The following section, \ref{formatotransfer}, describes the format of
transfer rules, which is the same for the three modules and the two
transfer modes, with little differences.  Finally, after this
description, in \ref{noutransfer} you will find a more detailed
explanation of the three modules that make up an advanced transfer
system.




\subsubsection{Chunk format}
\label{sec:format}


Communication between \texttt{chunker} and \texttt{interchunk}, as
well as between \texttt{interchunk} and \texttt{postchunk}, is
performed through sequences of chunks. We define $C$ as a
\emph{sequence of chunks}, that has the form:
$$
C=b_{0}c_{1}b_{1}c_{2}b_{2} \ldots b_{k-1}c_{k}b_{k}
$$

where each $b_i$ is a \textit{superblank}, and each $c$ is a
\emph{chunk}. A chunk $c$ is defined as a string
\verb!^!$F$\verb!{!$W$\verb!}$! that contains the following
information:

\begin{itemize}
\item $F$ is the \emph{lexical pseudoform}\nota{help: pseudoforma
lèxica = lexical pseudoform or pseudolexical form}; it is a string
that has the form $fE$, where $f$ is the \textit{pseudolemma} of the
chunk, and $E=e_{1}e_{2} \ldots$ is a sequence of grammatical symbols
called \emph{chunk symbols}. Changing these symbols will cause the
changing of the morphological information of words in the chunk, if
this information is linked to these parameters.
\item $W=b_{0}w_{1}b_{1}w_{2}b_{2} \ldots w_{k}b_{k}$ is the sequence
of words $w_i$ sent by the chunker with the intermediate
\textit{superblanks} $b_i$. These words have the same format in both
transfer systems, that is, an individual word
$w_i=$\verb!^!$l_{i}E_{i}$\verb!$!  contains lemma $l_i$ and
  grammatical symbols $E_i$, some of which can be \emph{references or links
  to the symbols} of the chunk and are identified with natural numbers
  \texttt{<1>}, \texttt{<2>}, \texttt{<3>}, etc. These references to
  symbols correspond, in the specified order, to the symbols of $E$.
\end{itemize}

The following is a use example of the described format, with the text
\emph{el gat} ("the cat"):

\begin{small}
\begin{alltt} 
\verb!^!det_nom<SN><m><pl>\verb!{^!el<det><def><2><3>$[
<a href="http://www.ua.es">]^gat<n><2><3>$\verb!}$![</a>]
\end{alltt}
\end{small}

The characters \verb!{! and \verb!}!, if present in the original text,
must be escaped with a backslash \verb!\!.

\subsubsection{Letter case handling}
\label{ss:majuscules}

For each chunk, the case of words is determined by the case of the
pseudolemma of the chunk, taking into account the following rules:

\begin{itemize}

\item When all the letters of the pseudolemma are in lower case: the
case state of words is not modified.
\item When the first letter of the pseudolemma is in upper case and
the rest are in lower case: in the module \texttt{postchunk}, when
words are printed, the letter that is the first of the chunk after all
the possible word reorderings will be put in upper case \nota{MG: and
the rest will be put in lower case except proper nouns? is this
correct?}.
 \item When all the letters of the pseudolemma are in upper case: all
 the words will remain upper case.
\end{itemize}


It is required that the words in the chunk are not capitalized unless
they are proper nouns, so as to avoid the postchunk module having to
look for the word that has to lose capitalization, if this is the
case\nota{MG: I am not sure I understand this}. This task belongs to
the \texttt{chunker} module and is done with a macro or similar
mechanism.


%\settocdepth{subsection}
\subsection{Format specification for structural transfer rules}
\label{formatotransfer}


This section describes the format in which structural transfer rules
are written. In the Appendix, in sections~\ref{ss:dtdtransfer},
\ref{ss:dtdinterchunk} and \ref{ss:dtdpostchunk}, there is the formal
definition (DTD).

Structural transfer rules files have two well-differentiated parts:
one for the declaration of the elements to be used in rules, and
another one for the rules themselves.\\


In the \textbf{declaration} part we find:

\begin{itemize}

\item A series of declarations of \emph{lexical categories}, which
specify those lexical forms that will be treated as a particular
category and will be detected by patterns.  The linguist may include any data about the lexical form
to define a category; categories can be very generic (i.e. all the
nouns) or very specific (i.e. only those determiners that are
demonstrative feminine plural).
\item A series of declarations of the \emph{attributes} we want to
detect in lexical forms (like \emph{gender}, \emph{number},
\emph{person} or \emph{tense}), to perform with them the required
transformation operations and send the resulting data in the output of
the rules. The declaration of an attribute contains the name of the
attribute and the possible values it can take in a lexical form (in
general they correspond to the morphological attributes that
characterize the form): for example, the attribute \emph{number} can
take the values \emph{singular}, \emph{plural}, \emph{singular-plural}
(for invariable lexical forms, like \emph{crisis} in Spanish) and
\emph{number to be determined} (for TL lexical forms with different
forms for \emph{singular}--\emph{plural}, but whose number can not be
determined in the translation due to the fact that the SL lexical form
is invariable in number, see explanation in page \pageref{pg:GD}). If
inside the rule, outside of the pattern, one wishes to refer to any of
the lexical categories defined in the previous point (to perform tests
or actions on them), it will be also necessary to define attributes
for them.

\item A series of declarations of \emph{global variables}, which are
used to transfer values of active attributes inside a rule, or from
one rule to the ones applied subsequently.

\item A section for the \textit{definition of string lists}, generally
lists of lemmas, which will be used to make searches on them for a certain value
to perform a specific transformation.

\item A series of declarations of \emph{macro-instructions};
macro-instructions contain sequences of frequently used instructions,
and can be included in different rules (for example, a
macro-instruction to ensure gender and number agreement between two
lexical forms of a pattern).

\end{itemize}

In the \textbf{structural transfer rules} we find:

\begin{itemize}
\item The definition of the pattern that will be detected, specified
as a sequence of lexical categories as they have been defined in the
declaration part. It must be noted that, if a sequence of lexical
forms matches two different rules, firstly, the longest is chosen, and
secondly, for rules of the same length, the one defined before is
chosen.

\item The process part of the rules, where actions to be performed on
SLLF are specified, and the TL pattern is built.

\end{itemize} \nota{Assegurem-nos que totes les sigles estan
definides}

In the following pages we describe in detail the characteristics of
all the elements used in rules.


\subsubsection{Element \texttt{<transfer>}}

(\textit{Only in the chunker module})

This is the root element of the \texttt{chunker} module and contains
all the rest of the elements of the structural transfer rules file of
this module.

Its attribute \texttt{default} can take two values:
\begin{itemize}

\item \texttt{lu}: it means that it will run in shallow mode, that is,
as only transfer module in a shallow-transfer system and, therefore,
no special action will be done on words not detected by any pattern

\item \texttt{chunk}: it means that it will run in advanced mode and,
therefore, when a word is not recognized by any rule, a chunk will be
created to encapsulate it, so that it can be processed by the next
transfer modules of an advanced transfer system.

\end{itemize}

The default value is \texttt{lu}.

\subsubsection{Element \texttt{<interchunk>}}

(\textit{Only in interchunk})

This is the root element of the \texttt{interchunk} module and
contains all the rest of the elements of the structural transfer rules
file of this module.


\subsubsection{Element \texttt{<postchunk>}}


(\textit{Only in postchunk})

This is the root element of the \texttt{postchunk} module and contains
all the rest of the elements of the structural transfer rules file of
this module.



\subsubsection{Element for category definition section
\\\texttt{<section-def-cats>}} \nota{Atenció a l'ús polisèmic del mot
\emph{categoria} en el document}

This section contains the definition of the lexical categories that
will be used to create the patterns used in rules. Each definition is
made with a \texttt{<\textbf{def-cat}>}.



\subsubsection{Element for category definition \texttt{<def-cat>}}

Each category definition has a mandatory name \texttt{n}
(e.g. \texttt{det}, \texttt{adv}, \texttt{prep}, etc.) and a list of
categories (\texttt{<\textbf{cat-item}>}) that define it. The name of
the category can not contain accents.


\subsubsection{Element for category \texttt{<cat-item>}}


This element has two well-differentiated uses depending on the module
it is used in.

\paragraph{Use in chunker (shallow transfer and advanced transfer)}


This element defines the lexical categories that will be used in
patterns, that is, that the linguist wishes to detect in the source
text. These categories are defined by a subsequence of the fine tags
(see definition in page~\pageref{ss:introtagger}) that deliver both
the morphological analyser and the tagger\footnote{Please note that
throughout the different linguistic modules, different lexical
categorizations are used: in morphological dictionaries, lemmas are
accompanied by a fine tag (for instance, \texttt{\emph{<n><m><pl>}}
for plural masculine nouns); the POS tagger groups these fine tags in
more general tags (for instance, the category \texttt{NOUN} for all
the nouns), although its output is again the whole fine tag of each
LF; finally, in the transfer module, the fine tags of LFs are grouped
again in more general categories (although it is also possible to
define particularized categories) depending on the type of lexical
forms that one wants to detect in patterns.}.

Each \texttt{<\textbf{cat-item}>} element has a mandatory attribute
\texttt{tags} whose value is a sequence of grammatical symbols
separated by a dot; this sequence is a subsequence of the fine tag,
that is, of the sequence of grammatical symbols that defines every
possible lexical form delivered by the tagger.  According to this, a
category represents a certain set of lexical forms.  We must define as
many different categories as kinds of lexical forms we want to detect
in patterns. Thus, if we want to detect all the nouns to perform
certain actions on them, we will create a category defined with the
grammatical symbol \texttt{n}. On the other hand, if we want to detect
all the plural feminine nouns, we will have to define a category using
the symbols \texttt{n} \texttt{f} and \texttt{pl}.



When, for the set of lemmas we want to include in a category, a
grammatical symbol used to define the category is followed by other
grammatical symbols, the character \texttt{"*"} is used. For example,
\texttt{tags}=\texttt{"n.*"} covers all the lexical forms that contain
this symbol, such as the Spanish nouns \texttt{casa<n><f><pl>} or
\texttt{coche<n><m><sg>}. On the other hand, when after the used
symbol there can not be any other symbol, the asterisk is not
included: for example, \texttt{tags}=\texttt{"}\texttt{adv"} will
cover all adverbs, since in our system they are characterized with
only one grammatical symbol. The asterisk can also be used to signal
the existence of preceding symbols: \texttt{tags}=\texttt{"*.f.*"}
includes all feminine lexical forms, whichever category they
are. Furthermore, an optional attribute, \texttt{lemma}, can be used
to define lexical forms on the basis of its lemma (see Figure
\ref{fig:cat-item}).



\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{def-cat} \textsl{n}="nom"/> 
  <\textbf{cat-item} \textsl{tags}="n.*"/>
</\textbf{def-cat}>

<\textbf{def-cat} \textsl{n}="que"/> 
  <\textbf{cat-item} \textsl{lemma}="que" \textsl{tags}="cnjsub"/> 
  <\textbf{cat-item} \textsl{lemma}="que" \textsl{tags}="rel.an.mf.sp"/>
</\textbf{def-cat}>
\end{alltt}
\end{small}
\caption{Use of the \texttt{<\textbf{cat-item}>} element to define two
  categories, one for nouns without lemma specification (\emph{nom}),
  which includes all lexical forms whose first grammatical symbol is
  \emph{n}, and another one with associated lemma (\emph{que}), which
  has two subsequences of fine tags, to include the \emph{que}
  conjunction and the \emph{que} relative pronoun.}
\label{fig:cat-item}
\end{figure}


\paragraph{Use in interchunk}


It is used like in the \texttt{chunker} module, but here, instead of
being defined with the grammatical symbols of lexical forms, it is
defined with the symbols of the chunks delivered by the
\texttt{chunker}. For example, in the case that we want to define a
category to detect all the determined noun phrases, we will define it
with the symbols \texttt{NP} and \texttt{DET} if this is how we tagged
these chunks by means of the \texttt{<tag>} instructions contained in
the \texttt{<chunk>} element (see \ref{ss:chunker}). You can also use
the optional attribute \texttt{lemma} to refer to the
\emph{pseudolemma} of the chunk. So, its formal characteristics are
the same in the modules \texttt{chunker} and \texttt{interchunk}, with
the difference that in the former they are used to detect lexical
forms, and in the latter, to detect chunks.


\paragraph{Use in postchunk}

In this module, this element only has the mandatory attribute
\texttt{name}, which refers to the name of the chunk,

\nota{MG: abans deia 'al nom de la regla', comentari mlf: De la regla
o del patró?}  without tags, since in the \texttt{postchunk} module
only the pseudolemma (name of the chunk) is used for detection.  Case
is ignored in detection, because the pseudolemma is used to convey
information about the case of the chunk. (See Figure
\ref{fig:cat-item-postchunk}).

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{def-cat} \textsl{n}="det-nom"/> 
  <\textbf{cat-item} \textsl{name}="det-nom"/>
</\textbf{def-cat}>
\end{alltt}
\end{small}
\caption{Use of the \texttt{<\textbf{cat-item}>} element in the
postchunk to detect chunks of determiner-noun.}
\label{fig:cat-item-postchunk}
\end{figure}



\subsubsection{Element for category attribute definition section
\\\texttt{<section-def-attrs>}}


This section is to describe the attributes that will be extracted
from the categories detected by the pattern and that will be used in
the action part of the rules. Each attribute is defined by a
\texttt{<\textbf{def-attr}>} tag.

\nota{De vegades les etiquetes aprareixen en el text en negretes i de
vegades sense negretes. Decidim-nos per una tipografia i usem-la en
tot el document.}


\subsubsection{Element for category attribute definition
\\\texttt{<def-attr>}}

Each \texttt{<\textbf{def-attr}>} defines an attribute regarding
morphological information (both inflection information --gender,
number, person, etc.--, and categorial --verb, adjective, etc--) by
specifying a list of category attribute
(\texttt{<\textbf{attr-item}>}) elements, and has a mandatory unique
name \texttt{n}. Therefore, an attribute is defined on the basis of
the grammatical symbols that can be found in a given lexical
form. Each attribute extracts, from the lexical forms of the pattern,
the symbols that these contain among the set of possible values
defined.

\subsubsection{Element for category attribute \texttt{<attr-item>}}

Each category attribute element represents one of the possible values
the attribute can take. For example, the attribute for number
\texttt{nbr} can take the values singular \texttt{sg}, plural
\texttt{pl}, singular--plural \texttt{sp} and number to be determined
\texttt{ND}. These values are a subsequence of the morphological tags
that characterize each lexical form, and are specified in the
\texttt{tags} attribute of the element, separated by a dot if there is
more than one. In Figure \ref{fig:attr-item} you can find an example
for the attributes for \emph{number} and \emph{noun}.  \nota{Potser
s'hauria d'explicar per què s'ha triat el nom \emph{a\_nom} en la
figura}

Compare the definition of the attribute for number in this figure
(with all possible values and without asterisks) with the definition
of the category for noun in Figure \ref{fig:cat-item}.



\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{def-attr} \textsl{n}="nbr"/>
  <\textbf{attr-item} \textsl{tags}="sg"/>
  <\textbf{attr-item} \textsl{tags}="pl"/>
  <\textbf{attr-item} \textsl{tags}="sp"/>
  <\textbf{attr-item} \textsl{tags}="ND"/>
</\textbf{def-attr}>

<\textbf{def-attr} \textsl{n}="a_nom"/>
  <\textbf{attr-item} \textsl{tags}="n"/>
  <\textbf{attr-item} \textsl{tags}="n.acr"/>
</\textbf{def-attr}>

\end{alltt}
\end{small}
\caption{Definition of the category attribute \texttt{nbr} for
  \emph{number}, which can take the values \emph{singular},
  \emph{plural}, \emph{singular-plural} or
 \emph{number to be determined}, and the category attribute
\texttt{a\_nom} for \emph{noun}, which can take the values of the
symbols \emph{n} or \emph{n acr}.}
\label{fig:attr-item}
\end{figure}


\subsubsection{Element for variable definition section
\\\texttt{<section-def-vars>}}

In this section, \texttt{<\textbf{def-var}>} tags are used to define
global string variables, that will be used to transfer information
inside the rule and from one rule to another one (for example, to
transmit information on gender or number between two patterns)


\nota{Que quede clar que aquesta transferència d'una regla a altra es
fa només d'una aplicació d'una regla a l'aplicació d'altra regla en un
moment posterior, o d'esquerra a dreta}

\subsubsection{Element for variable definition \texttt{<def-var>}}
\label{ss:defvar} The definition of a global string variable has a
mandatory unique name \texttt{n} that will be used to refer to it
inside a rule.  Variables contain strings that describe state
information, such as the existence of agreement between two elements,
the detection of a question mark in SL that should be deleted in TL,
etc.


\subsubsection{Element for string lists definition section
\\\texttt{<section-def-lists>}} In this section, lists are defined
(with \texttt{<\textbf{def-list}>} tags) that will be used to do
string searches.  These lists can be used to group word lemmas that
have a common feature (i.e. verbs expressing movement, adjectives
expressing emotions, etc.).  This section is optional.

\subsubsection{Element for string lists definition
\texttt{<def-list>}} This element is used to name the string list,
with the attribute \texttt{n}, and to encapsulate the list defined by
one or more \texttt{<\textbf{list-item}>} elements. An example of its
use can be found in Figure \ref{fig:deflist}.

\subsubsection{Element for string list item \texttt{<list-item>}} It
 defines, with the value of the attribute \texttt{v}, the specific
 string that is included in the definition of the list.  An example of
 its use can be found in Figure \ref{fig:deflist}.




\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{def-list} n="verbos_est">
  <\textbf{list-item} v="actuar"/>
  <\textbf{list-item} v="buscar"/>
  <\textbf{list-item} v="estudiar"/>
  <\textbf{list-item} v="existir"/>
  <\textbf{list-item} v="ingressar"/>
  <\textbf{list-item} v="introduir"/>
  <\textbf{list-item} v="penetrar"/>
  <\textbf{list-item} v="publicar"/>
  <\textbf{list-item} v="treballar"/>
  <\textbf{list-item} v="viure"/>
<\textbf{/def-list}>
\end{alltt}
\end{small}
\caption{Definition of a list of Catalan lemmas. These lemmas are used
in the rule in Figure \ref{fig:in}.}
\label{fig:deflist}
\end{figure}


\subsubsection{Element for macro-instruction definition section
\\\texttt{<section-def-macros>}}

This section is for the definition of macro-instructions that contain
pieces of code used frequently in the action part of the rules.

\subsubsection{Element for macro-instruction definition
\texttt{<def-macro>}}

Each macro-instruction definition has a mandatory name (the value of
the attribute \texttt{n}), the number of arguments it receives
(attribute \texttt{npar}) and a body with instructions.


\subsubsection{Element for rules section \texttt{<section-rules>}}

This section contains the structural transfer rules, each one in a
\texttt{<\textbf{rule}>} element.

\subsubsection{Element for rule \texttt{<rule>}}

Each rule has a pattern (\texttt{<\textbf{pattern}>}) and the
associated action (\texttt{<\textbf{action}>}) performed when the
pattern is matched.

The rule can have an optional attribute \texttt{comment} with a
comment on, usually, the function of the rule.

\subsubsection{Element for pattern \texttt{<pattern>}}

A pattern is specified using pattern items
(\texttt{<\textbf{pattern-\\item}>}), each one of which corresponds to
a lexical form in the matched pattern, in order of appearance.

\subsubsection{Element for pattern constituent
\texttt{<pattern-item>}}

Each pattern item specifies, in the attribute with mandatory name
\texttt{n}, which kind of lexical form is to be matched.  To do that,
one has to use the categories defined in
\texttt{<\textbf{section-def-cats}>} (see in Figure \ref{fig:regla}
the definition of a pattern for determiner--noun ).


\subsubsection{Element for action \texttt{<action>}}

This element contains the ``instructions'' that have to be executed to
process as desired each matched pattern.

The processing part for matched patterns is a block of zero or more
instructions of the kind: \texttt{<\textbf{choose}>} (conditional
processing), \texttt{<\textbf{let}>} (value assignment),
\texttt{<\textbf{out}>} (print TL lexical forms),
\texttt{<\textbf{modify-case}>} (modify case state of a lexical form),
\texttt{<\textbf{call-macro}>} (call a macro-instruction) and
\texttt{<\textbf{append}>} (concatenate strings).


Through the processing step, depending on whether a series of
conditional options are met or not, different operations are carried
out, such as creating agreement between pattern components, necessary
when these undergo gender or number changes in the lexical transfer
process. To do this, in spite of working with TLLF, also the SL
information is taken into account, since, for example, if pattern
components do not agree in SL, maybe they do not have to agree in TL
either. As a consequence of the application of the different
operations in a pattern, values are assigned to pattern attributes
and, if applicable, to global or state variables, and the information
on the resulting TL pattern is sent to the next module (the
morphological generator in a shallow-transfer system, or the next
transfer module in an advanced transfer system).


\subsubsection{Element for macro-instruction call
\texttt{<call-macro>}}

In a rule it is possible to call any of the macro-instructions defined
in \texttt{<\textbf{section-def-macros}>}. To do this, one has to
specify the name of the macro-instruction in the \texttt{n} attribute,
and one or more arguments in the parameter element
\texttt{<\textbf{with-param}>} (see next).

\subsubsection{Element for parameters \texttt{<with-param>}}

This element is used inside a macro-instruction call
\texttt{<\textbf{call-macro}>}. The \texttt{pos} attribute of an
argument is used to refer to a lexical form of the rule from where the
macro-instruction is called. For example, if a macro-instruction with
2 parameters has been defined, to make agreement operations between
noun--adjective, it can be used with arguments 1 and 2 in a rule for
noun--adjective, with arguments 2 and 3 in a rule for
determiner--noun--adjective, with arguments 1 and 3 in a rule for
noun--adverb--adjective and with arguments 2 and 1 in a rule for
adjective--noun. You can see an example of macro-instruction call in
Figure \ref{fig:macro}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{call-macro} n="f_concord2"> 
  <\textbf{with-param} pos="3"/>
  <\textbf{with-param} pos="1"/>
<\textbf{/call-macro}>
\end{alltt}
\end{small}
\caption{Call of the macro-instruction \texttt{f-concord2} designed to
create agreement between two elements in a pattern such as
determiner--adverb--noun. Propagation of gender and number is done
from one of the components, in this case, from the noun which is the
third element of the pattern (3). Therefore, the position of the noun
is the first parameter given, and the other parameters come
next. Since the adverb (in position 2) does not need agreement
information, only the position of the determiner is specified (1).}
\label{fig:macro}
\end{figure}



\subsubsection{Element for selection \texttt{<choose>}}
\label{choose}

The selection instruction consists of one or more conditional options
(\texttt{<\textbf{when}>}) and an alternative option
\texttt{<\textbf{otherwise}>}, which is optional.


\subsubsection{Element for condition \texttt{<when>}}

This element describes a conditional option (see Section
\ref{choose}).  It contains the condition to be tested
\texttt{<\textbf{test}>} and one block of zero or more instructions of
the kind \texttt{<\textbf{choose}>}, \texttt{<\textbf{let}>},
\texttt{<\textbf{out}>}, \texttt{<\textbf{modify-case}>},
\texttt{<\textbf{call-macro}>} or \texttt{<\textbf{append}>}, \nota{OK
append?} which will be executed if the above condition is met.

\subsubsection{Element for alternative option \texttt{<otherwise>}}

The element \texttt{<\textbf{otherwise}>} contains one block of one or
more instructions (of the kind \texttt{<\textbf{choose}>},
\texttt{<\textbf{let}>}, \texttt{<\textbf{out}>},
\texttt{<\textbf{modify-case}>}, \texttt{<\textbf{call-macro}>} and
\texttt{<\textbf{append}>}) that must be executed if none of the
conditions described in the \texttt{<\textbf{when}>} elements of a
\texttt{<\textbf{choose}>} is met.

\subsubsection{Element for evaluation \texttt{<test>}}

The test element \texttt{<\textbf{test}>} in a condition element
\texttt{<\textbf{when}>} can contain a conjunction
(\texttt{<\textbf{and}>}), a disjunction (\texttt{<\textbf{or}>}) or a
negation (\texttt{<\textbf{not}>}) of conditions to be tested, as well
as a simple condition of string equality (\texttt{<\textbf{equal}>}),
string beginning (\texttt{<\textbf{begins-with}>}), string end
(\texttt{<\textbf{ends-with}>}), substring
(\texttt{<\textbf{contains-substring}>}) or inclusion in a set
(\texttt{<\textbf{in}>}).

\nota{Segur que es pot millorar la redacció de l'últim paràgraf,
canviat per mlf perquè hi estiguen totes les condicions booleanes
simples.}

\subsubsection{Elements for conditional or boolean operators:
\texttt{<equal>}, \texttt{<and>}, \texttt{<or>}, \texttt{<not>},
\texttt{<in>}}

\nota{To be completed: add \texttt{contains-substring},
\texttt{ends-with}, \texttt{begins-with}, etc.}

\begin{itemize}
  
\item The conjunction element \texttt{<\textbf{and}>} represents a
condition, consisting of two or more conditions, that is met when all
included conditions are true. An example of its use can be found in
Figure \ref{fig:regla}.

\item The disjunction element \texttt{<\textbf{or}>} represents a
condition, consisting of two or more conditions, that is met when at
least one of the included conditions is true. Figure \ref{fig:ornot}
displays an example of this condition type used when testing gender
agreement in a SL pattern.
  
\item The negation element \texttt{<\textbf{not}>} represents a
condition that is met when the included condition is not met, and vice
versa. An example of negation of an equality can be found in Figure
\ref{fig:ornot}.

\item The conditional equality operator \texttt{<\textbf{equal}>} is
an instruction that evaluates if two arguments (two strings) are
identical or not. See examples of its use in Figures \ref{fig:clip}
and \ref{fig:lit-tag}.  In addition, this operator can have the
attribute \texttt{caseless}, which, when its value is \texttt{yes},
causes the comparison of strings to be made ignoring case.  \nota{All
string conditional tests have the attribute \texttt{caseless}; also
\texttt{in} described below}

\item The "search in lists" operator \texttt{<\textbf{in}>} is used to
search for any value (specified as the first parameter of the condition)
in a list referred to by the \texttt{n} attribute of the
\texttt{<\textbf{list}>} element; this list must be defined in the
appropriate section (\texttt{<\textbf{section-def-lists}}).  The
search result is true if the value is found in the list.  This
comparison can also use the attribute \texttt{caseless}: if its value
is \texttt{yes}, the search is done ignoring case. Figure \ref{fig:in}
shows an example of its use.
  
\end{itemize}

\nota{Cal unificar tota la discussió anterior, traient factor comú.}

\nota{Cal descriure la resta d'elements condicionals que no hi són.}


\subsubsection{Element \texttt{<clip>}}
\label{ss:clip}


The \texttt{<\textbf{clip}>} element represents a substring of a SL or
TL lexical form, defined by the value of its different attributes (see an
example in Figure \ref{fig:clip}):

\begin{itemize}
\item \texttt{pos} is an index (1, 2, 3, etc.) used to select a
lexical form inside a rule: it refers to the place the lexical form
occupies in the pattern. In the \textit{postchunk} module there is
also the index ``0'', which refers to the pseudolemma of the chunk
\nota{MG: is it not "lexical pseudoform"?}, which is treated as a word
by itself in order to be able to consult its information and make
decisions from this.

\item \texttt{side} \textit{(only in the \texttt{chunker} module)}
specifies if the selected \emph{clip} is from the source language
(\texttt{sl}) or from the target language (\texttt{tl}).
  
\item \texttt{part} indicates which part of the lexical form is
processed; generally its value is one of the attributes defined in
\texttt{<\textbf{section-def-\\attrs}>} (\texttt{gen}, \texttt{nbr},
etc.), although it can also take four predefined values: \texttt{lem}
(refers to the lemma of the lexical form), \texttt{lemh} (the first
part of a split lemma), \texttt{lemq} (the queue of a split lemma),
and \texttt{whole} (the whole lexical form, including lemma and all
grammatical symbols, which may have been modified in the preceding
part of the rule).

\item \texttt{link-to} \textit{(only in the \texttt{chunker} module in
  advanced mode)} replaces the value that would result from consulting
  the rest of the attributes of the clip, by the value specified in
  this attribute, which must be a natural number ($>0$). \nota{MG:
  explain the new characteristics - Sergio?} This number indicates to
  which \texttt{<\textbf{tag}>} of the \texttt{<\textbf{chunk}>} is
  linked the clip content, the number being the order this tag
  occupies inside the element \texttt{<\textbf{tags}>}. The other
  attributes of the clip remain only for informational purposes, since
  they are overwritten by the value of the linked tag. An example of
  its use can be found in Figure \ref{fig:chunkintrachunk}.
   
\end{itemize}


\begin{figure}
\begin{small}
\begin{alltt}
    <\textbf{test}>
      <\textbf{not}>
        <\textbf{equal}> 
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="gen"/> 
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="sl" \textsl{part}="gen"/>
        <\textbf{/equal}> 
      <\textbf{/not}>
    <\textbf{/test}>
\end{alltt}
\end{small}
\caption{Extract from a rule where it is tested whether the TL
(\texttt{tl}) gender (\texttt{gen}) of the second lexical unit
identified in a pattern is different from the gender of the same
lexical unit in the SL (\texttt{sl})}.
\label{fig:clip}
\end{figure}



\subsubsection{Element for literal string \texttt{<lit>}} This element
is used to specify the value of a literal string by means of the
attribute \texttt{v}. For example, \texttt{<\textbf{lit}
v=\texttt{"}andar\texttt{"}/>} represents the string \emph{andar}.


\subsubsection{Element for tag value \texttt{<lit-tag>}} It is similar
to the \texttt{<\textbf{lit}>} element, with the difference that it
does not specify the value of a literal string but the value of a
grammatical symbol or tag, by means of the attribute \texttt{v}. An
example of its use can be found in Figure \ref{fig:lit-tag}.


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{equal}>
  <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="nbr"/>
  <\textbf{lit-tag} \textsl{v}="ND"/>
<\textbf{/equal}>
\end{alltt}
\end{small}
\caption{Use of the element \texttt{<\textbf{lit-tag}>}: it is tested
  whether the number (\texttt{nbr}) symbol of the second
  lexical unit in the TL (\texttt{tl}) is \texttt{ND} (number to be
  determined)}
\label{fig:lit-tag}
\end{figure}
 
\begin{figure}
\begin{small}
\begin{alltt}
   <\textbf{test}>
    <\textbf{or}>
      <\textbf{not}> 
        <\textbf{equal}>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="sl" \textsl{part}="gen"/>
          <\textbf{clip} \textsl{pos}="3" \textsl{side}="sl" \textsl{part}="gen"/>
        <\textbf{/equal}>
      <\textbf{/not}>
      <\textbf{not}>
        <\textbf{equal}>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="sl" \textsl{part}="gen"/>
          <\textbf{clip} \textsl{pos}="3" \textsl{side}="sl" \textsl{part}="gen"/>
        <\textbf{/equal}>
      <\textbf{/not}>
    <\textbf{/or}>
  <\textbf{/test}>
\end{alltt}
\end{small}
\caption{Extract from a rule where it is tested whether the SL gender
  of the first or the second lexical unit matched in a pattern (it
  could be, for example, determiner--adjective--noun) is different
  from the gender of the third lexical unit also in the SL.}
\label{fig:ornot}
\end{figure}



\subsubsection{Element for variable \texttt{<var>}}


Each \texttt{<\textbf{var}>} is a variable identifier: the mandatory
attribute \texttt{n} specifies its name as has been defined in
\texttt{<\textbf{section-def-vars}>}. When it appears in an
\texttt{<\textbf{out}>}, a \texttt{<\textbf{test}>}, or the right part
of a \texttt{<\textbf{let}>}, it represents the value of the variable;
when it appears on the left side of a \texttt{<\textbf{let}>}, in an
\texttt{<\textbf{append}>} or in a \texttt{<\textbf{modify-case}>}, it
represents the reference of the variable and its value can be changed.

\subsubsection{Element for reference to string list \texttt{<list>}}

This element is only used as the second parameter of a
\texttt{<\textbf{in}>} search.  The \texttt{n} attribute refers to the
specific list defined in the string lists definition section
\texttt{<\textbf{section-def-lists}>}. An example of its use can be found in
Figure \ref{fig:in}.


\begin{figure}
\begin{small}
\begin{alltt}
    <\textbf{rule}>
      <\textbf{pattern}> 
        <\textbf{pattern-item} \textsl{n}="verb"/>
        <\textbf{pattern-item} \textsl{n}="a"/>
      <\textbf{/pattern}> 
      <\textbf{action}>
      <\textbf{choose}>
        <\textbf{when}>
          <\textbf{test}>
            <\textbf{in} \textsl{caseless}="yes"/> 
              <\textbf{clip} \textsl{pos}="1" \textsl{side}="sl" \textsl{part}="lem"/> 
              <\textbf{list} \textsl{n}="verbos_est"/>
            <\textbf{/in}> 
          <\textbf{/test}>
          <\textbf{let}> 
            <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="lem"/> 
            <\textbf{lit} \textsl{v}="en"/>
         <\textbf{/let}> 
      <\textbf{/when}> 
      <!-- ... -->
\end{alltt}
\end{small}
\caption{Extract of a rule that detects a pattern made of a verb and
  the preposition \emph{a}, and then testes whether the verb (the
  lemma indicated in \texttt{lem}) of the source language
  (\texttt{sl}) is one of the lemmas included in the list of state
  verbs (defined in Figure \ref{fig:deflist}). If that be the case,
  the lemma of the second word in target language (\texttt{tl}) is
  changed to \emph{en}.}
\label{fig:in}
\end{figure}


\subsubsection{Element for case application \texttt{<get-case-from>}}

The \texttt{<\textbf{get-case-from}>} element represents the string
obtained after applying the letter case state of the lemma of a SL
lexical unit to a string (\emph{clip}, \emph{lit} or \emph{var}).  To
refer to the lexical unit from where the information is taken, the
attribute \texttt{pos} is used, which indicates the position of that
unit in the SL. This element is useful when the lexical units in a
pattern are reordered, or when a lexical unit is added or deleted. You
can see an example of its use in Figure \ref{fig:case}, which displays
a rule to transform the simple perfect preterite tense in Spanish
(\emph{dije}, "I said") into the compound form in Catalan (\emph{vaig
dir}). In this rule, a LF with lemma \emph{anar} and grammatical
symbol \emph{vaux} ("auxiliary verb") is added; it has to take the
case information from the Spanish verb (which has position "1" in the
pattern), so that the system translates \emph{Dije} as \emph{Vaig
dir}, \emph{dije} as \emph{vaig dir} and \emph{DIJE} as \emph{VAIG
DIR}.


\subsubsection{Element for case pattern query \texttt{<case-of>}}

It is used to get the case pattern of a string, that is, one of the
values "\texttt{aa}", "\texttt{Aa"} or "\texttt{AA}". It works like the
\texttt{<\textbf{clip}>} element, since it has the same attributes:
\texttt{pos}, the position of the word in the matched pattern;
\texttt{part}, the specific attribute that we refer to (normally the
lemma), which has the predefined attributes described in Section
\ref{ss:clip}, and finally, only in the \texttt{chunker} module, the
attribute \texttt{side}, referring to the translation side,
\texttt{sl} or \texttt{tl}. In Figure \ref{fig:case} you can see this
element in use, and you can find a more detailed description of this
example in the following Section (description of
\texttt{<\textbf{modify-case}>}).


\subsubsection{Element for case modification \texttt{<modify-case>}}

This instructions is used to modify the case of the first parameter
(usually a lemma) by means of the second parameter (a literal or a
variable). The first parameter can be a \texttt{<\textbf{var}>}, a
\texttt{<\textbf{clip}>} or a \texttt{<\textbf{case-of}>}, whereas the
second one can be anything that delivers a value, but in principle it
will be a \texttt{<\textbf{var}>} or a \texttt{<\textbf{lit}>}.  The
values that this value can take are usually ``\texttt{Aa}'', to
express that the ``left part'' of this case modification must have the
first letter in upper case and the rest in lower case, ``\texttt{aa}''
to put all in lower case, and ``\texttt{AA}'' to put all in upper
case.

Figure \ref{fig:case} shows a rule where this element is used. It
modifies in this rule the case of the TL lemma in position "1", which
corresponds to \emph{dir}, because, although in the rule output this
verb is the second lexical form (\emph{vaig dir}), it is actually the
translation of the LF which has position 1 in the SL, and, therefore,
it retains the same assigned position in the TL. This lemma is
assigned the value ``\texttt{aa}'' in the case that the SL lemma has
the state ``\texttt{Aa}''. There is nothing to specify for the rest of
the cases, since the case state of the LF in position 1 will be the
same in the SL and in the TL and, therefore, will be automatically
transferred (see Section~\pageref{mayusc} to obtain more information
on letter case handling in dictionaries ).


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{rule}>
  <\textbf{pattern}>
    <\textbf{pattern-item} n="pretind"/>
  <\textbf{/pattern}>
  <\textbf{action}>
    <\textbf{out}>
      <\textbf{lu}>
         <\textbf{get-case-from} pos ="1">
           <\textbf{lit} v="anar"/>
         <\textbf{/get-case-from}>
         <\textbf{lit-tag} v="vaux"/>
         <\textbf{clip} pos="1" side="sl" part="persona"/>
         <\textbf{clip} pos="1" side="sl" part="nbr"/>
       <\textbf{/lu}>
       <\textbf{b/}>
     <\textbf{/out}>
     <\textbf{choose}>
       <\textbf{when}>
         <\textbf{test}>
           <\textbf{equal}>
              <\textbf{case-of} pos="1" side="sl" part="lemh"/>
              <\textbf{lit} v="Aa"/>
           <\textbf{/equal}>
         <\textbf{/test}>
         <\textbf{modify-case}>
             <\textbf{case-of} pos="1" side="tl" part="lemh"/>
             <\textbf{lit} v="aa"/>
         <\textbf{/modify-case}>
       <\textbf{/when}>
     <\textbf{/choose}>
     <\textbf{out}>
       <\textbf{lu}>
          <\textbf{clip} pos="1" side="tl" part="lemh"/> 
          <\textbf{clip} pos="1" side="tl" part="a_verb"/>
          <\textbf{lit-tag} v="inf"/>
          <\textbf{clip} pos="1" side="tl" part="lemq"/>
       <\textbf{/lu}>
    <\textbf{/out}>
  <\textbf{/action}>
<\textbf{/rule}>
\end{alltt}
\end{small}
\caption{Rule for the translation from Spanish into Catalan, which
  turns the verbs in simple perfect preterite tense (\emph{dije}) into
  the
  compound perfect preterite tense usual in Catalan (\emph{vaig dir}),
    and at the same time assigns the appropriate case state
  to the two resulting words.}
\label{fig:case}
\end{figure}



\subsubsection{Element for assignment \texttt{<let>}}

The assignment instruction \texttt{<\textbf{let}>} assigns the value
of the right part of the assignment (a literal string, a
\texttt{clip}, a variable, etc.) to the left part (a \texttt{clip}, a
variable, etc.). An example of its use can be found in Figure
\ref{fig:regla}.



\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{rule}>
  <\textbf{pattern}>
    <\textbf{pattern-item} n="det"/>
    <\textbf{pattern-item} n="nom"/>
  <\textbf{/pattern}>
  <\textbf{action}>
      <\textbf{choose}>
        <\textbf{when}>
          <\textbf{test}>
            <\textbf{and}>
              <\textbf{not}>
                <\textbf{equal}>
                  <\textbf{clip} pos="2" side="tl" part="gen"/>
                  <\textbf{clip} pos="2" side="sl" part="gen"/>
                <\textbf{/equal}>
              <\textbf{/not}>
              <\textbf{not}>
                <\textbf{equal}>
                  <\textbf{clip} pos="2" side="tl" part="gen"/>
                  <\textbf{lit-tag} v="mf"/>
                <\textbf{/equa}l>
              <\textbf{/not}>
              <\textbf{not}>
                <\textbf{equal}>
                  <\textbf{clip} pos="2" side="tl" part="gen"/>
                  <\textbf{lit-tag} v="GD"/>
                <\textbf{/equal}>
              <\textbf{/not}>
            <\textbf{/and}>
          <\textbf{/test}>
          <\textbf{let}>
            <\textbf{clip} pos="1" side="tl" part="gen"/>
            <\textbf{clip} pos="2" side="tl" part="gen"/> 
          <\textbf{/let}>
        <\textbf{/when}>
      <\textbf{/choose}>
      <!-- Other gender and number agreement actions -->
\end{alltt}
\end{small}
\caption{Extract from a rule for the pattern \texttt{determiner--noun}
  (continues in Fig. \ref{fig:regla2}): in this part of the rule, the
  gender of the noun is assigned to the determiner in the case that
  the gender of the noun changes from the SL (\texttt{sl}) to the TL
  (\texttt{tl}) during the lexical transfer process between both
  languages.}
\label{fig:regla}
\end{figure}

\subsubsection{Element for string concatenation \texttt{<concat>}}

This element is used to concatenate strings in order to assign them to
a variable. It is used in combination with \texttt{<\textbf{let}>},
and the previous value of the variable is lost with the assignment of
\texttt{<\textbf{concat}>}.

It does not have any attribute. It can contain any instruction that
delivers a string, such as \texttt{<\textbf{lit}>},
\texttt{<\textbf{lit-tag}>} or \texttt{<\textbf{clip}>}.

Figure \ref{fig:concat} shows an example of its use.


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{let}>    
  <\textbf{var} n="palabra"/>
    <\textbf{concat}>
       <\textbf{clip} pos="3" side="tl" part="lem"/>  
       <\textbf{lit-tag} v="adj"/>
    <\textbf{/concat}>
<\textbf{/let}>   
\end{alltt}
\end{small}
\caption{In this example, the variable \texttt{palabra} is assigned
the value of the concatenation of a \texttt{clip} (the lemma in
position 3) and the \emph{adj} tag.}
\label{fig:concat}
\end{figure}




\subsubsection{Element for string concatenation \texttt{<append>}}

The \texttt{<\textbf{append}>} instruction can be used to save the
output of an action before printing it in the corresponding
\texttt{<\textbf{out}>}, if required by the designer of the transfer
rules.

The mandatory attribute \texttt{n} specifies the name of the variable
used. After applying the instruction, the previous content of the
referred variable will be the prefix of the new content, that is, the
new content inserted in the \texttt{<\textbf{append}>} will be
concatenated to the pre-existing content of the variable specified in
\texttt{n}.

The content of this instruction can be one or more of the following
tags: \texttt{<\textbf{b}>}, \texttt{<\textbf{clip}>},
\texttt{<\textbf{lit}>}, \texttt{<\textbf{lit-tag}>},
\texttt{<\textbf{var}>}, \texttt{<\textbf{get-case-from}>},
\texttt{<\textbf{case-of}>} or \texttt{<\textbf{concat}>}. There is an
example of its use in Figure \ref{fig:append}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{append} n="temporal"> 
  <clip pos="3" part="gen" side="tl"/>
<\textbf{/append}>
\end{alltt}
\end{small}
\caption{In this example, the variable \texttt{temporal} is assigned
the value of the gender, in the TL, of the third word matched by the
rule.}
\label{fig:append}
\end{figure}




\subsubsection{Element for output \texttt{<out>}}

\label{ss:out} The output instruction is used to specify the lexical
forms that are sent at the output of the module after having been
applied the required structural transfer operations. Its use is
different according to the module. On the one hand, its use in the
\texttt{chunker} module when it runs as only module (shallow-transfer)
and its use in the \texttt{postchunk} module are similar, since in
both cases, the output must be the input for the generator.  The
\texttt{chunker} in Apertium 2 and the \texttt{interchunk} have
different use modes: the former to create the chunks, and the latter
to modify the chunks without modifying its internal part.

\begin{enumerate}

\item \textbf{Use in \texttt{chunker} in shallow-transfer mode, and in
\texttt{postchunk}}

  The instruction sends each lexical form inside a
  \texttt{<\textbf{lu}>} set, which in turn can be contained inside a
  \texttt{<\textbf{mlu}>} element when the output is a multiword made
  of two or more LF. Besides, also the blanks or superblanks
  (\texttt{<\textbf{b}>}) between LF and LF are sent. You can find an
  example of its use in Figures \ref{fig:case} and \ref{fig:regla2}.

\begin{figure}
\begin{small}
\begin{alltt} 
    <!-- ... -->
    <\textbf{out}>
      <\textbf{lu}>
         <\textbf{clip} pos="1" side="tl" part="whole"/> 
      <\textbf{/lu}>
      <\textbf{lu}>
         <\textbf{clip} pos="2" side="tl" part="whole"/>
      <\textbf{/lu}>
    <\textbf{/out}>
  <\textbf{/process}>
 <\textbf{/action}>
<\textbf{/rule}>
\end{alltt}
\end{small}
\caption{Extract from a rule (comes from Fig. \ref{fig:regla}). At the
  end of the rule, and after different actions, the resulting data are
  sent by means of the attribute \texttt{whole}, which contains the
  lemma and the grammatical symbols of each LF (positions 1 and 2 in
  the pattern).}
\label{fig:regla2}
\end{figure}


\item \textbf{Use in \texttt{chunker} in advanced mode}

  The output of this module is expected to be a sequence of one or
  more chunks (sent inside a \texttt{<\textbf{chunk}>} element)
  separated by blanks \texttt{<\textbf{b}>}. Lexical forms and
  multiforms, as well as the blanks between them, are sent inside
  chunks. You can see in Figure \ref{fig:chunkintrachunk} an example
  of use.


\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{out}>
  <\textbf{chunk} name="pr" case="caseFirstWord">
    <\textbf{tags}> 
      <\textbf{tag}><\textbf{lit-tag} v="PREP"/><\textbf{/tag}>
    <\textbf{/tags}>
    <\textbf{lu}> 
      <\textbf{clip} pos="1" side="tl" part="whole"/>
    <\textbf{/lu}> 
  <\textbf{/chunk}> 
  <\textbf{b} pos="1"/>
  <\textbf{chunk} name="probj" case="caseOtherWord">
    <\textbf{tags}> 
      <\textbf{tag}><\textbf{lit-tag} v="NP"/><\textbf{/tag}> 
      <\textbf{tag}><\textbf{lit-tag} v="tn"/><\textbf{/tag}> 
      <\textbf{tag}><\textbf{clip} pos="2" side="tl" part="pers"/><\textbf{/tag}>
      <\textbf{tag}><\textbf{clip} pos="2" side="tl" part="gen"/><\textbf{/tag}> 
      <\textbf{tag}><\textbf{clip} pos="2" side="tl" part="nbr"/><\textbf{/tag}>
    <\textbf{/tags}>
    <\textbf{lu}> 
      <\textbf{clip} pos="2" side="tl" part="lem"/>
      <\textbf{lit-tag} v="prn"/> 
      <\textbf{lit-tag} v="2"/>
      <\textbf{clip} pos="2" side="tl" part="pers"/> 
      <\textbf{clip} pos="2" side="tl" part="gen" link-to="4"/> 
      <\textbf{clip} pos="2" side="tl" part="nbr" link-to="5"/>
    <\textbf{/lu}> 
  <\textbf{/chunk}>
<\textbf{/out}>
\end{alltt}
\end{small}
\caption{Output instruction that sends two chunks separated by a
  blank. The printed sequence is a preposition followed by a noun
  phrase ("NP"). The tags that are linked from the second chunk to the outside are
  pronoun type ("tn"), gender and number of the noun phrase
  (pronoun). The \texttt{<\textbf{tag}>} elements are used to specify
  the tags of the chunk, and the value of the attributes \texttt{name}
  and \texttt{case} is used to specify the pseudolemma of the chunk.}
\label{fig:chunkintrachunk}
\end{figure}


\item \textbf{Use in \texttt{interchunk}}

  In this module, lexical forms (words) are inaccessible, since it is
  only possible to operate with chunks and, therefore, inside an
  \texttt{<\textbf{out}>} element you can only put
  \texttt{<\textbf{chunk}>} elements or blanks \texttt{<\textbf{b}>}.
  The information on lemma and tags specified here in a \texttt{<\textbf{chunk}>}
  element refers exclusively to the lemma (pseudolemma) and the tags of
  the chunk.

An example of its use can be found in Figure
\ref{fig:chunkinterchunk}.

\begin{figure}
\begin{small}
\begin{alltt}
<\textbf{out}> 
  <\textbf{b} pos="1"/>
  <\textbf{chunk}> 
    <\textbf{clip} pos="2" part="lem"/> 
    <\textbf{clip} pos="2" part="tags"/> 
    <\textbf{clip} pos="2" part="chcontent"/>
  <\textbf{/chunk}> 
<\textbf{/out}>
\end{alltt}

\end{small}
\caption{The aim of this rule output is to discard the first chunk of
  the matched pattern (pronoun drop). The three
  \texttt{<\textbf{clip}>} elements have been included here for
  illustrative purposes, since they could have been replaced by the
  \texttt{part="whole"} which would group them in a single
  \texttt{<\textbf{clip}>} .}
\label{fig:chunkinterchunk}
\end{figure}



\end{enumerate}




\subsubsection{Element for lexical unit \texttt{<lu>}}

\label{ss:lu} This is the element by means of which each TLLF is sent out at the
end of a rule, inside an \texttt{<\textbf{out}>} element.
With this element, one can send the whole lexical form, using the
attribute \texttt{whole} of a \texttt{<\textbf{clip}>}, or, if
required, specify its parts separately (lemma plus tags, indicated by
means of \texttt{<\textbf{clip}>} strings, literal strings
\texttt{<\textbf{lit}>}, tags \texttt{<\texttt{\textbf{lit-tag}}>},
variables \texttt{<\texttt{\textbf{var}}>}, besides case information
[\texttt{<\textbf{get-case-from}>}, \texttt{<\textbf{case-of}>}]).



Please note that, as has been explained before, in the case of
multiwords with \emph{split lemma} it is necessary to replace the
lemma queue \emph{after} the grammatical symbols of the inflected word
(or lemma head), because the \texttt{pretransfer} module has moved the
queue to put it before the grammatical symbols of the head.  This
replacement is done here, inside the \texttt{<\textbf{lu}>} element,
using the values \texttt{lemh} and \texttt{lemq} of the attribute
\texttt{part} in a \texttt{<\textbf{clip}>}. The \texttt{lemh}
attribute refers to the lemma head, and \texttt{lemq} to the lemma
queue. As can be seen in the example \ref{fig:case}, the \texttt{lemq}
part of a \texttt{<\textbf{clip}>} is placed after the lemma head and
all the grammatical symbols that follow it.  This rule would be
suitable, for example, for the Spanish form \emph{eché de menos} ("I
missed"), which has to be translated into Catalan as \emph{vaig trobar
a faltar}. The attribute \texttt{a\_verb} which comes after
\texttt{lemh} contains the grammatical symbol that describes the verb
category (\emph{vblex}, \emph{vbser}, \emph{vbhaver} or \emph{vbmod}
as applicable). Therefore, the last lexical form sent by this rule, in
the case of \emph{vaig trobar a faltar}, would be, in the data stream:
\begin{alltt} ^trobar<vblex><inf># a faltar\$ \end{alltt}

\noindent The number sign \texttt{\#} in the data stream corresponds
to the \texttt{<\textbf{g}>} element in dictionaries, used to signal
the position of the invariable part in a split lemma multiword.

It is important to note that the attributes included in
\texttt{<\textbf{lu}>} may be empty. So, a verb matched by the rule in
Fig. \ref{fig:case} which is not a split lemma multiword, will be sent
with an empty \texttt{lemq} attribute, since the verb does not have
lemma queue. This way it is not necessary to define different rules
for lexical forms with and without queue. You can find another example
of this in page \pageref{regla_verbo1}, where the rule for verb sends
in a \texttt{<\textbf{lu}>} the attributes \texttt{gen}
(\emph{gender}) and \texttt{nbr} (\emph{number}). This way, it
includes participles (with gender and number) and the rest of verb
forms (which will have these attributes empty).

In the same page you can see a rule for a verb followed by an enclitic
pronoun. Here, the lemma queue is placed after the enclitic pronoun;
so, for a split lemma multiword joined to an enclitic pronoun, such as
\emph{echándote de menos}, the output in the data stream would be,
when translating into Catalan:

\begin{alltt} ^trobar<vblex><ger>+et<prn><enc><p2><mf><sg># a faltar\$
\end{alltt}

Of course, this rule works also for verbs which do not belong to this
multiword type; so, the form \emph{explicándote} ("explaining to you")
would be output, when translating from Spanish to Catalan:


\begin{alltt} ^explicar<vblex><ger>+et<prn><enc><p2><mf><sg>\$
\end{alltt}

As for the attribute \texttt{whole} of a \texttt{<\textbf{clip}>}, it
must be taken into account that it can be used to send the whole
lexical form only in the case that the sent word can not be a
multiword, that is, can not contain a split lemma.  Compare figures
\ref{fig:case} and \ref{fig:regla2}. The \texttt{whole} attribute can
be used in the second example because it contains the lemma
\texttt{lem} plus all the morphological tags of the lexical forms in
position 1 and 2 (determiner and noun). \nota{but nouns can also be mw now!}Contrarily, in the first
example, the lexical form in \texttt{<\textbf{lu}>} is sent in parts,
with a \texttt{lemh} (lemma head) and a \texttt{lemq} (lemma queue),
since it may occur that the verb matched in the pattern is a multiword
with split lemma. In practice, in our system this means that the
\texttt{whole} attribute can be used to send any kind of lexical form
except verbs and nouns, because we defined multiwords with inner
inflection only for verbs and nouns.

\subsubsection{Element for lexical unit \texttt{<mlu>}}
\label{ss:mlu}

Its name derives from \emph{multilexical unit}; it is used inside the
\texttt{<\textbf{out}>} element to output multiwords consisting of
more than one lexical form. Each lexical form in a
\texttt{<\textbf{mlu}>} is sent inside a \texttt{<\textbf{lu}>}
element. On the output of the module, lexical forms contained in this
element will be joined to each other by the symbol '+' in the data
stream. This means that they will become a multiword made of different
lexical forms, which will be treated as a single unit by the
subsequent modules; therefore, the generation dictionary will have to
contain an entry for this multiword in order for it to be generated.

In our system, this element is used to join enclitic pronouns to
conjugated verbs.

\subsubsection{Element for chunk encapsulation \texttt{<chunk>}}

This is the element in which chunks are sent, in an
\texttt{<\textbf{out}>} element, on the output of the module.  It is
only used in the \texttt{chunker} module in advanced mode, and in the
\texttt{interchunk} module.  It is not used in the \texttt{postchunk}
module because its output does not contain any chunk. Neither it is
used in the \texttt{chunker} module in shallow-transfer mode, because
its output does not contain chunks but individual lexical units and
blanks.

\begin{enumerate}

\item \textbf{Use in \texttt{chunker} in advanced mode}


In this mode, the \texttt{<\textbf{chunk}>} element must have an
attribute \texttt{name}, which is the lemma of the chunk, or an
attribute \texttt{namefrom} which refers to a variable previously
defined, whose value will be used as the lemma of the chunk. Besides,
it can include the attribute \texttt{case} to specify which variable
is the case policy taken from (for example, a value obtained with the
instruction \texttt{<\textbf{case-from}>}).

An example of its use can be found in Figure
\ref{fig:chunkintrachunk}.


\item \textbf{Use in \texttt{interchunk}}

  In this module, the \texttt{<\textbf{chunk}>} element does not
specify any attribute; it is used just as the \texttt{<\textbf{lu}>}
element is used in the shallow-transfer or in the \texttt{postchunk}
to delimit the lexical forms.  The elements it sends are (generally in
a \texttt{<\textbf{clip}>} instruction): the lemma of the chunk
(\texttt{lem}), its tags (\texttt{tags}) and the chunk content
(\texttt{chcontent}, contains LF plus blanks), which is an invariable
part since it can not be accessed from the \texttt{interchunk} module.
The invariable part of the chunk is sent at the end.  You can also use
the \texttt{whole} attribute to send the whole chunk (lemma, tags and
invariable content).

  An example of its use can be found in Figure
  \ref{fig:chunkinterchunk}.

\end{enumerate}

\subsubsection{Element for tag links section \texttt{<tags>}}

\textit{Only in chunker in advanced mode}.

This element is used to specify a list of tags, or
\texttt{<\textbf{tag}>} elements, which will become the pseudotags of
the chunk. It does not have attributes, and must be included as first
item inside the \texttt{<\textbf{chunk}>} element. See Figure
\ref{fig:chunkintrachunk}.


\subsubsection{Element for tag link \texttt{<tag>}}

\textit{Only in chunker in advanced mode}.

The \texttt{<\textbf{tag}>} element must contain a morphological tag,
which can be specified by means of a \texttt{<\textbf{clip}>}
instruction or a literal tag \texttt{<\textbf{lit-tag}>}. It does not
have attributes.

The tag or tags specified this way in a chunk will become the
grammatical symbols of the chunk; the next module,
\texttt{interchunk}, will be able to use them to test and modify the
characteristics of the chunks.


\subsubsection{Element for blank \texttt{<b>}}

The \texttt{<\textbf{b}>} element refers to [super]blanks and is
indexed by the attribute \texttt{pos}. For example, a
\texttt{<\textbf{b}>} with \texttt{pos="2"} refers to the
[super]blanks (including format data encapsulated by the de-formatter)
between the 2nd SLLF and the 3rd SLLF. The explicit management of
[super]blanks enables the correct placement of format when the result
of the structural transfer has more or less elements than the
original, or when it has been reordered in some way.


\subsection{Specification of the three modules that build an advanced
transfer system}
\label{noutransfer}

In the following lines we describe the differences between the rule
format in the three modules of an advanced transfer system. When
Apertium works as a shallow-transfer system, the only module to be run
is the first one, called \texttt{chunker}, which communicates directly
with the generation module.


\subsubsection{\texttt{Chunker} module}
\label{ss:chunker}


This module can be used alone as a shallow-transfer system, or in
combination with the other two transfer modules to build an advanced
transfer system. An attribute of the \texttt{<transfer>} element
controls its run mode.

\paragraph{Input/output}

\begin{itemize}
\item Input: data in the \texttt{pretransfer} output format, that is,
with invariable queues of multiwords moved to the position right
before the first grammatical symbol.

\item Output:
\begin{itemize}
\item[-] in advanced mode (in an advanced transfer system): chunks,
that will be detected and processed by the next module
\item[-] in shallow-transfer mode (in a shallow-transfer system):
lexical forms, that will be the input of the generation module.
\end{itemize}

\end{itemize}


\paragraph{Data files}

\nota{Explicar millor això de l'únic fitxer de configuració}

This program uses a single configuration file and a precompiled file
for pattern detection calculated from the former. The name of the
pattern file (the configuration file) will have the extension
\texttt{.t1x}.  Since the \texttt{chunker} is the program that looks
up the bilingual dictionary, this dictionary (compiled) also has to be
provided to the program.

\nota{Potser seria bona idea esmentar en quina secció s'explica el
compilador a què es fa referència}

The DTD of this data file is specified in Appendix
\ref{ss:dtdtransfer}, and the elements used to create the rules in the
file are described in Section \ref{formatotransfer}.

\paragraph{Pattern matching}

The rule matching system in this module will be the one described in
\ref{functransfer}, since it is the same in advanced transfer mode and
in shallow-transfer mode. The \texttt{a\-per\-tium-pre\-trans\-fer}
program \nota{Vacil·lació terminològica \texttt{pretransfer}.}  is
needed to adapt the tagger output format to the input format required
by the transfer module.  There is the possibility that, in later
versions of Apertium, the \textit{part-of-speech tagger} is modified
so that it does the work of \texttt{apertium-pretransfer}.
\nota{També hem d'unificar la terminologia d'altres mòduls:
\emph{desambiguador categorial}, \emph{etiquetador}; tal com està
redactat el paràgraf es podria pensar que són dues coses diferents.}


\paragraph{How it works}

The module works similarly in shallow-transfer mode and in advanced
mode, with these differences:

\begin{itemize}
\item If we want that the module works as the first module in an
advanced transfer system, we must specify the value \texttt{chunk} in
the optional attribute \texttt{default} of the root element
\texttt{<transfer>}. The default value is \texttt{lu}, which implies
that the \texttt{chunker} works in shallow-transfer mode (as a single
module).

\item Chunk generation in the output: the \texttt{<chunk>} tag is an
element one level higher than \texttt{<lu>} (\textit{lexical unit}),
which generates chunks with the characteristics described in
\ref{sec:format}; it has the following attributes:

  \begin{itemize}
  \item \texttt{name} (optional): pseudolemma of the chunk. It
  contains a string that is identified as the pseudolemma of the
  chunk.

  \item \texttt{namefrom} (optional): pseudolemma of the chunk,
  obtained from a variable. It is compulsory to specify whether
  \texttt{name} or \texttt{namefrom}.

  \item \texttt{case} (optional): variable that is used to obtain the
  information on case from it and apply it to the lemma specified in
  \texttt{name} or in \texttt{namefrom}.
  \end{itemize}

\item Each chunk begins with a \texttt{<tags>} instruction, which does
not allow any attribute, and which contains one or more individual
instructions \texttt{<tag>}.
\item Instructions \texttt{<tag>} do not have attributes. They can
include any instruction that returns a string as a value:
\texttt{<lit>}, \texttt{<var>} \nota{clip, lit-tag}.
\item Instructions \texttt{<clip>} have an optional attribute:
\texttt{link-to}, which is used to specify a tag \verb!<!\textit{value
of link-to}\verb!>! that replaces \nota{Spanish: ``una etiqueta en
lugar de'' (instead of) or ``additionally''?. Explain new aspects of
link-to} the information specified by the \texttt{<clip>} in the rest
of its attributes.\nota{No s'entén gaire bé - Not understandable} This
information is dispensable but can be useful as information on the
origin of the linguistic decision.
\end{itemize}

The following is a use example of the \texttt{<chunk>} element :

\begin{alltt}
<out>
  <chunk name="adj-noun" case="variableCase"> 
    <tags> 
      <tag><lit-tag v="NP"/></tag> 
      <tag><clip pos="2" side="tl" part="gen"/></tag>
      <tag><clip pos="2" side="tl" part="nbr"/></tag> 
    </tags> 
    <lu> 
      <clip pos="2" side="tl" part="lemh"/> 
      <clip pos="2" side="tl" part="a_noun"/> 
      <clip pos="2" side="tl" part="gen" link-to="2"/>
      <clip pos="2" side="tl" part="nbr" link-to="3"/> 
    </lu> 
    <b pos="1"/> 
    <lu> 
      <var n="adjectiu"/> 
      <clip pos="1" side="tl" part="lem"/> 
      <clip pos="1" side="tl" part="a_adj"/> 
      <clip pos="2" side="tl" part="gen" link-to="2"/> 
      <clip pos="2" side="tl" part="nbr" link-to="3"/> 
    </lu> 
  </chunk>
</out>
\end{alltt}


\paragraph{Default action}

Isolated \textit{superblanks} which are not detected by any pattern in
this module, are written in the same order in which they arrive.

The default action for words not matched by any pattern
is different depending on the transfer mode (that is, on the value of the
optional attribute \texttt{default} of the root element \texttt{<transfer>}):

\begin{itemize}
\item if the value is \texttt{chunk} (i.e. the module works in advanced
  mode): it will generate trivial chunks with the words not matched by
  any rule, so that in the output there are no words not included in a
  chunk.  The new chunk will be created with the translation of the
  word by the bilingual dictionary.  The fixed lemma of these
  implicitly created chunks is \texttt{default}.
\item if the value is \texttt{lu} (default value; i.e. the module works as single
module in a shallow-transfer system): it will not create chunks for
words not matched by rules, they will just be translated using the
bilingual dictionary.

\end{itemize}

The following is an automatically generated chunk for a lexical form
not matched by any rule in the \texttt{chunker} module when the
\texttt{default} attribute has the value \texttt{chunk}:


\begin{alltt} 
^default\verb!{!^that<cnjsub>$\verb!}!$
\end{alltt}

\nota{Va sense etiquetes entre \texttt{default} i \texttt{\{}? No
caldria dir-ho explícitament?}


\subsubsection{\texttt{Interchunk} module}
\label{ss:interchunk}


\nota{\texttt{apertium-interchunk} or simply \texttt{interchunk}?}

The \texttt{interchunk} module processes chunks; it may reorder them
and change its morphosyntactic information. This is done by detecting
patterns of chunks (sequences of chunks).  The instructions that
control how it works are, with little differences, the same used by
the \texttt{chunker} module; they are written, however, in a different
file. Chunks are processed here in a similar way as words are
processed in the \texttt{chunker} of Apertium.  \nota{Comprovar la
denominació dels programes}

\paragraph{Input/output}

\begin{itemize}
\item Input: chunks from the \texttt{chunker}.
\item Output: chunks possibly reordered and with the data on its
pseudolemmas (lexical pseudoforms) possibly changed.
\end{itemize}

\paragraph{Data files}

This module uses two data files. A specification file of the
\texttt{in\-ter\-chunk} program, with extension \texttt{.t2x} by
analogy with the previous module, and a file of precalculated patterns
to accelerate the analysis of the input.  The binary file of the
bilingual dictionary is not included because it is not used.
\nota{Citar el compilador?}

The syntax of the specification file is very similar to that of the
\texttt{chunker}. Its DTD is specified in Appendix
\ref{ss:dtdinterchunk}, and the elements used to create the rules in
the file are described in Section \ref{formatotransfer}.


\paragraph{Pattern matching}

Rules detect patterns defined by sequences of lexical
pseudoforms. These lexical pseudoforms have a format based on the
format of lexical forms for words. In practice, a lexical pseudoform
is seen equivalently as \nota{mlforcada: La alternança
\emph{pseudolema} i \emph{pseudoparaula} s'ha de resoldre. MG: ho he
traduit tot com a 'lexical pseudoform', crec que era aquest el
sentit.} lexical forms are seen in the \texttt{chunker} regarding
pattern matching.  This way, pattern matching will be based on
attributes defined for lexical pseudoforms, not for lexical forms
(words) of the original pattern.

\paragraph{How it works}

With regard to the set of instructions used in \texttt{chunker}, the
changes on the set of instructions for this module are the following:

\begin{itemize}
\item The root element is called \texttt{<interchunk>} and does not
have any attribute.
\item The attribute \texttt{side} disappears: This module does not use
bilingual dictionaries; therefore, the attribute used to indicate
whether the consulted side is SL or TL looses sense. This attribute
was basically used in the \texttt{<out>} instructions.
\item The \texttt{<chunk>} tag is used here without attributes, simply
inside an \texttt{<out>} to delimit the output of chunks.
\item The predefined attribute \texttt{lem} refers to the pseudolemma
of the chunk. In the same way, the predefined attribute \texttt{tags}
refers to the grammatical symbols or tags of the chunk. The chunk
content becomes something like a queue which can be printed with the
implicit attribute \texttt{chcontent}.\nota{Només imprimir o s'hi pot
fer referència també?}  \nota{Dir de quin element són aquests
atributs}
\item All the values of \texttt{part}, except \texttt{chname}, access
the pseudolemma and the tags of the chunk (not of individual words).
\item Unlike what happens in the \texttt{chunker} module, in the rules
of this module it is not allowed to print anything else than
\texttt{<chunk>}s in the \texttt{<out>} instructions, in no case
isolated words.\nota{MG: and blanks too, right?}
\end{itemize}


\paragraph{Default action}

Like in the previous module, a default action has been defined, which
writes without modifications the chunks not matched by any pattern of
the specification file. This default action writes exactly what it
reads, be it chunks or blanks.  \nota{Atenció a la vacil·lació
\emph{regla}/\emph{acció} en la resta del document. Sempre havia
cregut que era \emph{regla}=\emph{patró}+\emph{acció}.}


\subsubsection{\texttt{Postchunk} module}
\label{ss:postchunk}

The \texttt{postchunk} module detects single chunks and, for each of
them, performs the specified actions. Detection is based on the lemma
of the chunk, and not in patterns (not in tags); this causes detection
in this module to be done specific for each ``name'' of
chunk.\nota{Quan fixem bé la terminologia hem d'assegurar-nos que la
redacció d'aquesta part és l'adequada.}


On the other hand, detection and processing in rules is based on the
fact that references to parameters are solved right after detection,
that is, the tags \texttt{<1>}, \texttt{<2>}, etc. are automatically
replaced by the value of the parameters before the processing
begins. Positions (attribute \texttt{pos}) specified in instructions
such as \texttt{<clip>}, refer to the position of the words inside the
chunk.

Also the case policy is automatically applied (see Section
\ref{ss:majuscules}) from the pseudolemma of the chunk to the words
inside the chunk.



\paragraph{Input/output}

\begin{itemize}
\item Input: chunks from the \texttt{in\-ter\-chunk}.
\item Output: valid input for the morphological generator of Apertium.
\end{itemize}

\paragraph{Data files}

This program has its own specification file, which will have the
extension \texttt{.t3x}. Its syntax is based as well on the
\texttt{chunker} and the \texttt{in\-ter\-chunk}.  \nota{Explicar que
no ha de llegir cap fitxer compilat de patrons perquè usa noms i no
patrons?}

\paragraph{Pattern matching}

Chunk matching is based on the name of the chunk. Unmatched chunks
receive the default processing.

\paragraph{How it works}

The differences with regard to the \texttt{in\-ter\-chunk} module are
the following:

\begin{itemize}
\item It is not allowed to write chunks (\texttt{<chunk>}) in the
  output: only lexical units (\texttt{<lu>} or \texttt{<mlu>}) and
  blanks can be written.  \nota{Comprovar aquest ítem perquè era
  incomplet i l'ha completat mlf}
\item New detection attribute \texttt{name} in \texttt{<cat-item>},
which is used in the \texttt{<pattern>} part of rules isolatedly, to
force pattern detection basing on its name.  \nota{mlf: Què vol dir
``de manera aïllada''? Sembla que vulga dir ``de tant en tant''. MG:
the attribute 'name' is used in the pattern part of rules? is this
correct?}
\item Also the attribute \texttt{side} is not used here, as in the
\texttt{in\-ter\-chunk}, for the same reason: the bilingual dictionary
is not looked up.  \nota{MG: però llavors això no és una diferència
respecte de \texttt{interchunk} no?}
\end{itemize}

\paragraph{Default action}


In this module, the default action is to write the words contained in
the chunks, replacing the references with the parameters of the
chunk. It will be applied to most chunks, since it is foreseen that
this module performs non-default actions only for specific cases
requiring some special processing.

Also the case policy is applied by default (see Section
\ref{ss:majuscules}).

In any case, blanks outside chunks are copied in the same order as are
read, since chunk matching is done individually (this module does
not group chunks).




\subsection{Preprocessing of the structural transfer module}
\label{ss:preproceso_transfer}

Specification files for the structural transfer modules, also called
\emph{transfer rules files}, are pre-processed by the program
\textit{apertium-preprocess-transfer}, which calculates the patterns
to match rules preconditions, and indexes the rules to speed up its
processsing during execution time.  This information is saved in a
binary file which is read together with the bilingual dictionary and
the rules file itself, because the structural transfer and lexical
transfer modules are executed together.


\section{De-formatter and re-formatter}
\label{se:desformat}


\subsection{Format processing}
\label{ss:formato}

This section describes how the de-formatter and re-formatter process
the format of the documents. These two modules are created from a set
of format specification rules in XML, which are described in Section
\ref{ss:reglasformato}.


Apertium can process documents in XML, HTML, RTF and plain text. For
all these document types, format is \textit{encapsulated} as explained
in the following lines.

Text strings that are identified as part of the format ---from now on
referred to as \textit{blocks of format} or \textit{superblanks}---
are encapsulated between delimiters that depend on the specification
of the data flow between modules (which is described in detail in
Section~\ref{se:flujodatos}); so, in the flow format (sections
\ref{se:noxml1} and \ref{se:noxml2}), \emph{superblanks} are put
between brackets '\texttt{[}' and '\texttt{]}'.  Each of these
encapsulated strings will be treated as it were a blank
\texttt{<\textbf{b}/>} (page~\pageref{s3:b}) ---that is why they are
called \textit{superblanks}--- and will be restored in the correct
order in the translator's output.

As has been explained in Section \ref{se:flujodatos}, when the blocks
of format are large (as is sometimes the case in HTML with Javascript
code fragments, or in RTF with bitmap images), these blocks will be
saved as temporary files so that they can be removed from the data
flow of the translation.

Sometimes, the format in a document can implicitly indicate the
division of the text into sentences (see page \pageref{finfrase} in
Section \ref{se:flujodatos}). For example, section or document titles
can be a sentence without full stop.  If we know that a format mark is
indicating this division, we have to take advantage of this
information in order to do a better translation.  Some examples of
format that give us data about the end of a sentence are: two
consecutive line breaks in plain text format, a \texttt{</h1>} tag in
HTML, etc. The de-formatter generates in such cases a mark of sentence
end that is equivalent to a full stop.

\subsubsection{Format encapsulation method}

The types of blocks of format or \emph{superblanks} that can be
generated as a result of the format processing are the following:

\begin{itemize}
\item \textit{Non-empty blocks of format or superblanks}.  They
contain exclusively format marks of the source document. In the data
flow described in Section~\ref{se:flujodatos} , they begin with a left
square bracket '\texttt{[}' and end with a right square bracket
'\texttt{]}'.
\item \textit{Blocks of format with reference to an external file} or
\textit{extensive superblanks}.  They encapsulate long format fragments
in a way that improves the translator's performance. In the data flow
described in Section~\ref{se:flujodatos}, they begin with the
characters `@verbatim{TODO}', then there is the name of the file where the
format fragment extracted from the source text is saved, and finally
they end with a right square bracket '\texttt{]}'.
\item \textit{Empty blocks of format}. They contain artificial
information on text division obtained from the format data.  Before
the empty block of format, the system places the appropriate
artificial punctuation mark.  When the original format is restored in
the document at the end of the process, the presence of a block of
format like this will cause the deletion of the character right before
the block in the data flow.
\end{itemize}

%% [movido al apéndice]
%% Dentro de los bloques de formato, los caracteres '\texttt{[}', '\texttt{]}',
%% @tt{@"@"} y '\verb!\!' se escapan mediante las secuencias de escape
%% '\verb!\[!', '\verb!\]!', '\verb!\@"@"!' y '\verb!\\!', respectivamente.  Esto
%% hay que tenerlo en cuenta para encapsular y desencapsular.  En el exterior de
%% los bloques de formato es necesario también escapar los corchetes de apertura
%% y cierre. 

The general criteria applied to the creation of blocks of format are
the following:

\label{pg:criteri}
\begin{itemize}
\item Everything that is considered not to be part of the text to be
translated, has to be encapsulated in blocks of format.
\item There can not be two or more strictly consecutive non-empty
blocks of format.  Two consecutive blocks of format must be merged
into a single block.
\item Empty blocks of format must precede a non-empty block of format
or the end of the file.
\end{itemize}

Figure~\ref{fg:ejemplopelado} shows an example document the format of
which must be processed before translation; the encapsulation
corresponds to the flow format not based on
XML. Figure~\ref{fg:ejemploencapsulado} displays the result of
processing the mentioned document.



\begin{figure}[htbp]
\begin{small}
\begin{alltt} 
<html> 
<head> 
<title>This is the title</title> 
<script>
<!-- ... (an extensive code block) --> 
</script> 
</head> 
<body>
<p>This 
is a paragraph in two lines</p> 
</body> 
</html>
\end{alltt}
\end{small}
\caption{Example of HTML document}
\label{fg:ejemplopelado}
\end{figure}

\begin{figure}[htbp]
\begin{small}
\begin{alltt} 
\textbf{[<html> 
<head> 
<title>]}This is the title\textbf{.[][@"@"/tmp/temp35345]}This\textbf{[ 
]}is a paragraph in two lines\textbf{.[][</p> 
</body> 
</html>]}
\end{alltt}
\end{small}
\caption{Example of HTML document where the blocks of format have been
  encapsulated by the de-formatter}\nota{repeteix coses capítol format
  -revisar -Gema}
\label{fg:ejemploencapsulado}
\end{figure}

 We would like to emphasize the following from this example:
\begin{itemize}
\item The system does not generate consecutive blocks of format with
content (non-empty).
\item Tags like \texttt{</\textbf{title}>} or \texttt{</\textbf{p}>}
cause the insertion of an artificial punctuation mark; this insertion
is done systematically, even when it is not necessary, because it does
not interfere and is efficient.
\item Extensive superblanks are literally removed from the translation
process. In this case, the temporary file \texttt{temp35345} contains
the tags from \texttt{</\textbf{title}>} to \texttt{<\textbf{p}>}
\item Simple blanks between words are not encapsulated.  But the
system does encapsulate multiple blanks (two or more consecutive
blanks), tabs, etc. Also line breaks are encapsulated.
\end{itemize}






\subsection{Data: format specification rules}
\label{ss:reglasformato} This section describes how the de-formatter
and re-formatter are generated from a format specification in XML.


Rules for format, like linguistic data, are specified in XML, and they
contain regular expressions with \texttt{flex} syntax.  The
specification is divided in three parts (see its DTD in the Appendix
\ref{ss:dtd_formato}):

\begin{itemize}
\item \textbf{Configuration options}. Here one specifies the value for
the maximum length of a non-extensive superblank, the input and output
encodings, whether case must be considered, and the regular expressions for
escape characters and space characters.

\item \textbf{Format rules}. Describes the set of tags belonging to a
specific format which have to be included in a block of format by the
de-formatter. These tags may, optionally, indicate a sentence end, in which case
the de-formatter will insert an artificial punctuation mark (followed
by an empty block of format, as explained in the previous
section). One has to specify the priority of application of the rules,
although, when this is not relevant, it is possible to give the same
priority to all the rules by assigning them the same value (any
number).
  
  Everything that is not specified as format will be left without
  encapsulation and, therefore, will be considered as translatable
  text.

\item \textbf{Replacement rules}. Allow to replace special characters
in the text. A regular expression will match a set of special 
characters, and will replace it with the specified characters. For 
example, in HTML, the characters specified in hexadecimal have to 
be replaced with the corresponding entity or ASCII character. For 
example, \texttt{cami\&oacute;n} corresponds to \texttt{camión}.
\end{itemize}

Rules are described in more detail next.
\begin{itemize}
\item Root of the specification file. The attribute \texttt{name}
contains the name of the format.
\begin{small}
\begin{alltt} 
<?xml version="1.0" encoding="ISO-8859-1"?> 
<format name="html"> 
  <options> 
  ...  
  </options>
  
  <rules> 
  ...  
  </rules> 
</format>
\end{alltt}
\end{small}

\end{itemize}

It has to include the options and rules, an example of which is
presented next:

\begin{itemize}

\item Options.
\begin{small}
\begin{alltt} 
  <options> 
    <largeblocks size="8192"/>
    <input encoding="ISO-8859-1"/>
    <output encoding="ISO-8859-1"/>
    <escape-chars regexp='[\verb!\![\verb!\!]^\$\verb!\!\verb!\!]'/>
    <space-chars regexp='[ \verb!\!n\verb!\!t\verb!\!r]'/>
    <case-sensitive value="no"/>
  </options>
\end{alltt}
\end{small}

\end{itemize}

The element \texttt{<largeblocks>} specifies the maximum length of a
non-extensive superblank, through the value of the attribute
\texttt{size}.  The elements \texttt{<input>} and \texttt{<output>}
specify the input and output encoding of the text, through the
attribute \texttt{encoding}.

The element \texttt{escape-chars} specifies, by means of a regular
expression declared in the value of the attribute \texttt{regexp},
which characters must be escaped with a backslash.  The element
\texttt{<space-chars>} specifies the set of characters that must be
considered as blanks.

Finally, the element \texttt{case-sensitive} specifies if case is
relevant in the specifications of format attributes in which regular
expressions are contained.


\begin{itemize}
\item Rules. There are format rules and replacement rules.
\begin{small}
\begin{alltt}
  <rules>
    <format-rule ... >
      ...
    </format-rule>
    ...
    
    <replacement-rule>
      ...
    </replacement-rule>
    ...
  </rules>
\end{alltt}
\end{small} The two types are described in the following points.

\item Format rules. The de-formatter will encapsulate in blocks of
format the tags indicated by these rules in the field
\texttt{regexp}. If they are begin and end tags, and everything
delimited by them is format, one has to specify a \texttt{regexp} both
for \texttt{begin} and for \texttt{end}:
\begin{small}
\begin{alltt} 
    <format-rule eos="no" priority="1">
      <begin regexp='"\verb!\!\&lt;!--"'/>
      <end regexp='"--\verb!\!\&gt;"'/>
    </format-rule>
\end{alltt}
\end{small} Otherwise only one \texttt{begin-end} element is used:
\begin{small}
\begin{alltt} 
    <format-rule eos="yes" priority="3">
      <begin-end regexp='"\&lt;"[/]?"li"[^\&gt;]*"\&gt;"'/>
    </format-rule>
\end{alltt}
\end{small}


Besides, in \texttt{priority} you have to specify a priority to tell
the system in which order the format rules must be applied (the
absolute value is not relevant, only the order resulting from the
values). In ``\texttt{eos}'' you indicate, with \texttt{yes} or
\texttt{no}, whether the block of format that contains the detected
pattern must be preceded by an artificial punctuation mark or
not.\footnote{In all these cases, the typical entities \texttt{\&lt;}
and \texttt{\&gt;} are used to represent the characters \texttt{<} and
\texttt{>} respectively.}

\item Replacement rules. Are used to replace special characters in the
text. The regular expression in the attribute \texttt{regexp} will
recognize \nota{idem: help in translation of "recogerá"} a set of
special characters and will replace them with the specified characters
in the text to be translated.  The correspondence between original and
replacement characters is stated in the attributes \texttt{source} and
\texttt{target} of the \texttt{replace} elements, which can be
multiple:
\begin{small}
\begin{alltt} 
    <replacement-rule regexp='"\&amp;"[^;]+;'>
      <replace source="\&amp;Agrave;" target="À"/>
      <replace source="\&amp;#192;" target="À"/>
      <replace source="\&amp;#xC0;" target="À"/>
      <replace source="\&amp;#xc0;" target="À"/>
      <replace source="\&amp;Aacute;" target="Á"/>
      <replace source="\&amp;#193;" target="Á"/>
      <replace source="\&amp;#xC1;" target="Á"/>
      <replace source="\&amp;#xc1;" target="Á"/>
      ...
    </replacement-rule>  
\end{alltt}
\end{small}
\item Regular expressions of \texttt{regexp} attributes. They have the
syntax used in \texttt{flex} \cite{lesk75tr}.
    
\end{itemize}

% DTD moguda a Apèndix


As example of a format specification, we will give that for HTML. The
explanation given in the following paragraphs can be followed looking
at Figure \ref{fg:formato-html}.


In the first place, we find the format rule that specifies in a
general way all the HTML tags: it considers as HTML tag everything
that begins with the sign \textbf{\texttt{<}} and ends with the sign
\textbf{\texttt{>}}. This rule has the lowest priority (4) so that the
more specific rules are applied preferentially.  But before
considering a tag in a general way by applying this rule, some of the
higher priority rules will be applied. In the case of HTML, the
highest priority is for comments \texttt{<!-- ... -->}.  The marks for
beginning and end \texttt{<script> </script>} and \texttt{<style>
</style>}, where everything included by them is considered to be
format, has priority 2.  Priority 3 is for tags that indicate end of
sentence (artificial punctuation), which are \texttt{</br>},
\texttt{</hr>}, \texttt{</p>}, etc.

Last of all are the replacement rules, which replace all the codes
that begin with \texttt{\&}, as specified in the regular
expression. Then, each one of the replacements is defined:
\texttt{\&Agrave}, as well as \texttt{\&\#192}, \texttt{\&\#xC0} and
\texttt{\&\#xc0} are replaced with \texttt{À}. The remaining special
characters are declared in the same way.



\begin{figure}[htbp]
\begin{small}
\begin{alltt} 
 <?xml version="1.0" encoding="ISO-8859-1"?>
 <format name="html">
   <options>
     <largeblocks size="8192"/>
     <input encoding="ISO-8859-1"/>
     <output encoding="ISO-8859-1"/>
     <escape-chars regexp='[\verb!\![\verb!\!]^\$\verb!\!\verb!\!]'/>
     <space-chars regexp='[ \verb!\! n\verb!\! t\verb!\! r]'/>
     <case-sensitive value="no"/>
   </options>
 
   <rules>
    <format-rule eos="no" priority="1">
       <begin regexp='"\&lt;!--"'/>
      <end regexp='"--\&gt;"'/>
    </format-rule>

    <format-rule eos="no" priority="2">
      <begin regexp='"\&lt;script"[^\&gt;]*"\&gt;"'/>
      <end regexp='"\&lt;/script"[^\&gt;]*"\&gt;"'/>
    </format-rule>
    <format-rule eos="no" priority="2">
      <begin regexp='"\&lt;style"[^\&gt;]*"\&gt;"'/>
      <end regexp='"\&lt;/style"[^\&gt;]*"\&gt;"'/>
    </format-rule>

    <format-rule eos="yes" priority="3">
      <begin-end regexp='"\&lt;"[/]?"br"[^\&gt;]*"\&gt;"'/>
    </format-rule>
    <!-- Here come more declarations of format-rule eos="yes"-->
    <!-- ...                                                -->

    <format-rule eos="no" priority="4">
      <begin-end regexp='"\&lt;"[a-zA-Z][^\&gt;]*"\&gt;"'/>
    </format-rule>

    <replacement-rule regexp='"\&amp;"[^;]+;'>
      <replace source="\&amp;Agrave;" target="À"/>
      <replace source="\&amp;#192;" target="À"/>
      <replace source="\&amp;#xC0;" target="À"/>
      <replace source="\&amp;#xc0;" target="À"/>
      <!-- Here come more replace elements                -->    
      <!-- ...                                              -->
    </replacement-rule>
  </rules>
</format>
\end{alltt}
\end{small}
\caption{Part of the rules definition for HTML format}
\label{fg:formato-html}
\end{figure}


\subsection{Generation of de-formatters and re-formatters}
\label{se:gendeformat}

To generate the de-formatter and re-formatter for a given format, the
XML rules that declare the format are applied a style sheet that
carries out the generation. This XSLT transformation produces a
\texttt{lex} \cite{lesk75tr} file that, once compiled, is the
executable of the de-formatter and the re-formatter for the specified
format.

Thanks to the general specification of formats described in this
chapter, it has been possible to define specifications for HTML, RTF
and plain text.  These specifications are in the \texttt{apertium}
package, in the respective files \texttt{html-format.xml},
\texttt{rtf-format.xml}, \texttt{txt-format.xml}.  In particular, it
is quite simple to define de-formatters and re-formatters for any XML
format.
