#lang scribble/manual

@(require scriblib/figure)

@title[#:tag "data-insertion" #:version "3.5.2"]{Data insertion web forms}

This chapter describes the dictionary maintaining system in Apertium
2.  It is organized in two sections.  Section \ref{ss:formadmin} gives
the necessary information to install and adjust the web application
for word insertion.  Section \ref{ss:formus} describes how to use the
tool to add linguistic data.


\section{Introduction}

Adding lemmas to the dictionaries of the different languages in
Apertium is a slow task if you do it by manually editing the XML
dictionaries; for this reason web forms have been created, which make
the word insertion task considerably easier and, furthermore, allow
the users to do it remotely from any computer with Internet access.

The tool consists of a set of forms written in \texttt{php} which can
be used from any Internet navigator, either locally in the same
computer where dictionaries are saved, or remotely.

\section{Installing and managing}
\label{ss:formadmin}

\subsection{Installing the tool}

The installation must be done in a Unix machine which has an Apache
web server with \texttt{php} installed. So, you will first need to
install the \texttt{php} server if it is not installed, and then
proceed to install the form tool.


To install the tool, download the package
\textit{`apertium-lexical-webform-0.9'} from the Apertium web page in
Sourceforge (\url{http://apertium.sourceforge.net/}) and unpack it in
the directory where you want to leave the tool.


\begin{alltt}
   # cd /path/to the /forms tar -xvzf
   # /path/apertium-lexical-webform-0.9.tar.gz
\end{alltt}

You must take into account that Apache only serves the pages that are
in the root directory that we configured. Therefore, the directory
where you place the forms must be a subdirectory inside the root
directory of the Apache server.

Next, you have to edit the configuration file, which you can find in
\textit{private/config.php}, and give the appropriate values to the
configuration variables:

\begin{itemize}
\item \texttt{\$anmor}: entire path of the morphological analyser
\texttt{lt-proc}.
\item \texttt{\$dicos\_path}: path to the directory where the final
dictionaries and the compiled binaries of each dictionary are
saved. This directory must contain a subdirectory for each dictionary
with which the form can work. The subdirectory name must have the
following structure: \texttt{paradigmes-ll-rr} , where \textit{ll} and
\textit{rr} are the initials of the language pair involved. Each
directory must contain the final dictionaries used by the machine
translation system and the corresponding compiled binaries.  These
directories can be replaced with symbolic links in the case that they
are located in a different place.
\item \texttt{\$usuaris\_professionals}: a list of the professional
users in the system that have permission to insert words in the form
dictionaries and to validate entries pending confirmation.
  
\item \texttt{\$mail}: E-mail address of the administrator of the
forms. When someone wants to register as a user, an e-mail will be
sent to this address.
\end{itemize}

Once the parameters of this file have been configured, the forms
server is already in use.


\subsection{Directory structure}

All the files required by the application are structured as follows:

\begin{itemize}
\item \texttt{/index.php:} displays the initial insertion form.  It
has a section for each language pair, where the user inserts the SL
lemma and the TL lemma and chooses the appropriate part of
speech. After pressing the \textit{'Go on'} button, the next page is
displayed, where the user has to select the appropriate inflection
paradigms for the SL lemma and the TL lemma.
\item \texttt{/dics:} directory that contains the dictionaries with
the entries inserted from the forms. It contains the files with the
entries from non-professional users (pending validation) and the
dictionaries with the \texttt{XML} entries from professional users.
\item \texttt{/private:} most modules used in the forms are saved
here. It contains also the directories with the definition of
paradigms for all the languages of the forms; these directories have
the name \texttt{paradigmes-ll-rr}, where \textit{ll} and \textit{rr}
are the initials of a given language pair. The order chosen for the
two languages, first \textit{ll} and then \textit{rr}, depends on the
order defined for entries in the bilingual dictionary. This directory
contains also the files that carry out the whole processing of the
words being inserted.  These files are:
\begin{itemize}
\item \texttt{resultado.php: } This \textit{php} is called when two
  words for any language pair are inserted from the module
  \textit{index.php}. Basically, what it does is to establish the
  language pair involved (\textit{\$LR} and \textit{\$RL}) and the
  part of speech of the words being inserted (\textit{\$tipus}). It is
  included in the \textit{selec.php} module, that is the next one
  called in the insertion process. In the case that the \textit{tipus}
  (\textit{type}) of the word being inserted is a multiword unit
  (\textit{Multi Word Verb}), then \textit{multip.php} is the module
  included and called instead of \textit{selec.php}. The \textit{Multi
  Word Verb} elements consist of a verb that can inflect followed by
  an invariable queue of one or more words (see Section
  \ref{ss:multipalabras} for a detailed description).
\item \texttt{selecc.php: } This module is in charge of the selection
of paradigms for the pair of words, the SL word and the TL word. It
displays a list of paradigms to be chosen from, which depends on the
part of speech of the entry being inserted. When a new paradigm is
selected for a lemma, it displays some examples of inflected forms of
the lemma according to the chosen paradigm. If the user accepts the
chosen paradigms, the module calls \textit{insertarPro.php} or
\textit{insertar.php} depending on whether the user is professional or
non-professional respectively.
\item \texttt{multip.php: } It has the same function as the
\textit{selecc.php} module but for multiword units. It uses the same
variables and performs the same actions, but in the examples
displayed, the verb is inflected and the words of the queue are added
after it. It works in an analogous way as the \textit{selecc.php}
module, whose detailed description can be found in Section
\ref{ss:fitxersphp}.
\item \texttt{valida.php: } This module is called when a professional
  user wants to validate words that are in the queue of entries
  pending validation. It consults the file of words to be validated
  reading them one by one; it takes the data of the entry in turn
  (\textit{LRlem, RLlem, paradigmaLR, paradigmaRL, LR, RL}, etc.) and
  calls \textit{selecc.php} to continue with the insertion process of
  that specific entry.
\item \texttt{insertarPro.php: } This module is called when the
paradigms for the SL word and the TL word have already been selected
(which was done in \textit{selecc.php}), and displays what the
resulting \texttt{XML} entries will look like for the three
dictionaries (SL monolingual, bilingual and TL monolingual) . From
this screen it is possible to directly modify the code, and finally to
accept the new entry or to cancel the operation.
\item \texttt{ins\_multip.php: } It has the same function as
\textit{insertarPro.php} but it is designed for multiword entries,
therefore, the entry is treated differently so that the inserted
\texttt{XML} code is correct.
\item \texttt{insertar.php: } This module is equivalent to
\textit{insertarPro.php} but for non-professional users. The actions
it performs are much more simple, since the module just adds the
lemmas and the paradigms selected by the non-professional user to the
file of words to be validated; they remain in this file until a
professional user validates them.
\item \texttt{verSemi.php: } This module displays the file of entries
inserted by non-professional users which are waiting for
validation. It is useful for professional users who, before starting
validating words, want to see which words are in the queue waiting for
validation. It can be called from a link displayed in the form
generated by \textit{selec.php}.
\item \texttt{paradigmas.xsl:} Style sheet used to generate the
paradigm files that are used by the form modules. It is used with the
specification of paradigms of a language written in \texttt{XML}
format. This question will be explained in more detail in Section \ref{paradigm}
\textit{Paradigm files}.
\item \texttt{creaparadigma.awk:} \texttt{awk} file used also to
generate the mentioned paradigm files.
\item \texttt{gen\_paradig.sh:} Script that can be used if we want to
generate automatically the paradigm files for all the language pairs
installed in our system.
\end{itemize}
\end{itemize}

In the next sections you will find a detailed description of the tasks
of each module.

\subsection{Php files}

\subsubsection{resultado.php}

Depending on the value of the variable \texttt{\$nomtrad} updated by
\textit{index.php}, the module assigns the appropriate values to
\texttt{\$LR} and \texttt{\$RL} (source language and target language
respectively). Then, according to the part of speech of the word being
inserted, the variable \$tipo is assigned the appropriate value, and
then \textit{selec.php} or \textit{multip.php} are called depending on
whether the word is a simple unit or a multiword unit.  \nota{MG:
``asignamos'' i ``llamamos'' no seria més aviat ``se asigna'' y ``se
llama''?}

\subsubsection{selecc.php}
\label{ss:fitxersphp}

The function of this module is the selection of a paradigm for the
words being inserted. The user will have to select a paradigm for the
SL word and another one for the TL word.

There are a group of variables which, depending on the part of speech
of the word, are assigned certain values that will be used at the end
\nota{MG: "que darrerament s'utilitzaran" vol dir 'que s'utilitzaran
al final'?}; these variables are:
\begin{itemize}
\item \texttt{cadFich:} part of speech of the lemma.
\item \texttt{show:} string displayed in the form that indicates the
part of speech of the word being inserted.
\item \texttt{tag:} string with the \texttt{XML} tag output by the
morphological analyser for this part of speech.
\item \texttt{tagout:} string with the \texttt{XML} code that shows
the part of speech of the word. This string will be used when building
the final \texttt{XML} entry that will be inserted in the dictionary.
\item \texttt{nota:} string with possible comments to be inserted in
the \texttt{XML} code of the entry.
\end{itemize} Forms work with 4 kinds of dictionaries:
\begin{itemize}
\item \textit{Semi-professional dictionaries}: They contain the words
inserted from the form by non-professional users and which are pending
validation. Their extension is "\textit{semi.dic}"
\item \textit{Form dictionaries}: They contain the words inserted from
the form by professional users, and also the ones that have been
validated from the semi-professional dictionaries. Their extension is
"\textit{webform}".
\item \textit{Final dictionaries}: The files with all the entries
written in \texttt{XML} code. These are the files finally used by the
translator after being compiled. Their extension is "\textit{dix}".
\item \textit{Final compiled dictionaries}: These are the compiled
final dictionaries, which can already be used by the binaries of the
translator. Their extension is "\textit{bin}"
\end{itemize}

All these dictionaries are used by the forms; there are variables that
contain the paths to them. Values are also assigned to variables that
manage the paths to the auxiliary and the configuration files:
\begin{itemize}
\item \texttt{path:} path to the temporary dictionaries.
\item \texttt{fich\_LR:} source language dictionary with the words
inserted from the form that are not yet in the final dictionary nor in
the compiled dictionary.
\item \texttt{fich\_RL:} target language dictionary with the words
  inserted from the form that are not yet in the final dictionary nor
  in the compiled dictionary.  \nota{MG: I don't like speaking of SL and
    TL dictionaries, entries are for both directions, I think this is
    confusing. It should be changed in the whole chapter.}
\item \texttt{fich\_LRRL:} bilingual dictionary with the words
inserted from the form that are not yet in the final dictionary nor in
the compiled dictionary.
\item \texttt{fich-semi:} entries inserted from the form by
non-professional users and which are pending validation.
\item \texttt{path\_paradigmasLR:} path to the files that contain the
inflection paradigms of the source language.
\item \texttt{path\_paradigmasRL:} path to the files that contain the
inflection paradigms of the target language.
\item \texttt{anmor:} path to the morphological analyser.
\item \texttt{aut\_LRRL:} path to the bilingual binary from source
language to target language.\nota{MG: the original said "binario
morfológico", I think it's an error, I wrote 'bilingual binary'}
\item \texttt{aut\_RLLR:} path to the bilingual binary from target
language to source language.\nota{MG: ídem ("bilingual").}
\end{itemize}

Then the html code is inserted with the operations to be performed
depending on the selected action. The actions performed by the module
are the following, in sequential order:

\begin{itemize}
\item Tests that the source language lemma being inserted is not
already in the dictionaries containing the words inserted from the
form. If \texttt{selecc.php} has been called from the word validation
screen (\texttt{valida.php}), then the module tests that the lemma is
not already in the file of words inserted by non-professional
users. It tests this also in the final dictionary.
\item Performs the same test for the target language.
\item Code is written to select translation direction restrictions.
\item A series of functions are defined, which will be used when
generating the examples for the lemmas after the selection of the
appropriate paradigm. These are:
  \begin{itemize}
  \item \texttt{esVocalFuerte}
  \item \texttt{esVocalDebil}
  \item \texttt{esVocal}
  \item \texttt{PosicioVocalTall}
  \end{itemize} These functions are described later in section
  \ref{insertarpro}.
\item The paradigm file is opened to display a drop-down box with the
paradigms that can be selected for the source language lemma. To do
this, the program has to test sequentially the paradigms defined for
the part of speech of the lemma, checking whether the paradigm can be
applied to the lemma in question.
\item Then the same is done with the paradigms for the target language
lemma.
\item After the lemmas and the corresponding paradigms have been
  selected, examples must be generated to show how these lemmas would
  be inflected according to the selected paradigms. To do this, we
  need the root of the lemma (\texttt{raiz\_LR and raiz\_RL}), as well
  as the example endings for the selected paradigm
  (\texttt{paradigma\_LR and paradigma\_RL}); these endings are
  obtained from the paradigm file. Finally, a string is build
  containing the generated examples (\texttt{ejemplos\_LR and
  ejemplos\_RL}), and these are displayed.
\item If we arrived to this screen because we were validating words
(\texttt{va\-li\-da=1}), then a button is added to the form, which
allows us to delete the current entry if we decide not to validate it.
\item If the user that arrived to this screen is a professional user,
then a button is added to the form, which allows the user to select
the option for the validation of words entered by non-professional
users.
\item Finally, after one of the action buttons located at the bottom
of the form is pressed, the applicable actions are performed. If the
chosen action is \textit{"Delete"}, which can only be the case if the
user is validating entries, the current entry is deleted from the file
of entries made by non-professional users.  If the chosen action is a
confirmation (\textit{"Go on"} button), the module
\texttt{insertarPro.php} or \texttt{insertar.php} is called, depending
on whether the user is professional or non-professional respectively.
These modules are in charge of inserting the words in the
dictionaries.
\end{itemize} After the entry has been inserted, the page
\texttt{va\-li\-dar.php} or the page \texttt{selecc.php} are displayed
again, depending on whether the user was doing a validation process
(and then \textit{valida=1}) or a normal insertion.

\subsubsection{multip.php}

The code and behaviour of this module is the same as
\textit{selecc.php}.  The only difference is that this module is
designed for managing multiword units, whereas \textit{selec.php}
manages the rest of units. Therefore, the main difference is the
existence of the variables \texttt{\$LRcua} and \texttt{\$RLcua},
which contain the invariable queue that comes after the variable part
of a multiword. When the examples are displayed, besides showing the
variable part inflected according to the selected paradigm, also and
editable text box is displayed with the invariable queue.

When the button to continue with the insertion of the entry in the
dictionaries is pressed, the module \textit{ins\_multip.php} is called
instead of \textit{insertarPro.php}.


\subsubsection{valida.php}

This module is called when a professional user presses the button
"\textit{validate pairs}". It reads the dictionary of entries pending
validation (\$fichSemi) for the applicable language pair. Then, the
module enters a loop that goes through this file and reads the entries
one by one. With the information of a given entry, it assigns values
to a set of variables that will be used in the modules that will
perform the subsequent actions. These variables are, for example:
\begin{center} 
% use packages: array
\begin{tabular}{ll} 
\$LRlem & \$RLlem \\ 
\$paradigmaLR & \$paradigmaRL \\ 
\$direccions & \$tipo \\ 
\$comentarios & \$user \\ 
\$geneLR & \$geneRL \\ 
\$numLR & \$numRL \\ 
\$LR & \$RL
\end{tabular}
\end{center}

Once the appropriate values for these variables have been established,
the module \textit{selec.php} comes into action and treats the entries
as if they were made by a professional user. After inserting the
entries in the dictionaries by means of \textit{insertarPro.php}, the
flow returns to \textit{valida.php}, which proceeds to the next entry
to be validated.

\subsubsection{insertarPro.php}
\label{insertarpro}

After the lemmas have been entered and their paradigms selected in
\textit{selec.php}, this is the module that generates the
corresponding \texttt{XML} entries and inserts them in the monolingual
dictionaries and the bilingual dictionary.

It performs many operations similar to those performed in
\textit{selec.php}, such as generating the examples for the inflected
word. Thus, firstly, it gives values to \texttt{cadFich, show, tag,
tagout, nota} depending on the part of speech (\texttt{\$tipus}) of
the word being inserted.  It assigns paths to the file location
variables and defines some required functions as occurred in
\textit{selec.php}.
\begin{itemize}
\item \texttt{esVocalFuerte}: Returns \textit{true} if the vowel is
strong, that is, \textit{a, e, o}.
\item \texttt{esVocalDebil}: Returns \textit{true} if the vowel is
weak, that is \textit{i, u}.
\item \texttt{esVocal}: Returns \textit{true} if the character passed
as an argument is a vowel.
\item \texttt{diptongo}: Returns \textit{true} if the two letters
passed as an argument make a diphthong. This will be the case when at
least one of the two vowels is not strong.
\item \texttt{acentuar}: It receives a text string and accentuates it
according to the Spanish accentuation rules, depending on the
parameter \textit{\$siguienteletra}. \nota{MG: only for Spanish?}
\item \texttt{esMayuscula}: Returns \textit{true} if the character is
in upper case.
\item \texttt{TieneAcento}: Returns \textit{true} if the string has an
accent.
\item \texttt{acentua}: Accentuates the last accentuable vowel of a
word with an open or closed accent, depending on the direction
specified in the parameter \$sentit.\nota{MG: then not only for
Spanish but also for Catalan or Occitan?}
\item \texttt{PonQuitaAcento}: Inserts or removes the accent of the
first string passed as an argument depending on whether the second
string passed as an argument has an accent or not.
\item \texttt{PosicioVocalTall}: Returns the position in the lemma
(\$lema) for the vowel (\$vocal) that separates the root from the
ending. The vowel is searched from the end to the beginning and the
first occurrence of \$vocal is returned.
\end{itemize}

Now, the same operations as in \textit{selec.php} are
performed. Firstly, it makes sure that the entry is not yet in the
dictionaries, and then generates the examples of the word inflected
according to the paradigm previously selected. After this, it builds
the string with the \texttt{XML} code that is going to be inserted in
the source language monolingual dictionary. With the information on
the lemmas entered in \textit{selec.php}, a text string is generated
(\texttt{\$cad\_LR}) that contains the \texttt{XML} code for the
monolingual dictionary. This string is displayed in a text box that
can be manually edited. The same process is done to generate the
string for the target language monolingual dictionary
(\texttt{\$cad\_RL}) and for the bilingual dictionary
(\texttt{\$cad\_bil}). Then, the
possible comments and the name of the user making the entry are
concatenated to these variables, if applicable.  Finally, the form
screen is completed adding the buttons for accepting, deleting and going
back.  The code to process each one of the possible actions is at the
end of the file:
\begin{itemize}
\item \texttt{Insert: } In this case, it makes some character
  replacements so that the entry has the right format in the
  dictionaries, and inserts the strings \texttt{\$cad\_LR, \$cad\_bil,
  \$cad\_RL} in the source monolingual, bilingual and target
  monolingual dictionaries respectively (\texttt{\$fich\_LR,
  \$fich\_LRRL, \$fich\_RL}). If some error occurs when inserting the
  entry, a warning message is displayed. If \textit{insertarPro.php}
  was called from a word validation process (\textit{\$valida=1}),
  then the button "\textit{Continue}" is inserted to continue with the
  validation. If this is not the case, then a button to close the
  window is inserted, to allow the user to end the process.
\item \texttt{Delete: } It deletes the entry from the file of entries
pending validation.
\end{itemize}

\subsubsection{ins\_multip.php}

It performs the same actions as \textit{insertarPro.php} but it is
intended for multiword units. The main difference is the existence of
two additional variables, \texttt{\$LRcua} and \texttt{\$RLcua}, that
contain the invariable part of a multiword. When the entry is added to
the dictionaries, this queue has to be inserted in the right place and
the blanks have to be turned into \texttt{<b/>} tags.

\subsubsection{insertar.php}

The function of this module is very simple. It builds a text string
with the information provided by \textit{selec.php} separated by
tabs. This string contains all the required information to generate a
dictionary entry:

\texttt{\$LRlem.\$RLlem.\$paradigmaLR.\$direccion.\$paradigmaRL.}


\texttt{\$tipo.\$comentarios.\$user.\$geneLR.\$geneRL.}

 

This entry is saved in a file (\$fichSemi) that contains the queue
with the entries waiting for validation inserted by non-professional
users. When a professional user wishes to validate pending entries,
the \textit{valida.php} module will read from this file.


\subsubsection{verSemi.php}

It displays the file of entries waiting for validation, in this way:
it reads the file containing the entries (\textit{\$fichSemi}) and
enters a loop that reads all the entries of the file. For each entry,
it displays a line with the following information:

\texttt{\$LRlem
\$paradigmaLR
\$direccion
\$RLlem}

\texttt{\$paradigmaRL
\$tipo
\$comentarios}

\subsection{Dictionary files}

The files containing the entries inserted from the form are saved in
\texttt{/dics}. There are here two kinds of files:

\begin{itemize}
\item \texttt{apertium-ll-rr.xx.webform}: This is the file that
contains the entries in \texttt{XML} code, ready to be copied to the
final dictionaries. The name of the file has the presented structure,
where \texttt{ll-rr} are the initials of the language pair of the
translator and \texttt{xx} the initials of the language of the
monolingual dictionary or the languages of the bilingual dictionary
referred to, as applicable. For example, the initials of the
Spanish-Catalan translator are \texttt{es-ca}. For this translator, we
have the Spanish monolingual (\texttt{es}), the Catalan monolingual
(\texttt{ca}) and the bilingual (\texttt{es-ca})
dictionaries. Therefore, this directory will contain the following
files for the Spanish-Catalan translator:
\begin{center} \texttt{apertium-es-ca.es.webform
apertium-es-ca.ca.webform apertium-es-ca.es-ca.webform}
\end{center}


\item \texttt{oo-mm.semi.dic}: This is the file containing the entries
pending validation for a given language pair. \texttt{oo-mm} are the
initials of the pair. For example, for the Spanish-Catalan translator
this file would be: \texttt{es-ca.semi.dic}


\end{itemize}

\subsection{Paradigm files}
\label{paradigm}

The paradigms used for each language pair are specified in two
\texttt{XML} files named \texttt{paradig.ll-rr.xx.xml}, where
\texttt{xx} are the initials of the language and \texttt{ll-rr} the
initials of the language pair. These files consist of a set of entries
describing the paradigms or inflection models for the words of a given
language. The \texttt{XML} file has the following parts:
\begin{itemize}
\item Head/root of the specification file.\\
\begin{alltt} 
<?xml version="1.0" encoding="ISO-8859-1"?>
<?xml-stylesheet type="text/xsl" href="paradigmas.xsl"?>
<!DOCTYPE form SYSTEM "form.dtd">
<form lang="oc" langpair="oc-ca">
\end{alltt} 
The \textit{lang} attribute states the initials of the
language for which paradigms are specified, and the \textit{langpair}
attribute states the initials of the language pair of the translator
for which the specification is made. It is required that the same
directory containing the paradigm files contains the \texttt{form.dtd}
file, which is the DTD specifying these files. You can find this DTD
in the Appendix \ref{ss:dtdparadigmes}.
\item A set of elements that define the paradigms. To explain its
format, we reproduce the following example: \\
\begin{alltt}
<entry PoS="adj" nbr="sg_pl" gen="mf">
        <endings>
                <stem>amable</stem> 
                <ending/>
                <ending>s</ending>  
        </endings>
        <paradigms howmany="1">
                <par n="amable\_\_adj"/>
        </paradigms>
</entry>
\end{alltt} 
Each paradigm is specified in a \texttt{<entry>} element.
This element can have three attributes:
  \begin{itemize}
  \item \textit{PoS}: the part of speech of the paradigm. It can take
  the values: acr, adj, adv, noun, pname, pr, verbo. \nota{also
  cnjadv?} It is mandatory for any part of speech.
  \item \textit{nbr}: the numbers admitted by the paradigm. It can
  take the values: sg, pl, sg\_pl, sp.
  \item \textit{gen}: the genders admitted by the paradigm. It can
  take the values: m, f, m f, mf.
  \end {itemize} It has two more elements:
  \begin{itemize}
  \item \texttt{endings}: the root and the endings used to select the
  paradigm in the form and display the inflection examples.
    
  \item \texttt{paradigms}: specification of the paradigm/s that
  define the inflection of an entry.  It requires the attribute
  \textit{howmany} , which specifies the number of paradigms used by
  an entry. Each used paradigm is indicated in a line, where the name
  of the paradigm in the dictionary is inserted according to this
  format:
    \begin{center}
\begin{alltt} 
<par n="long\_\_adj"/>
\end{alltt}
    \end{center}
  \end{itemize}
\end{itemize}

From the \texttt{XML} paradigm file, it is necessary to generate the
files directly used by the modules of the forms. Running the script
\texttt{/private/gen\_paradig.sh}, the process is automatically done
for all the available language pairs:
\begin{alltt}
   #  cd private 
   # ./gen\_paradig.sh
\end{alltt} 
To add a new paradigm to the forms, an appropriate entry
has to be added to the \texttt{XML} paradigm file, and then run the
previous script to update the working files.

The automatic process can also be done manually if we do not want to
update the files for all the installed language pairs. The manual
generation of the working files has to be done with a \texttt{XSL}
style sheet using the following command:
\begin{alltt}
   # xsltproc paradigmas.xsl paradigm\_file.xml
                                     | ./creaparadig.awk
\end{alltt}

This action generates a working file for each part of speech. The
generated files are saved in the directories
\texttt{/private/paradigmas.ll-rr}.  These directories contain the
files with the paradigms that can be used for each language pair
\texttt{ll-rr} and for each part of speech.  Each one of these
directories contain the following files:
\begin{itemize}
\item \texttt{paradigacr\_xx}: paradigms for acronyms in the language
\texttt{xx}.
\item \texttt{paradigadj\_xx}: paradigms for adjectives in the
language \texttt{xx}.
\item \texttt{paradigadv\_xx}: paradigms for adverbs in the language
\texttt{xx}.
\item \texttt{paradigcnjadv\_xx}: paradigms for adverbial conjunctions
in the language \texttt{xx}.
\item \texttt{paradigcnjcoo\_xx}: paradigms for copulative
conjunctions in the language \texttt{xx}.\nota{MG: aquesta no està en
la pàgina web del formulari}
\item \texttt{paradigcnjsub\_xx}: paradigms for subordinating
conjunctions in the language \texttt{xx}.\nota{ídem}
\item \texttt{paradignoun\_xx}: paradigms for nouns in the language
\texttt{xx}.
\item \texttt{paradigpname\_xx}: paradigms for proper nouns in the
language \texttt{xx}.
\item \texttt{paradigpr\_xx}: paradigms for prepositions in the
language \texttt{xx}.
\item \texttt{paradigverb\_xx}: paradigms for verbs in the language
\texttt{xx}.
\end{itemize}

The files consist of one entry per line. Each entry contains the
following information:

\begin{center} % use packages: array
\begin{tabular}{lllll} 
\textit{examples} & \textit{number of paradigms} & \textit{model\_paradigms} & \textit{(numbers)} &
\textit{(genders)}
\end{tabular}
\end{center}


The separator used for the different parts of an entry is the tab.
\begin{itemize}
\item \textit{Examples}: the endings that will be used to generate the
examples when the user chooses this paradigm as a model for the word
being inserted.
\item \textit{Number of paradigms}: the number of paradigms that are
used in the dictionary to inflect this inflection model.
\item \textit{Model paradigms}: the name that have in the dictionary
the paradigm/s that will be used to inflect a new entry.
\item \textit{(Numbers)}: Only completed for names, adjectives and
acronyms.  Refers to the grammatical number in the paradigm.
\item \textit{(Genders)}: Only completed for names, adjectives and
acronyms.  Refers to the grammatical gender in the paradigm.
\end{itemize}

So, therefore, for the Spanish-Catalan translator we would have the
directory \texttt{/private\-/paradigmas.es-ca} that would contain two
\texttt{XML} files: \texttt{paradig.es-ca.es.xml} and
\texttt{paradig.es-ca.ca.xml}, specifying the paradigms used in each
language. From these files, you may generate all the paradigm files
for the language pair using the command:
\begin{alltt}
   #  cd private/paradigmas.es-ca
   #  xsltproc ../paradigmas.xsl paradig.es-ca.es.xml 
                                    | ../creaparadig.awk
   #  xsltproc ../paradigmas.xsl paradig.es-ca.ca.xml 
                                    | ../creaparadig.awk
\end{alltt}


Or you can automatically generate them for all the language pairs,
using:
\begin{alltt}
   #  ./private/gen\_paradig.sh
\end{alltt}

Among the generated working files, one would be, for example, a file
called \texttt{paradigverb\_ca} that would contain the possible verb
paradigms for Catalan, where a possible line might be:

\begin{center} 
\texttt{abra/çar /ço /ci        1       abalan/çar\_\_vblex}
\end{center}

that is generated from the \texttt{XML} entry:

\begin{alltt}
<entry PoS="verb">
        <endings>
                <stem>abra</stem> 
                <ending>çar</ending>  
                <ending>ço</ending> 
                <ending>ci</ending>
        </endings>
        <paradigms howmany="1">
                <par n="abalan/çar\_\_vblex"/>
        </paradigms>
</entry>
\end{alltt}



\section{Using the forms}
\label{ss:formus}
\subsection{Introduction}


 When a user wants to insert new entries in a
dictionary, he/she has to use a web navigator to connect to the
address where the form server has been installed; for example:
\begin{center} \texttt{http://xixona.dlsi.ua.es/forms}
\end{center} A web page will be displayed with the portal of access to
\texttt{Opentrad\- Apertium\- Insertion\- Form}. The left margin
contains links to get more \textit{information} , \textit{download}
the programs and \textit{contact} the administrator of the forms to
request registration as a system user. To register as a user you will
have to send an e-mail to the administrator.

\nota{Canviar a tot arreu \emph{registrar} per \emph{inscribir}.}  To
insert new words, you will have to introduce the required data in the
form and press the \textit{'Go On'} button; at this point you will
have to identify yourself as a registered user, or else you will not
be able to continue. There are two user registration types: you can be
registered as a \emph{professional} or as a \emph{non-professional}
user. Each mode has different functionalities, that are explained in
the following section.

\subsection{Insertion of entries}
\label{insertion}

\subsubsection{Professional mode}

If you want to add a new entry to the dictionaries, you have to go to
the section of the language pair you want to improve. There, you have
to enter the source language lemma and the target language lemma, and
select their part of speech. Press the \textit{Go on} button to
continue.

A new window is displayed, with the lemmas and some parameters used to
define the entries. If the entry already exists in one of the
dictionaries, a warning message is displayed and the system automatically
selects one-way translation (from left to right or vice versa). If
none of the dictionaries contain the entry, the entry will be entered
for both directions.

In this window you can do three actions:

\nota{Cal repassar la primera oració del paràgraf següent;
sembla que hi ha algun material que hauria de ser esborrat; Una altra
cosa, els formularis en l'actualitat no tenen suport per a traduccions
múltiples, segons sembla. Caldria fer constar aquesta circumstància en
algun lloc.}
\begin{itemize}
\item Choose the paradigm for the SL and the TL lemmas (this is
  mandatory, the remaining actions are not).\footnote{Choosing the
  paradigm has to be done very carefully. You have to choose the
  paradigm that describes exactly the grammatical and inflection
  characteristics of the inserted word. In the case of adjectives,
  nouns and acronyms, you have to select a paradigm that fits the
  inflection of the word and the genders it may present. For example,
  in the case of acronyms you have to consider the gender and the
  number admitted by each possible paradigm; the paradigm BBC, for
  example, is for feminine singular acronyms, whereas SA is for
  feminine acronyms that may have plural form. In the case of proper
  nouns, you have to choose a different paradigm depending on whether
  the word is a proper noun of a thing (e.g. a newspaper), a person or
  a place.}
\item Select the translation direction of the entry if it is different
from the automatically suggested.
\item Add comments to the entry, that will be included in the final
dictionary.
\end{itemize}

Once the required actions have been done, you have to press
\textit{'Go on'} if you want to confirm the entry or \textit{'Close'}
if you want to cancel the insertion operation.

The following and last screen displays the three generated
\texttt{XML} entries for the SL monolingual, TL monolingual and
bilingual dictionaries. These entries are displayed in three text
boxes that can be edited if you want to do any change. Once you
checked the entries, press the \textit{'Insert'} button to finally
insert them in the corresponding dictionaries. You can also press the
\textit{'Go back'} button to return to the previous step.

\subsubsection{Non-professional mode}

When a user enters the insertion system as a non-professional user,
the word insertion mechanism is the same as for the professional user,
with the difference that the entries will not be saved in the
dictionaries generated by the forms, but will be entered in a queue of
entries pending validation. The words in this queue will not be
inserted in the dictionaries until a professional user validates them.

\subsection{Validating entries}

Professional users have two additional links in the screen for 
paradigm selection:
\begin{itemize}
\item \textit{See pairs to be validated}: Selecting this option will
open a screen that displays the content of the file of entries pending
validation; these are the entries inserted by non-professional
users. This is a merely informative screen, which can be closed
pressing the \textit{'Close'} button.
\item \textit{Validate pairs}: This option allows a professional user
to validate one by one the entries waiting for validation. Selecting
this button will open the screen for the selection of paradigms
already described in section \ref{insertion}. This screen will show
the data selected by the user for the added entry.  Now, the
professional user can modify the lemmas, delete the entry or continue
with the insertion process. If the user decides to proceed with the
insertion, the process is the same as for a normal insertion; only at
the end, when the entry is finally added to the dictionaries of the
form, the control returns to the following entry of the queue pending
validation and displays it.

This process is repeated until all the words of the queue are
validated or until the process is finished by selecting
\textit{'Close'}.

\end{itemize}
