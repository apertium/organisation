#lang scribble/manual

@(require scriblib/figure)

@title[#:tag "maintain" #:version "3.5.2"]{Maintaining linguistic data}

\nota{Perhaps one could integrate material from Fran Tyers' howto as found in Apertium Wiki}
\section[Description of current data]{Description of linguistic data
currently available}

 At present, Apertium has linguistic data for three language pairs
 \nota{MG: This is old, needs UPDATING}: Spanish--Catalan and
 Spanish--Galician. The files containing the linguistic data are saved
 in a single directory: \texttt{apertium-es-ca} for the pair
 Spanish--Catalan and \texttt{apertium-es-gl} for the pair
 Spanish--Galician. The names of the files in this directory have the
 following structure:

\begin{itemize}\setlength{\itemsep}{-\parsep}
    \item \texttt{apertium-PAIR.LANG.dix} : monolingual dictionary for
    LANG.
    \item \texttt{apertium-PAIR.LANG1-LANG2.dix} :
    \texttt{LANG1-LANG2} bilingual dictionary.
    \item \texttt{apertium-PAIR.trules-LANG1-LANG2.xml} : structural
    transfer rules for the translation from \texttt{LANG1} to
    \texttt{LANG2} .
    \item \texttt{apertium-PAIR.LANG.tsx} : tagger definition file for
    \texttt{LANG}.
    \item \texttt{apertium-PAIR.post-LANG.dix} : Post-generation
    dictionary for \texttt{LANG} (applies when translating into
    \texttt{LANG}).
    \item directory \texttt{LANG-tagger-data} : contains data needed
    for the \texttt{LANG} tagger (corpora, etc.)

\end{itemize}

\texttt{apertium-PAIR} refers to the linguistic combination of the
translator. Its two possible values at the moment are
\texttt{apertium-es-ca} and \\ \texttt{apertium-es-gl}. According to
this structure, the Catalan monolingual dictionary is called
\texttt{apertium-es-ca.ca.dix}, the Spanish--Galician bilingual
dictionary is called \texttt{apertium-es-gl.es-gl.dix} and the
structural transfer rules file for the translation from Catalan into
Spanish is called \texttt{apertium-es-ca.trules-ca-es.xml}.


The linguistic data available (by January 2006) for the different
language pairs are summarized in the following table.
\begin{small}
\begin{center}
\begin{tabular}{|p{8cm}|p{5cm}|} \hline
\multicolumn{2}{|c|}{\textbf{Translator Apertium-es-ca}} \\ \hline
Spanish monolingual dictionary & 11.800 entries \\ Catalan monolingual
dictionary & 11.800 entries \\ Spanish--Catalan bilingual dictionary &
12.800 entries (correspondences \texttt{es-ca})\\ Structural transfer
rules from Spanish into Catalan & 44 rules \\ Structural transfer
rules from Catalan into Spanish & 58 rules \\ Spanish post-generation
dictionary & 25 entries and 5 paradigms\\ Catalan post-generation
dictionary & 16 entries and 57 paradigms\\ \hline
\multicolumn{2}{|c|}{\textbf{Translator Apertium-es-gl}} \\ \hline
Spanish monolingual dictionary & 9.000 entries \\ Galician monolingual
dictionary & 8.600 entries \\ Spanish--Galician bilingual dictionary &
8.500 entries (correspondences \texttt{es-gl})\\ Structural transfer
rules from Spanish into Galician & 46 rules \\ Structural transfer
rules from Galician into Spanish & 38 rules \\ Spanish post-generation
dictionary & 36 entries and 12 paradigms\\ Galician post-generation
dictionary & 74 entries and 48 paradigms\\ \hline
\end{tabular}
\end{center}
\end{small}


\section[Adding words to dictionaries]{Adding words to monolingual and
bilingual dictionaries}


When extending or adapting Apertium, the most likely operation that
will be performed will be to extend its dictionaries. In fact, it will
be far more common than adding transfer or post-generation rules.

We describe next the most important things one has to take into
account when adding new words to the translator. This information is
more general than the data provided in the section describing
dictionaries (chapter \ref{ss:diccionarios}), although we give here
some practical information that might be very useful to the users who
decide to make changes in the translator. 

IMPORTANT: Every time a set
of modifications is made to any of the dictionaries, the modules have
to be recompiled. Type \emph{make} in the directory where the linguistic data
are saved (apertium-es-ca, apertium-es-gl or what may be applicable)
so that the system generates the new binary files.

If you want to add a new word to Apertium, you need to add three
entries in the dictionaries. Suppose you are working with the
Spanish-Catalan pair.  In this case, you have to add:

\begin{enumerate}
\item an entry in the Spanish monolingual dictionary: so that the
translator can analyze ("understand") the word when it finds it in a
text, and generate it when translating this word into Spanish.

\item an entry in the bilingual dictionary: so that you can tell
Apertium how to translate this word from one language to the other.

\item an entry in the Catalan monolingual dictionary: so that the
translator can analyze ("understand") the word when it finds it in a
text, and generate it when translating this word into Catalan.
\end{enumerate}

You will need to go to the directory containing the XML dictionaries
(for the Spanish-Catalan pair, this is \texttt{apertium-es-ca}) and
open with a text editor or a specialized XML editor the three
dictionary files mentioned: \texttt{apertium-es-ca.es.dix},
\texttt{apertium-es-ca.es-ca.dix} and
\texttt{apertium-es-ca.ca.dix}. The entries you need to create in
these three dictionaries share a common structure.  \\

\textbf{Monolingual dictionary (Spanish)}


You may want, for example, to add the Spanish adjective
\emph{cósmico}, whose equivalent in Catalan is \emph{còsmic}. The
first step is to add this word to the Spanish monolingual dictionary.

You will see that a monolingual dictionary has basically two types of
data: \textbf{paradigms} (in the "\texttt{<pardefs>}" section of the
dictionary, each paradigm inside a \texttt{<pardef>} element) and
\textbf{word entries} (in the main (\texttt{<section>} of the
dictionary, each one inside an \texttt{<e>} element). Word entries
consist of a lemma (that is, the word as you would find it in a
typical paper dictionary) plus grammatical information; paradigms
contain the inflection data of all lemmas in the dictionary. You can
search a particular word by searching the string \texttt{lm="word"}
(\texttt{lm} meaning \emph{lemma}).  Bear in mind, however, that the
element \texttt{lm} is optional and some other dictionaries may not
contain it.

Look at the word entries in the Spanish monolingual dictionary, for
example at the entry for the adjective \emph{bonito}. You can find it
by searching \texttt{lm="bonito"}:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="bonito"> 
  <\textbf{i}>bonit</\textbf{i}>
  <\textbf{par} \textsl{n}="absolut/o__adj"/> 
</\textbf{e}>
\end{alltt}
\end{small}

To add a word, you will have to create an entry with the same
structure. The part between \texttt{<i>} and \texttt{</i>} contains
the prefix of the word that is common to all inflected forms, and the
element \texttt{<par>} refers to the inflection paradigm of this
word. Therefore, this entry means that the adjective \emph{bonito}
inflects like the adjective \emph{absoluto} and has the same
morphological analysis: the forms \emph{bonit\textbf{o}},
\emph{bonit\textbf{a}}, \emph{bonit\textbf{os}},
\emph{bonit\textbf{as}} are equivalent to the forms
\emph{absolut\textbf{o}}, \emph{absolut\textbf{a}},
\emph{absolut\textbf{os}}, \emph{absolut\textbf{as}} and have the
morphological analysis: \texttt{adj m sg}, \texttt{adj f sg},
\texttt{adj m pl} and \texttt{adj f pl} respectively.

Now, you have to decide which is the lexical category of the word you
want to add: the word \emph{cósmico} is an adjective, like
\emph{bonito}. Next, you have to find the appropriate paradigm for
this adjective. Is it the same as the one for \emph{bonito} and
\emph{absoluto}?  ¿Can you say \emph{cósmic\textbf{o}},
\emph{cósmic\textbf{a}}, \emph{cósmic\textbf{os}},
\emph{cósmic\textbf{as}}? The answer is yes, and, with all this
information, you can now create the correct entry:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="cósmico">
    <\textbf{i}>cósmic</\textbf{i}>
  <\textbf{par} \textsl{n}="absolut/o__adj"/>
</\textbf{e}>
\end{alltt}
\end{small}


If the word you want to add has a different paradigm, you have to find
it in the dictionary and assign it to the entry. You have two ways to
find the appropriate paradigm: looking in the \texttt{<pardefs>}
section of the dictionary, where all the paradigms are defined inside
a \texttt{<pardef>} element, or finding another word that you think
may already exist in the dictionary and that has the same inflection
paradigm as the one to be added. For example, if you want to add the
word \emph{genoma}, you need to find an appropriate paradigm for a
\textbf{noun} whose gender is masculine and forms the plural with the
addition of an \textbf{-s}. This will be the paradigm
"\texttt{abismo\_\_n}" in our present dictionaries. Therefore, the
entry for this new word would be:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="genoma">
    <\textbf{i}>genoma</\textbf{i}>
  <\textbf{par} \textsl{n}="abismo__n"/>
</\textbf{e}>
\end{alltt}
\end{small}

In exceptional cases you will need to create a new paradigm for a
certain word. You can look at the structure of other paradigms and
create one accordingly. For a more detailed description of paradigms
and word entries in the dictionaries, refer to section
\ref{ss:diccionarios}.  \\

\textbf{Monolingual dictionary (Catalan)}

Once you have added the word to one monolingual dictionary, you have
to do the same to the other monolingual dictionary of the translation
pair (in our example, the Catalan monolingual dictionary) using the
same structure. The result would be:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="còsmic">
    <\textbf{i}>còsmi</\textbf{i}>
  <\textbf{par} \textsl{n}="acadèmi/c__adj"/>
</\textbf{e}>
\end{alltt}
\end{small}

\textbf{Monolingual dictionary (Galician)}

In the case you are trying to improve the XML dictionaries for the
Spanish-Galician pair, you will need to go to the directory
\texttt{apertium-es-gl} and open with a text editor or a specialized
XML editor the three dictionary files \texttt{apertium-es-gl.es.dix},
\texttt{apertium-es-gl.es-gl.dix} and
\texttt{apertium-es-gl.gl.dix}. In that case, once you have added the
new Spanish word \emph{genoma} to the Spanish monolingual dictionary
(\texttt{apertium-es-gl.es.dix}), you have to add the equivalent
Galician word \emph{xenoma} to the Galician monolingual dictionary
(\texttt{apertium-es-gl.gl.dix}), that is:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="xenoma">
    <\textbf{i}>xenoma</\textbf{i}>
  <\textbf{par} \textsl{n}="Xulio__n"/>
</\textbf{e}>
\end{alltt}
\end{small}

\textbf{Bilingual dictionary}

The last step is to add the translation to the bilingual dictionary.

A bilingual dictionary does not usually have paradigms, only
lemmas. An entry contains only the lemma in both languages and the
first grammatical symbol (the lexical category) of each one. Entries
have a left side (\texttt{<l>}) and a right side (\texttt{<r>}), and
each language has always to be in the same position: in our system, it
has been agreed that Spanish occupies the left side, and Catalan,
Galician and Portuguese the right side.


With the addition of the lemma of both words, the system will
translate all their inflected forms (the grammatical symbols are
copied from the source language word to the target language
word). This will only work if the source language word and the target
language word are grammatically equivalent, that is, if they share
exactly the same grammatical symbols for all of their inflected
forms. This is the case with our example; therefore, the entry you
have to add to the bilingual dictionary is:


\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>cósmico<\textbf{s} \textsl{n}="adj"/></\textbf{l}>
    <\textbf{r}>còsmic<\textbf{s} \textsl{n}="adj"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

This entry will translate all the inflected forms, that is,
\texttt{adj m sg}, \texttt{adj f sg}, \texttt{adj m pl} and
\texttt{adj f pl}. It works for the translation in both directions:
from Spanish to Catalan and from Catalan to Spanish.

In the case of the Spanish-Galician pair, the following bilingual
entry in the Spanish-Galician bilingual dictionary
(\texttt{apertium-es-gl.es-gl.dix}) will translate all the inflected
forms for the equivalent words \emph{genoma}/\emph{xenoma} in both
directions:

\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>genoma<\textbf{s} \textsl{n}="n"/></\textbf{l}>
    <\textbf{r}>xenoma<\textbf{s} \textsl{n}="n"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

What to do if the word pair is not equivalent grammatically (their
grammatical symbols are not exactly the same)? In that case, you need
to specify all the grammatical symbols (in the same order as they are
specified in the monolingual dictionaries) until you reach the symbol
that differs between the source language word and the target language
word. For example, the Spanish noun \emph{limón} has masculine gender
and its equivalent in Catalan, \emph{llimona}, has feminine
gender. The entry in the bilingual dictionary must be as follows:

\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>limón<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/></\textbf{l}>
    <\textbf{r}>llimona<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}


A more difficult problem arises when two words have different
grammatical symbols and the grammatical information of the source
language word is not enough to determine the gender (masculine or
feminine) or the number (singular or plural) of the target language
word. Take for example the Spanish adjective \emph{canadiense}. Its
gender is masculine--feminine since it is invariable in gender, that
is, it can go both with masculine and feminine nouns (\emph{hombre
canadiense}, \emph{mujer canadiense}). In Catalan, on the other hand,
the adjective has a different inflection for the masculine and the
feminine (\emph{home canadenc}, \emph{dona canadenca}). Therefore,
when translating from Spanish to Catalan it is not possible to know,
without looking at the accompanying noun, whether the Spanish
adjective (\emph{mf}) has to be translated as a feminine or a
masculine adjective in Catalan. In that case, the symbol \texttt{GD}
(for "gender to be determined") is used instead of the gender
symbol. \label{GDND} The word's gender will be determined by the
structural transfer module, by means of a transfer rule (a rule that
detects the gender of the preceding noun in this particular
case). Therefore, \texttt{GD} must be used only when translating from
Spanish to Catalan, but not when translating from Catalan to Spanish,
as in Spanish the gender will always be \texttt{mf} regardless of the
gender of the original word.  In the bilingual dictionary you will
need to add, in this case, more than one entry with direction
indications, as you must specify in which translation direction the
gender remains undetermined. The entries for this adjective should be
as follows:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{r}="LR">
  <\textbf{p}>
    <\textbf{l}>canadiense<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>canadenc<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="GD"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>canadiense<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>canadenc<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="f"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>canadiense<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="mf"/></\textbf{l}>
    <\textbf{r}>canadenc<\textbf{s} \textsl{n}="adj"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

"\texttt{LR}" means \emph{left to right} and "\texttt{RL}",
\emph{right to left}. Since Spanish is on the left and Catalan on the
right, the adjective will be \texttt{GD} only when translating from
Spanish to Catalan (\texttt{LR}). For the translation \texttt{RL} you
need to create two entries, one for the adjective in feminine and
another one for the adjective in masculine.\footnote{You could also
group them using a small paradigm}

The same principle applies when it is not possible to determine the
number of the target word for the same reasons mentioned above. For
example, the Spanish noun \emph{rascacielos} ("skyscraper") is
invariable in number, that is, it can be singular as well as plural
(\emph{un rascacielos}, \emph{dos rascacielos}). In Catalan, on the
other hand, the noun has a different inflection for the singular and
for the plural (\emph{un gratacel}, \emph{dos gratacels}).  In this
case the symbol used is "\texttt{ND}" ("number to be determined") and
the entries should be like this:


\begin{small}
\begin{alltt}
<\textbf{e} \textsl{r}="LR">
  <\textbf{p}>
    <\textbf{l}>rascacielos<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sp"/></\textbf{l}>
    <\textbf{r}>gratacel<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="ND"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>rascacielos<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sp"/></\textbf{l}>
    <\textbf{r}>gratacel<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="pl"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>rascacielos<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sp"/></\textbf{l}>
    <\textbf{r}>gratacel<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/><\textbf{s} \textsl{n}="sg"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

For a more detailed description of this kind of entries, refer to
section~\pageref{ss:bil}.



\subsection{Adding direction restrictions}

In the previous example we have already seen the use of direction
restrictions for entries with undetermined gender or number
(\texttt{GD} or \texttt{ND}). These restrictions can also be used in
other cases.

It is important to note that the current version of Apertium can give
only a single equivalent for each source-language lexical form
\nota{NEEDS UPDATING, reference to lextor} (a lexical form is the
lemma plus its grammatical information), that is, no word-sense
disambiguation is performed.\footnote{The system performs only
part-of-speech disambiguation for homograph words, that is, for
ambiguous words that can be analyzed as more than one lexical form,
like \emph{vino} in Spanish, that can mean both "wine" and "he/she
came". This type of disambiguation is performed by the tagger.} When a
lexical form can be translated in two or more different ways, one has
to be chosen (the most general, the most frequent, etc.).  You can
tell Apertium that a certain word has to be analyzed ("understood")
but not generated, as it is not the translation of any word in the
other language.

Let's see this with an example. The Spanish noun \emph{muñeca} can be
translated in two different ways in Catalan depending on its meaning:
\emph{canell} ("wrist") or \emph{nina} ("doll"). The context decides
which translation is the correct one, but in its present state
Apertium can not make such a decision .\footnote{See Section
\ref{multi} on multiword units for ways to circumvent this problem.}
Therefore, you have to decide which word you want as an equivalent
when translating from Spanish to Catalan.  From Catalan to Spanish,
both words can be translated as \emph{muñeca} without any problem. You
have to specify all these circumstances in the dictionary entries
using direction restrictions (\texttt{LR} meaning "left to right",
that is, \texttt{es}--\texttt{ca}, and \texttt{RL} meaning "right to
left", that is, \texttt{ca}--\texttt{es}). If you decide to translate
\emph{muñeca} as \emph{canell} in all cases, the entries in the
bilingual dictionary shall be:


\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>muñeca<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/></\textbf{l}>
    <\textbf{r}>canell<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>

<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>muñeca<\textbf{s} \textsl{n}="n"/></\textbf{l}>
    <\textbf{r}>nina<\textbf{s} \textsl{n}="n"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

This means that translation directions will be:
\begin{small}
\begin{alltt} 
    muñeca --> canell
    muñeca <-- canell
    muñeca <-- nina 
\end{alltt}
\end{small}

(Note that that there is also a gender change in the case of
\emph{muñeca} (feminine) and \emph{canell} (masculine)).

It should be emphasized that a lemma can not have two translations in
the target language, because the system would give an error when
translating that lemma (see Section \ref{errores} "Detecting errors"
to see how to find and correct these and other types of errors). When
a word can be translated in two different ways in the target language
in all contexts, you need to choose one as the translation equivalent
and leave the other one as a lemma that can be analyzed but not
generated, using direction restrictions like in the previous
example. For example, the Catalan lemmas \emph{mot} and \emph{paraula}
can be both translated into Spanish as \emph{palabra} ("word") and the
entries in the bilingual dictionary should look like this:

\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>palabra<\textbf{s} \textsl{n}="n"/></\textbf{l}>
    <\textbf{r}>paraula<\textbf{s} \textsl{n}="n"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>

<\textbf{e} \textsl{r}="RL">
  <\textbf{p}>
    <\textbf{l}>palabra<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/></\textbf{l}>
    <\textbf{r}>mot<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

Therefore, for this lemmas the translation directions will be:
\begin{small}
\begin{alltt} 
    palabra --> paraula
    palabra <-- paraula
    palabra <-- mot 
\end{alltt}
\end{small}

One may have to specify restrictions regarding translation direction
also in monolingual dictionaries. For example, both Spanish forms
\emph{cantaran} and \emph{cantasen} should be analyzed as lemma
\emph{cantar}, verb, subjunctive imperfect, 3rd person plural, but
when generating Spanish text, one has to decide which one will be
generated. Monolingual dictionaries are read in two directions
depending on its purpose: for the analysis, the reading direction is
left to right; for the generation, right to left. Therefore, a word
that must be analyzed but not generated must have the restriction
\texttt{LR}, and a word that must be generated but not analyzed must
have the restriction \texttt{RL}.


The case of \emph{cantaran} or \emph{cantasen} must have already been
taken care of in inflection paradigms and it is unlikely to be a
problem for most people extending a dictionary. In some other cases it
can be necessary to introduce a restriction in the word entries of
monolingual dictionaries.

\subsection{Adding multiwords}
\label{multi}

It is possible to create entries consisting of two or more words, if
these words are considered to build a single "translation unit".
These multiword units can also be useful when it comes to select the
correct equivalent for a word inside a fixed expression. For example,
the Spanish word \emph{dirección} may be translated into two Catalan
words: \emph{direcció} ("direction, management, directorate,
steering", etc.) and \emph{adreça} ("address"); including, for
example, frequent multiword units such as \emph{dirección general}
\(\to\) \emph{direcció general} ("general directorate") and
\emph{dirección postal} \(\to\) \emph{adreça postal} ("postal
address") may help get improved translations in some situations.

Multiword units can be classified basically into two categories:
multiwords with inner inflection and multiwords without inner
inflection.

\subsubsection{Multiwords without inner inflection}

They are just like the normal one-word entries, with the only
difference that you need to insert the element \texttt{<b>} (which
represents a blank) between the individual words that make up the
unit. Therefore, if you want to add, for example, the Spanish
multiword \emph{hoy en día} ("nowadays"), whose equivalent in Catalan
is \emph{avui dia}, the entries you need to add to the different
dictionaries are:

\begin{itemize}

\item Spanish monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="hoy en día">
  <\textbf{i}>hoy<\textbf{b}/>en<\textbf{b}/>día</\textbf{i}>
  <\textbf{par} \textsl{n}="ahora__adv"/> 
</\textbf{e}>
\end{alltt}
\end{small}

\item Catalan monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="avui dia">
  <\textbf{i}>avui<\textbf{b}/>dia</\textbf{i}> 
  <\textbf{par} \textsl{n}="ahir__adv"/> 
</\textbf{e}>
\end{alltt}
\end{small}

\item Spanish-Catalan bilingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>hoy<\textbf{b}/>en<\textbf{b}/>día<\textbf{s} \textsl{n}="adv"/></\textbf{l}>
    <\textbf{r}>avui<\textbf{b}/>dia<\textbf{s} \textsl{n}="adv"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\end{itemize}

For Spanish-Galician pair, if you want to add, for example, the
Spanish multiword \emph{manga por hombro} ("disarranged"), whose
equivalent in Galician is \emph{sen xeito nin modo}, the entries you
need to add are:

\begin{itemize}

\item Spanish monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="manga por hombro">
  <\textbf{i}>manga<\textbf{b}/>por<\textbf{b}/>hombro</\textbf{i}>
  <\textbf{par} \textsl{n}="ahora__adv"/> 
</\textbf{e}>
\end{alltt}
\end{small}

\item Galician monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="sen xeito nin modo">
  <\textbf{i}>sen<\textbf{b}/>xeito<\textbf{b}/>nin<\textbf{b}/>modo</\textbf{i}>
  <\textbf{par} \textsl{n}="Deo_gratias__adv"/> 
</\textbf{e}>
\end{alltt}
\end{small}

\item Spanish-Galician bilingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>manga<\textbf{b}/>por<\textbf{b}/>hombro<\textbf{s} \textsl{n}="adv"/></\textbf{l}>
    <\textbf{r}>sen<\textbf{b}/>xeito<\textbf{b}/>nin<\textbf{b}/>modo<\textbf{s} \textsl{n}="adv"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\end{itemize}

\subsubsection{Brief introduction to paradigms}

The paradigms of the previous examples, as adverbs do not inflect,
contain only the grammatical symbol of the lexical form, as you see in
this example:

\begin{small}
\begin{alltt}
<\textbf{pardef} \textsl{n}="ahora__adv">
  <\textbf{e}>
    <\textbf{p}>
      <\textbf{l}/>
      <\textbf{r}><\textbf{s} \textsl{n}="adv"/></\textbf{r}>
    </\textbf{p}>
  </\textbf{e}>
</\textbf{pardef}>
\end{alltt}
\end{small}

Paradigms are build like a lexical entry. We have seen so far lexical
entries where the common part of the lemma is put between \texttt{<i>}
\texttt{</i>}:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="cósmico"> 
  <\textbf{i}>cósmic</\textbf{i}>
  <\textbf{par} \textsl{n}="absolut/o__adj"/> 
</\textbf{e}>
\end{alltt}
\end{small}


But you can also express the same with a pair of strings: a left
string \texttt{<l>} and a right string \texttt{<r>} inside a
\texttt{<p>} element:

\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="cósmico">
  <\textbf{p}>
    <\textbf{l}>cósmic</\textbf{l}>
    <\textbf{r}>cósmic</\textbf{r}>
  </\textbf{p}>
  <\textbf{par} \textsl{n}="absolut/o__adj"/>
</\textbf{e}>
\end{alltt}
\end{small}


These two entries are equivalent. The use of the \texttt{<i>} element
helps get more simple and compact entries, and you can use it when the
left side and the right side of the string pair are identical. As has
been explained before, monolingual dictionaries are read \texttt{LR}
for the analysis of a text and \texttt{RL} for the
generation. Therefore, when there is some difference between the
analysed string and the generated string (not very usual) the entry
can not be written using the \texttt{<i>} element. This is what
happens in paradigms, where the left and right strings are never
identical, since the right side must contain the grammatical symbols
that will go through all the modules of the system.

\subsubsection{Multiwords with inner inflection}


They consist of a word that can inflect (typically a verb) followed by
one or more invariable words. For these entries you need to specify
the inflection paradigm just after the word that inflects. The
invariable part must be marked with the element \texttt{<g>} (for
\emph{group}) in the right side. The blanks between words are
indicated, like in the previous case, with the element
\texttt{<b>}. Look at the following example for the Spanish multiword
\emph{echar de menos} (to miss), translated into Catalan as
\emph{trobar a faltar}:

\begin{itemize}

\item Spanish monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="echar de menos">
    <\textbf{i}>ech</\textbf{i}>
    <\textbf{par} \textsl{n}="aspir/ar__vblex"/>
    <\textbf{p}>
      <\textbf{l}><\textbf{b}/>de<\textbf{b}/>menos</\textbf{l}>
      <\textbf{r}><\textbf{g}><\textbf{b}/>de<\textbf{b}/>menos</\textbf{g}></\textbf{r}>
    </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\item Catalan monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="trobar a faltar">
    <\textbf{i}>trob</\textbf{i}>
    <\textbf{par} \textsl{n}="abander/ar__vblex"/>
    <\textbf{p}>
      <\textbf{l}><\textbf{b}/>a<\textbf{b}/>faltar</\textbf{l}>
      <\textbf{r}><\textbf{g}><\textbf{b}/>a<\textbf{b}/>faltar</\textbf{g}></\textbf{r}>
    </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\item Spanish-Catalan bilingual dictionary:
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

\end{itemize}


Note that the grammatical symbol is appended at the end, after the
group marked with the \texttt{<g>}.

It can be the case that a lemma is a multiword of this kind in one
language and a single word in the other language. In that case, in the
bilingual dictionary, the multiword will contain the \texttt{<g>}
element and the single word will not. In the monolingual dictionaries,
each entry will be created according to its type.  Look at the
following example for the Spanish multiword \emph{darse cuenta} (to
realize), translated into Catalan as the verb
\emph{adonar-se}:\footnote{The verb \emph{adonar-se} is considered a
simple word, since the incorporation of enclitic pronouns (such as
"-se") is treated inside the inflection paradigms of verbs (for all
the Romance languages of \emph{Apertium}); therefore, it is not
necessary to specify them in lexical entries. The correct placement of
clitic pronouns is one of the main reasons for using the
\texttt{<g>}... \texttt{</g>} labels around the invariable part of
multi-word verbs.}

\begin{itemize}

\item Spanish monolingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e} \textsl{lm}="darse cuenta">
    <\textbf{i}>d</\textbf{i}>
    <\textbf{par} \textsl{n}="d/ar__vblex"/>
    <\textbf{p}>
      <\textbf{l}><\textbf{b}/>cuenta</\textbf{l}>
      <\textbf{r}><\textbf{g}><\textbf{b}/>cuenta</\textbf{g}></\textbf{r}>
    </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\item Catalan monolingual dictionary:
\begin{small}
\begin{alltt} 
<\textbf{e} \textsl{lm}="adonar-se">
    <\textbf{i}>adon</\textbf{i}>
    <\textbf{par} \textsl{n}="abander/ar__vblex"/>
</\textbf{e}>
\end{alltt}
\end{small}

\item Spanish-Catalan bilingual dictionary:
\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>dar<\textbf{g}><\textbf{b}/>cuenta</\textbf{g}><\textbf{s} \textsl{n}="vblex"/></\textbf{l}>
    <\textbf{r}>adonar<\textbf{s} \textsl{n}="vblex"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\end{itemize}

The same principles and actions described for basic entries (gender
and number change, direction restrictions, etc.) apply to all kinds of
multiwords. For a more detailed description of multiword units, refer
to section~\ref{ss:multipalabras}.

\subsection{Consider contributing your improved lexical data}

If you have successfully added general-purpose lexical data to any of
the Apertium language pairs, please consider contributing it to the
project so that we can offer a better toolbox to the community.  You
can e-mail your data (in three XML files, one for each monolingual
dictionary and another one for the bilingual dictionary) to the
following addresses: \\

\begin{tabular}{ll} 
Spanish-Catalan data & Mireia Ginestí: \texttt{mginesti@"@"dlsi.ua.es}\\ 
Spanish-Portuguese data & Carme Armentano: \texttt{carmentano@"@"dlsi.ua.es}\footnote{The group at the
Universitat d'Alacant has also developed data for this language pair
outside the present project.}\\ 
Spanish-Galician data & Xavier Gómez-Guinovart: \texttt{xgg@"@"uvigo.es}\\\\

\end{tabular}


If you believe you are going to contribute more heavily to the
project, you can join the development team through
www.sourceforge.net. If you do not have a Sourceforge account, please
create one; then write to Mikel L. Forcada (\texttt{mlf@"@"ua.es}) or
Sergio Ortiz (\texttt{sortiz@"@"dlsi.ua.es}), or to Xavier Gómez
Guinovart if you are interested in the Spanish-Galician language pair,
explaining briefly your motivations and background to join the
project.  The usual way to contribute is to use CVS; as a project
member, you will be able to commit your changes to dictionaries
directly.

The addition of simple lexical contributions will soon be made simpler
by means of web forms in
\url{http://xixona.dlsi.ua.es/prototype/webform/}, so that
contributors do not have to deal directly with XML.


You should be aware that the data you contribute to the project, once
added, will be freely distributed under the current license (GNU
General Public License or Creative Commons 2.5
attribution-sharealike-noncommercial, as indicated). Make sure the
data you contribute is not affected by any kind of license which may
be incompatible with the licenses used in this project. No kind of
agreement or contract is created between you and the developers. If
you have any doubt, or you plan to make a massive contribution,
contact Mikel L. Forcada.


\section[Adding structural transfer rules]{Adding structural transfer
(grammar) rules}

The content in this chapter partially repeats information already
presented in the chapter describing the structural transfer module
(Section \ref{ss:transfer}), although rules are described here in a
more general and practical way, aimed at those who wish a first
approach to them.

Structural transfer rules carry out transformations to the analysed
and disambiguated text, which are needed because of grammatical,
syntactical and lexical divergences between the two languages involved
(gender and number changes to ensure agreement in the target language,
word reorderings, changes in prepositions, etc.). The rules detect
patterns (sequences) of source text lexical forms and apply to them
the corresponding transformations.  The module detects the patterns in
a left-to-right, longest-match way; for example, the phrase \emph{the
big cat} will be detected and processed by the rule for
\emph{determiner}--\emph{adjective}--\emph{noun} and not by the rule
for \emph{determiner}--\emph{adjective}, since the first pattern is
longer. If two patterns have the same length, the rule that applies is
the one defined in the first place.

The structural transfer module (generated from the structural transfer
rules file) calls the lexical transfer module (generated from the
bilingual dictionary) all through the process to determine the target
language equivalents of the source language lexical forms.

The structural transfer rules are contained in a XML file, one for
each translation direction (for example, for the translation from
Spanish to Catalan, the file is
\texttt{apertium-es-ca.trules-es-ca.xml}). You need to edit this file
if you want to add or change transfer rules.

Rules have a \textbf{pattern} and an \textbf{action} part. The pattern
specifies which sequences of lexical forms have to be detected and
processed. The action describes the verifications and transformations
that need to be done on its constituents. Usual transformation
operations (such as gender and number agreement) are defined inside a
macroinstruction which is called inside the rule.  At the end of the
action part of the rule, the resulting lexical forms in the target
language are sent out so that they are processed by the next modules
in the translation system.

A transfer rules file contains four sections with definitions of
elements used in the rules, and a fifth section where the actual rules
are defined. The sections are the following:

\begin{itemize}

\item \texttt{<section-def-cats>}: This section contains the
  definition of the categories which are to be used in the rule
  patterns (that is, the type of lexical forms that will be detected
  by a certain rule). For the rule presented below, the categories
  \texttt{det} and \texttt{nom} (determiner and noun) need to be
  defined here. Categories are defined specifying the grammatical
  symbols that the lexical forms have. An asterisk indicates that one
  or more grammatical symbols follow the ones specified. The following
  is the definition of the category \texttt{det}, which groups
  determiners and predeterminers\footnote{such as in Spanish
  \emph{todo}, \emph{toda}, \emph{todos}, \emph{todas}} in the same
  category since they play the same role for transfer purposes:

\begin{small}
\begin{alltt} 
<\textbf{def-cat} \textsl{n}="det">
    <\textbf{cat-item} \textsl{tags}="det.*"/>
    <\textbf{cat-item} \textsl{tags}="predet.*"/>
</\textbf{def-cat}>
\end{alltt}
\end{small}

It is also possible to define as a category a certain lemma, like the
following for the preposition \texttt{en}:

\begin{small}
\begin{alltt} 
<\textbf{def-cat} \textsl{n}="en">
    <\textbf{cat-item} \textsl{lemma}="en" \textsl{tags}="pr"/>
</\textbf{def-cat}>
\end{alltt}
\end{small}


\item \texttt{<section-def-attrs>}: This section contains the
definition of the attributes that will be used inside of the rules, in
the action part. You need attributes for all the categories defined in
the previous section, if they are to be used in the action part of the
rule (to make verifications on them or to send them out at the end of
the rule), as well as for other attributes needed in the rule (such as
gender or number). Attributes have to be defined using their
corresponding grammatical symbols and can not have asterisks; its name
must be unique. The following are the definitions for the attributes
\texttt{a\_det} (for determiners) and \texttt{gen} (gender):

\begin{small}
\begin{alltt} 
<\textbf{def-attr} \textsl{n}="a_det">
    <\textbf{attr-item} \textsl{tags}="det.def"/>
    <\textbf{attr-item} \textsl{tags}="det.ind"/>
    <\textbf{attr-item} \textsl{tags}="det.dem"/>
    <\textbf{attr-item} \textsl{tags}="det.pos"/>
    <\textbf{attr-item} \textsl{tags}="predet"/>
</\textbf{def-attr}>

<\textbf{def-attr} \textsl{n}="gen">
    <\textbf{attr-item} \textsl{tags}="m"/>
    <\textbf{attr-item} \textsl{tags}="f"/>
    <\textbf{attr-item} \textsl{tags}="mf"/>
    <\textbf{attr-item} \textsl{tags}="nt"/>
    <\textbf{attr-item} \textsl{tags}="GD"/>
</\textbf{def-attr}>

\end{alltt}
\end{small}

\item \texttt{<section-def-vars>}: This section contains the
definition of the variables used in the rules.

\begin{small}
\begin{alltt} 
  <\textbf{def-var} \textsl{n}="interrogativa"/>
\end{alltt}
\end{small}

\item \texttt{<section-def-macros>}: Here the macroinstructions are
defined, which contain sequences of code that are frequently used in
the rules; this way, linguists do not need to write the same actions
repeatedly. There are, for example, macroinstructions for gender and
number agreement operations.

\item \texttt{<section-def-rules>}: This is the section where the
structural transfer rules are written.

\end{itemize}

The following is an example of a rule which detects the sequence
\emph{determiner--noun}:

\begin{small}
\begin{alltt}
<\textbf{rule}>
  <\textbf{pattern}>
    <\textbf{pattern-item} \textsl{n}="det"/>
    <\textbf{pattern-item} \textsl{n}="nom"/>
  <\textbf{/pattern}>
  <\textbf{action}>
    <\textbf{call-macro} \textsl{n}="f_concord2">
      <\textbf{with-param} \textsl{pos}="2"/>
      <\textbf{with-param} \textsl{pos}="1"/>
    </\textbf{call-macro}>
    <\textbf{out}>
      <\textbf{lu}>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="whole"/>
      </\textbf{lu}>
      <\textbf{b} \textsl{pos}="1"/>
      <\textbf{lu}>
        <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="whole"/>
      </\textbf{lu}>
    </\textbf{out}>
  </\textbf{action}>
</\textbf{rule}>
\end{alltt}
\end{small}

Part of the action performed on this pattern is specified inside the
macroinstruction \texttt{f\_concord2}, which is defined in the
\texttt{<section-def-macros>}. It performs gender and number agreement
operations: if there is a gender or number change between the source
language and the target language (in the noun), the determiner changes
its gender or number accordingly; furthermore, if gender or number are
undetermined (\texttt{GD} or \texttt{ND}\footnote{See pages
\pageref{pg:GD} or \pageref{GDND}}), the noun receives the correct
gender or number values from the preceding determiner. In the Apertium
es--ca, es--gl and es--pt systems, there are agreement
macroinstructions defined for one, two, three or four lexical units
(\texttt{f\_concord1}, \texttt{f\_concord2}, \texttt{f\_concord3},
\texttt{f\_concord4}). When calling the macroinstructions in a rule,
it must be specified which is the main lexical unit (the one which
most heavily determines the gender or number of the other lexical
units) and which other lexical units of the pattern have to be
included in the agreement operations, in order of importance. This is
done with the \texttt{<with-param pos=""/>} element. In the presented
rule, the main lexical unit is the noun (position "2" in the pattern)
and the second one is the determiner (positions "1" in the pattern).

After the pertinent actions, the resulting lexical forms are sent out,
inside the \texttt{<out>} element. Each lexical unit is defined with a
\texttt{<clip>}. Its attributes mean the following:

\begin{itemize}

\item [-]\texttt{pos}: refers to the position of the lexical form in
the pattern; \texttt{1} is the first lexical form (the determiner) and
\texttt{2} the second one (the noun).

\item [-]\texttt{side}: indicates if the lexical form is in the source
language (\texttt{sl}) or in the target language (\texttt{tl}).  Of
course, words are sent out always in the target language; source
language lexical forms may be needed inside of a rule, when testing
its attributes or characteristics.

\item [-]\texttt{part}: indicates which part of the lexical form is
referred to in the \texttt{clip}. You can use some predefined values:

\begin{itemize}

\item [-]\texttt{whole}: the whole lexical form (lemma and grammatical
symbols). Used only when sending out the lexical unit (inside an
\texttt{<out>} element).

\item [-]\texttt{lem}: the lemma of the lexical unit

\item [-]\texttt{lemh}: the head of the lemma of a multiword with
inner inflection (see Section \ref{multi} in this chapter, or
Section~\ref{ss:multipalabras} if you wish a more detailed
description)

\item [-]\texttt{lemq}: the queue of a lemma of a multiword with inner
inflection


\end{itemize}

Apart from these predefined values, you can use any of the attributes
defined in \texttt{<section-def-attrs>} (for example \texttt{gen} or
\texttt{a\_det}).

The values \texttt{lemh} and \texttt{lemq} are used when sending out
multiwords with inner inflection in order to place the head and the
queue of the lemma in the right position, since the previous module
moved the queue just after the lemma head for various reasons. In
practice, in our system, this means that you must use these values
instead of \texttt{whole} when sending out verbs. This is because, in
our dictionaries, multiwords with inner inflection are always verbs
\nota{NEEDS UPDATING}and, if you use the value \texttt{whole} when
sending them out, the multiword would not be well formed (the head and
the queue of the lemma would not have the correct position and the
multiword could not be generated by the generator).

\end{itemize}


Therefore, a rule that has a verb in its pattern must send the lexical
forms like in the following two examples:

\label{regla_verbo1}
\begin{small}
\begin{alltt}
<\textbf{rule}>
  <\textbf{pattern}>
    <\textbf{pattern-item} \textsl{n}="verb"/>
  <\textbf{/pattern}>
  <\textbf{action}>
    <\textbf{out}>
      <\textbf{lu}>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="lemh"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="a_verb"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="temps"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="persona"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="gen"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="nbr"/>
        <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="lemq"/>
      </\textbf{lu}>
    </\textbf{out}>
  </\textbf{action}>
</\textbf{rule}>
\end{alltt}
\end{small}


\label{regla_verbo2}
\begin{small}
\begin{alltt}
<\textbf{rule}>
  <\textbf{pattern}>
    <\textbf{pattern-item} \textsl{n}="verb"/>
    <\textbf{pattern-item} \textsl{n}="prnenc"/>
  <\textbf{/pattern}>
  <\textbf{action}>
    <\textbf{out}>
      <\textbf{mlu}>
        <\textbf{lu}>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="lemh"/>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="a_verb"/>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="temps"/>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="persona"/>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="nbr"/>
        </\textbf{lu}>
        <\textbf{lu}>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="lem"/>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="a_prnenc"/>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="persona"/>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="gen"/>
          <\textbf{clip} \textsl{pos}="2" \textsl{side}="tl" \textsl{part}="nbr"/>
          <\textbf{clip} \textsl{pos}="1" \textsl{side}="tl" \textsl{part}="lemq"/>
        </\textbf{lu}>
      </\textbf{mlu}>
    </\textbf{out}>
  </\textbf{action}>
</\textbf{rule}>
\end{alltt}
\end{small}


The first rule detects a verb and places the queue in the correct
place, after all the grammatical symbols. The lexical unit is sent
specifying the attributes separately: lemma head, lexical category
(verb), tense, person, gender (for the participles), number and lemma
queue.

The second rule detects a verb followed by an enclitic pronoun and
sends the two lexical forms specifying also the attributes separately;
the first lexical unit consists of: lemma head, lexical category
(verb), tense, person and number; the second lexical unit consists of:
lemma, lexical category (enclitic pronoun), person, gender, number and
lemma queue (of the first lexical form). This way, the queue of the
lemma is placed after the enclitic pronoun. The two lexical units
(verb and enclitic pronoun) are sent inside a \texttt{<mlu>} element,
since they have to reach the morphological generator as a multilexical
unit (multiword).


Taking into account what we have explained here, if you want to
\textbf{add a new transfer rule} you have to follow these steps:

\begin{enumerate}

\item Specify which pattern you want to detect. Bear in mind that
words are processed only once by a rule, and that rules are applied
left to right and choosing the longest match.  For example, imagine
you have in your transfer rules file only two rules, one for the
pattern \emph{determiner--noun} and one for the pattern
\emph{noun--adjective}.  The Spanish phrase \emph{el valle verde}
("the green valley") would be detected and processed by the first one,
not by the second. You will need to add a rule for the pattern
\emph{determiner - noun - adjective} if you wish that the three
lexical units are processed in the same pattern.

\item Describe the operations you want to perform on the pattern. In
the Apertium \texttt{es-ca}, \texttt{es-gl} and \texttt{es-pt}
systems, simple agreement operations (gender and number agreement) are
easy to perform in a rule by means of a macroinstruction. To perform
other operations, you will need to use more complicated elements; for
a more detailed description of the language used to create rules,
refer to the section \ref{formatotransfer}.

\item Send the lexical units of the pattern in the target language
inside an \texttt{<out>} element. Each lexical unit must be included
in a \texttt{<lu>} element. If two or more lexical units must be
generated as a multilexical unit (only for enclitic pronouns in the
present language pairs) , they must be grouped inside a \texttt{<mlu>}
element.

All the words that are detected by a rule (that are part of a pattern)
must be sent out at the end of the rule so that the next module (the
generator) receives them. If a lexical unit is detected by a pattern
and is not included in the \texttt{<out>} element, it will not be
generated.


\end{enumerate}


\section[Adding data for the part-of-speech tagger]{Adding data for
the lexical categorial disambiguator (part-of-speech tagger)}

The lexical categorial disambiguator takes the linguistic information
needed to disambiguate a text basically from two sources: a tagset
definition file and corpora. The tagset definition file is contained
in the linguistic data directory and its name has the structure
\texttt{apertium-PAIR.LANG.tsx}, whereas corpora information is
contained in the \texttt{LANG-tagger-data} directory included in the
previous directory.

The \emph{tagset definition file} contains the definition of the
coarse tags (or categories) used by the tagger when being trained and
when disambiguating a text, as well as tag co-occurrence restrictions
that help obtain better tag probabilities. In Section \ref{ss:tagger}
you can find a detailed description of its characteristics.

The \emph{corpora} that need to be in the \texttt{LANG-tagger-data}
directory are different depending on whether the tagger is trained in
a supervised way (with manually disambiguated text) or unsupervised
(without manually disambiguated text):

\begin{itemize}

\item to train the tagger in a supervised way you need the files
(examples from es-tagger-data): \texttt{es.tagged.txt},
\texttt{es.untagged}, \texttt{es.tagged}, \texttt{es.dic}.

\item to train the tagger in an unsupervised way you need the files
(examples from es-tagger-data): \texttt{es.crp.txt}, \texttt{es.crp},
\texttt{es.dic}

\end{itemize}

These files have the following characteristics:

\begin{itemize}

\item \texttt{es.tagged.txt}: A Spanish corpus in plain text format.
\item \texttt{es.untagged}: The corpus \texttt{es.tagged.txt}
morphologically analysed, which means, processed by the de-formatter
and the morphological analyser (automatically generated corpus).
\item \texttt{es.tagged}: The preceding corpus manually disambiguated.
\item \texttt{es.crp.txt}: A large corpus (hundreds of thousands of
words) used when training the tagger in an unsupervised way with
Baum-Welch reestimation.
\item \texttt{es.crp}: The preceding corpus processed consecutively by
the de-formatter and the morphological analyser (automatically
generated corpus).
\item \texttt{es.dic}: File created from the Spanish monolingual
dictionary \texttt{*.es.dix}, by means of the \texttt{lt-expand} and
\texttt{aper\-tium\--fil\-ter\--am\-biguity} tools, which expand the
dictionary and filter the ambiguity classes, so that the file contains
all the forms identified as different ambiguity classes by the tagger
defined with \texttt{*.es.tsx}; that is, which lexical categories can
be homographs (automatically generated corpus).
\end{itemize}

When downloading Apertium from Sourceforge
(\url{http://apertium.sourceforge.net/}), if the tagger has been
trained in a supervised way, it is probable that you get the files
needed for this kind of training, \texttt{es.tagged} and
\texttt{es.tagged.txt} (for Spanish). The other required files are
automatically generated when running the training.  If the tagger has
been trained in an unsupervised way, you will not get any corpus in
the download since the files required for this kind of training are
huge. If you wish to train the tagger with this method, you will need
to collect a large corpus and name it \texttt{es.crp.txt}. The other
required files are automatically generated when running the training.

Anyway, the Apertium translator comes with all the data required for a
good performance of the tagger. You don't need to train the tagger in
order to use Apertium. A retraining might be required in the case that
you have made really extensive changes to the dictionaries or you have
modified the tagset definition file.

Therefore, the tagger data can be modified in two ways:

\begin{enumerate}

\item Change the tagset definition file. You can add, change or delete
the coarse tags used by the tagger, if you think that a new category
could be useful for the disambiguation or that a certain category
should be modified to obtain better results. You can also add
restrictions (for example, you can forbid the sequence
determiner--determiner if this is an impossible combination in a given
language and can help in the disambiguation of certain homograph
words).

\item Modify the corpora used to train the tagger.  You can modify the
manually disambiguated text (\texttt{es.tagged} for Spanish) if you
think that certain tags have been wrongly selected. You can also add
sentences to this text (and to \texttt{es.tagged.txt}, used to automatically
generate the corpus \texttt{es.untagged}) in order to
add information to the tagger, since it is possible that certain
combinations are incorrectly disambiguated because the tagger has not
found them in the training corpora.


\end{enumerate}

There are two commands to run the training:

\begin{itemize}

\item to train in a supervised way, type, in the directory containing
the linguistic data (example for \emph{es}--\emph{ca}): \texttt{make
-f es-ca-supervised.make}


\item to train in an unsupervised way, type, in the directory
containing the linguistic data (example for \emph{es}--\emph{ca}):
\texttt{make -f es-ca-unsupervised.make}


\end{itemize}

In both cases, planned files will be automatically generated.


\section{Detecting errors}
\label{errores}


It is easy to make errors when adding new words or transfer rules to
the Apertium system.

On the one hand, it is possible that, when compiling the new files,
the system displays an error message. In this case, this is a formal
error (a missing XML tag, a tag that is not allowed in a certain
context, etc.).  You just have to go to the line number indicated by
the error message, correct the error and compile again. On the other
hand, there are other types of errors not detected when compiling, but
which can make the system mistranslate a word or give an
incomprehensible text string.  These are linguistic errors, which can
be detected and corrected with the tips given in this chapter. The
following information is for Linux users, since Apertium works for the
moment only in this operating system.\footnote{There are in
\url{http://apertium.org} experimental packages for Windows with fixed
linguistic data (non-modifiable binary files).}

\subsection{Adjusting error symbols}
\label{subsec:marcaserror}

When the system encounters a problem to translate any word of a source
language text, in the default mode the system outputs the problematic
word together with a symbol that indicates that an error has occurred.
The meaning of the different symbols is the following:



\begin{itemize}


\item '\verb!@"@"!': The problem is in the lexical transfer module, which
can not translate the lexical form (the bilingual dictionary does not
contain it)

\item '\verb!#!': The problem has occurred in the generator, which can
not generate the surface form from the input lexical form (the
morphological dictionary does not contain it in the generation
direction)

\item '\verb!/!': This symbol separates two or more surface forms
delivered by the generator. The problem, therefore, is in the target
language monolingual dictionary, which has, in the generation
direction, two surface forms for a single lexical form, when it should
have only one.


\end{itemize}


The generation module has three modes, which enable us to decide how
errors will be displayed in the final output.  The three possible
parameters are:

\begin{itemize}

\item -n : error symbols and the unknown-word symbol will NOT be
displayed, and neither will any grammatical symbols

\item -g : error symbols and the unknown-word symbol will be displayed
(default mode)

\item -d : error symbols and the unknown-word symbol will be
displayed, as well as the grammatical symbols of the lexical forms
producing the error.


\end{itemize}


The preferable mode depends on the type of user and on the translation
purpose. The first option is the most suitable when the user does not
want that external signs interfere in the reading of the
translation. The second option is useful when the user wants the
system to show where there has been a problem in the translation
(errors or unknown words) in order to be able to post-edit it
easily. The third option is ideal for linguistic developers of
Apertium, since it displays all the linguistic information of the
forms that produced an error.

Taking advantage of the error symbols output by the system, it is
possible to carry out a thorough test of the dictionaries of a certain
language pair. This will enable you to detect and correct all its
errors. To learn how to do it, see Section \ref{integridad}.

\subsection{Output of the different Apertium modules}

Sometimes it is difficult to find the origin of an error. In such
cases, it is useful to see the output of each of the modules.  As all
the data processed by the system, from the original text to the
translated text, circulate between the eight modules of the system in
text format, it is possible to stop the text stream at any point to
know what is the input or the output of a certain module.

Using a pipeline structure and the \texttt{echo} or \texttt{cat}
commands, you can send a text through one or more modules to analyse
their output and detect the origin of the error. We describe next how
to do it. You have to move to the directory where the linguistic data
are saved and type the described commands.



\subsubsection{The morphological analyser output}

To know how a word is analyzed by the translator, type the following
in the terminal (example for the Catalan word \emph{sabates}):


\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin
\end{alltt}
\end{small}

You can replace \texttt{ca-es} with the translation direction you want
to test.

The output in Apertium should be:
\begin{small}
\begin{alltt} 
^sabates/sabata<n><f><pl>\$^./.<sent>\$[][]
\end{alltt}
\end{small}

The string structure is
\verb!^!\texttt{word/lemma<}\textsl{morphological
analysis}\texttt{>}\verb!$!. The \texttt{<sent>} tag is the analysis
of the full stop, as every sentence end is represented as a full stop
by the system, whether or not explicitly indicated in the sentence.

The analysis of an unknown word is (ignoring the full stop info):

\begin{small}
\begin{alltt}
^genoma/*genoma\$
\end{alltt}
\end{small}

\noindent and the analysis of an ambiguous word:

\begin{small}
\begin{alltt}
^casa/casa<n><f><sg>/casar<vblex><pri><p3><sg>/casar<vblex><imp><p2><sg>\$
\end{alltt}
\end{small}

Each lexical form (lemma plus morphological analysis) is presented as
a possible analysis of the word \emph{casa}.

\subsubsection{The tagger output}


To know the output of the tagger for a source language text, type the
following in the terminal (example for the Catalan-Spanish direction):

\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob
\end{alltt}
\end{small}

The output will be:
\begin{small}
\begin{alltt} 
^sabata<n><f><pl>\$^./.<sent>\$[][]
\end{alltt}
\end{small}

The output for an ambiguous word will be like the one above, since the
tagger chooses one lexical form among all the
possibilities. Therefore, the output for \emph{casa} in Catalan will
be, for example (depending on the context):

\begin{small}
\begin{alltt} 
^casa<n><f><sg>\$^.<sent>\$[][]
\end{alltt}
\end{small}

\subsubsection{The \texttt{pretransfer} output}

This module applies some changes to multiwords (move the lemma queue
of a multiword with inner inflection just after the lemma head). To
know its output, type:

\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob | apertium-pretransfer
\end{alltt}
\end{small}

Since \emph{sabates} is not a multiword, this module does not alter
its input.

\subsubsection{The structural and lexical transfer output}

To know how a word, phrase or sentence is translated into the target
language and processed by structural transfer rules, type the
following in the terminal:
\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob | apertium-pretransfer \\| ./ca-es.transfer ca-es.autobil.bin
\end{alltt}
\end{small}

The output for this word will be:

\begin{small}
\begin{alltt} 
^zapato<n><m><pl>\$^.<sent>\$[][]
\end{alltt}
\end{small}


Analysing how a word or phrase is output by this module can help you
detect errors in the bilingual dictionary or in the structural
transfer rules. Typical bilingual dictionary errors are: two
equivalents for the same source language lexical form, or wrong
assignment of grammatical symbols. Errors due to structural transfer
rules vary a lot depending on the actions performed by the rules.


\subsubsection{The morphological generator output}

To know how a word is generated by the system, type the following in
the terminal:

\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob | apertium-pretransfer \\| ./ca-es.transfer ca-es.autobil.bin | ltproc -g ca-es.autogen.bin
\end{alltt}
\end{small}

With this command you can detect generation errors due to an incorrect
entry in the target language monolingual dictionary or to a divergence
between the output of the bilingual dictionary (the output of the
previous module) and the entry in the monolingual dictionary.

The correct output for the input \emph{sabates} would be:

\begin{small}
\begin{alltt} 
zapatos.[][]
\end{alltt}
\end{small}

There are in this step no grammatical symbols, and the word appears
inflected.

\subsubsection{The post-generator output}

It is not very usual to have errors due to the post-generator, because
of its generally small size and the fact that it is seldom changed
after adding usual combinations, but you can also test how a source
language text comes out of this module, by typing:

\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob | apertium-pretransfer \\| ./ca-es.transfer ca-es.autobil.bin | ltproc -g ca-es.autogen.bin \\| ltproc -p es-ca.autopgen.bin
\end{alltt}
\end{small}

\subsubsection{The Apertium output}

You can put all the modules of the system in the pipeline structure
and see how a source language text goes through all the modules and
gets translated into the target language. You just have to add the
re-formatter to the previous command:

\begin{small}
\begin{alltt} 
echo "sabates" | apertium-destxt | lt-proc ca-es.automorf.bin \\|apertium-tagger -g ca-es.prob | apertium-pretransfer \\| ./ca-es.transfer ca-es.autobil.bin | ltproc -g ca-es.autogen.bin \\| ltproc -p es-ca.autopgen.bin | apertium-retxt
\end{alltt}
\end{small}

This is the same as using the \texttt{apertium} shell
script provided by the Apertium package:

\begin{small}
\begin{alltt} 
echo "sabates" | apertium . ca-es
\end{alltt}
\end{small}

\noindent (The dot indicates the directory where the linguistic data
are saved, in this case the current directory).

Of course, instead of typing all the presented commands every time you
need to test a translation, you can create shell scripts for every
action and use them to test the output of each module.




\subsection{Error examples}


1) We can get the following kind of output in a translation:

\begin{small}
\begin{alltt} 
\$ echo "nord" | apertium . ca-es 
\$ #norte<n><m><sg>
\end{alltt}
\end{small}

This means that the word was correctly translated by the bilingual
dictionary but that the system does not find it in the Spanish
morphological dictionary to generate it. The problem can be in the
morphological dictionary but can also be caused by an incorrect
bilingual entry, in which the grammatical symbols that the translated
word is assigned do not correspond with the grammatical symbols that
this word has in the morphological dictionary.

2) The following \texttt{es-ca} bilingual entry does not take into
account the gender change between \emph{adhesiu} (masculine) and
\emph{pegatina} (feminine), causing the translator to give an error:

\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>pegatina<\textbf{s} \textsl{n}="n"/></\textbf{l}>
    <\textbf{r}>adhesiu<\textbf{s} \textsl{n}="n"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

\begin{small}
\begin{alltt} 
\$ echo "adhesiu" | apertium . ca-es 
\$ #pegatina<n><m><sg>
\end{alltt}
\end{small}

The correct entry should be:

\begin{small}
\begin{alltt}
<\textbf{e}>
  <\textbf{p}>
    <\textbf{l}>pegatina<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="f"/></\textbf{l}>
    <\textbf{r}>adhesiu<\textbf{s} \textsl{n}="n"/><\textbf{s} \textsl{n}="m"/></\textbf{r}>
  </\textbf{p}>
</\textbf{e}>
\end{alltt}
\end{small}

3) The following error is given when the source language lexical form
can not be found in the bilingual dictionary, either because there is not an entry for this
lemma or because the entry does not correspond with the grammatical
symbols received from the analyser:


\begin{small}
\begin{alltt} 
\$ echo "illot" | apertium . ca-es 
\$ @"@"illot<n><m><sg>
\end{alltt}
\end{small}

4) When a source language lexical form has two correspondences in the
bilingual dictionary, the translator output is like the following one:

\begin{small}
\begin{alltt} 
\$ echo "llavor" | apertium . ca-es 
\$ #pepita<n>/semilla<n><m><sg>
\end{alltt}
\end{small}

The solution is to put a direction restriction in one of the bilingual
entries.


Some errors can be due to structural transfer rules. The way to solve
a problem whose origin we don't know, is to test the output of the
different modules to detect where the problem arises.

\subsection{Testing the integrity of the
dictionaries}\label{integridad}

It is highly advisable to test the integrity of our dictionaries from
time to time, especially if we changed them significantly --or if we
changed the transfer rules, because some errors can be due to its
application.

The test is carried out in one translation direction. For this reason,
for a given language pair, you will have to perform two tests, one in
each direction.

The steps you have to follow to perform the test are:

\begin{itemize}

\item expand the source language monolingual dictionary, using the
\texttt{lt-expand} tool, to obtain all the lexical forms (which are
the forms that appear on the right of the colon in the output file);

\item send these lexical forms (except those that are only generation
forms, which \texttt{lt-expand} will have marked with the symbol
'\texttt{<}' ) through all the system modules from pretransfer to the
generator;

\item Search in the result, the lexical forms marked with the symbols
'\texttt{\#}' , '\texttt{@"@"}' or '\texttt{/}', which will be the error
forms (see Section~\ref{subsec:marcaserror}).


\end{itemize}




\section{Generating a new Apertium system from modified data}

If you make changes to any of the linguistic data files of Apertium
(dictionaries, transfer rules or tagger definition file), the changes
will not be applied until you recompile the modules. To do this, type
\texttt{make} in the directory where the linguistic data are saved so
that the system generates the new binary files.

If changes were made to the tagger definition file or to the corpora
used to train the tagger, you will need also to retrain the tagger: in
the same linguistic data directory, you have to type (example for the
Spanish tagger in the es-ca translator) \texttt{make -f
es-ca-unsupervised.make} for unsupervised training or \texttt{make -f
es-ca-supervised.make} for supervised training.

After compilation, \texttt{apertium} will already use the
new data.
