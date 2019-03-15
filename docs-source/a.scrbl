#lang scribble/manual

@(require scriblib/figure)

@title[#:tag "a" #:version "3.5.2"]{Appendix A. XML DTDs}

\section{DTD for the format of dictionaries}
\label{ss:dtd_dics}


Document type definition for the format of morphological, bilingual
and post-generation dictionaries in XML; this definition is provided
with the \texttt{apertium} package (last version) which can be
downloaded from \url{http://www.sourceforge.net}.

The description of its elements can be found in Section
\ref{formatodics}.



\begin{small}
\begin{alltt}
<!\textsl{ELEMENT} \textbf{dictionary} (alphabet?, sdefs?,
		      pardefs?, section+)>

<!\textsl{ELEMENT} \textbf{alphabet} (\textsl{#PCDATA})>
	
<!\textsl{ELEMENT} \textbf{sdefs} (sdef+)>
	
<!\textsl{ELEMENT} \textbf{sdef} \textsl{EMPTY}>
<!\textsl{ATTLIST} sdef n ID \textsl{#REQUIRED}>
	
<!\textsl{ELEMENT} \textbf{pardefs} (pardef+)>
	
<!\textsl{ELEMENT} \textbf{pardef} (e+)>
<!\textsl{ATTLIST} pardef n CDATA \textsl{#REQUIRED}>
	
<!\textsl{ELEMENT} \textbf{section} (e+)>

<!\textsl{ATTLIST} section id ID \textsl{#REQUIRED}
                  type (standard|inconditional|postblank) \textsl{#REQUIRED}>
	
<!\textsl{ELEMENT} \textbf{e} (i | p | par | re)+>
<!\textsl{ATTLIST} e r (LR|RL) \textsl{#IMPLIED}
            lm CDATA \textsl{#IMPLIED}
            a CDATA \textsl{#IMPLIED}
            c CDATA \textsl{#IMPLIED}
	
<!\textsl{ELEMENT} \textbf{par} \textsl{EMPTY}>
<!\textsl{ATTLIST} par n CDATA \textsl{#REQUIRED}>
	
<!\textsl{ELEMENT} \textbf{i} (\textsl{#PCDATA} | b | s | g | j | a)*>
	
<!\textsl{ELEMENT} \textbf{re} (\textsl{#PCDATA})>
	
<!\textsl{ELEMENT} \textbf{p} (l, r)>
	
<!\textsl{ELEMENT} \textbf{l} (\textsl{#PCDATA} | a | b | g | j | s)*>
	
<!\textsl{ELEMENT} \textbf{r} (\textsl{#PCDATA} | a | b | g | j | s)*>
	
<!\textsl{ELEMENT} \textbf{a} \textsl{EMPTY}>
	
<!\textsl{ELEMENT} \textbf{b} \textsl{EMPTY}>
	
<!\textsl{ELEMENT} \textbf{g} (\textsl{#PCDATA} | a | b | j | s)*>
<!\textsl{ATTLIST} g i CDATA \textsl{#IMPLIED}>
	
<!\textsl{ELEMENT} \textbf{j} \textsl{EMPTY}>
	
<!\textsl{ELEMENT} \textbf{s} \textsl{EMPTY}>

<!\textsl{ATTLIST} s n \textsl{IDREF} \textsl{#REQUIRED}>

\end{alltt}
\end{small}


\subsection{Modification of the DTD of dictionaries for lexical
selection}
\label{dixdtd}

The DTD for the format of dictionaries has been slightly modified so
that dictionaries can be used in a system that has a lexical selection
module. The change only affects the \texttt{<e>} element and is
displayed next.



\begin{small}
\begin{alltt}

...
<!\textsl{ATTLIST} e  
        r (LR|RL) \textsl{#IMPLIED}   
        lm \textsl{CDATA #IMPLIED}
        a \textsl{CDATA #IMPLIED}
        c \textsl{CDATA #IMPLIED}>
        i CDATA \textsl{#IMPLIED}
        slr CDATA \textsl{#IMPLIED}
        srl CDATA \textsl{#IMPLIED}>

  <!-- r: restriction LR: left-to-right,
                      RL: right-to-left -->
  <!-- lm: lemma -->
  <!-- a: author -->
  <!-- c: comment -->
  <!-- i: ignore ('yes') means ignore, otherwise it is not ignored) -->
  <!-- slr: translation sense when translating from left to right -->
  <!-- srl: translation sense when translating from right to left --> 
...

\end{alltt}
\end{small}




\section[DTD for the tagger file]{DTD for the format of the tagger
file}
\label{ss:DTD_desambiguador}

DTD that defines the format of the tagger specification file.  This
definition is provided with the \texttt{apertium} package (last
version) which can be downloaded from
\url{http://www.sourceforge.net}.

The description of its elements can be found in
Section~\ref{formatotagger}.

  \begin{small}
  \begin{alltt} 
<!\textsl{ELEMENT} \textbf{tagger} (tagset,forbid?,enforce-rules?,preferences?)>
<!\textsl{ATTLIST} tagger name \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{tagset} (def-label+,def-mult*)>

<!\textsl{ELEMENT} \textbf{def-label} (tags-item+)>
<!\textsl{ATTLIST} def-label name \textsl{CDATA} \textsl{#REQUIRED}
                    closed \textsl{CDATA} \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{tags-item} \textsl{#EMPTY}>
<!\textsl{ATTLIST} tags-item tags \textsl{CDATA} \textsl{#REQUIRED}
                    lemma \textsl{CDATA} \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{def-mult} (sequence+)>
<!\textsl{ATTLIST} def-mult name \textsl{CDATA} \textsl{#REQUIRED}
                   closed \textsl{CDATA} \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{sequence} ((tags-item|label-item)+)>

<!\textsl{ELEMENT} \textbf{label-item} \textsl{#EMPTY}>
<!\textsl{ATTLIST} label-item label \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{forbid} (label-sequence+)>

<!\textsl{ELEMENT} \textbf{label-sequence} (label-item+)>

<!\textsl{ELEMENT} \textbf{enforce-rules} (enforce-after+)>

<!\textsl{ELEMENT} \textbf{enforce-after} (label-set)>
<!\textsl{ATTLIST} enforce-after label \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{label-set} (label-item+)>

<!\textsl{ELEMENT} \textbf{preferences} (prefer+)>

<!\textsl{ELEMENT} \textbf{prefer} \textsl{EMPTY}>
<!\textsl{ATTLIST} prefer tags \textsl{CDATA} \textsl{#REQUIRED}>
  \end{alltt}
\end{small}



\section[DTD of the chunker module]{DTD of the structural transfer
module (chunker)}
\label{ss:dtdtransfer}

DTD for the format of the structural transfer rules in the
\texttt{chunker} module.  This definition is provided with the
\texttt{apertium} package (version 2.0) which can be downloaded from
\url{http://www.sourceforge.net}.

Its elements are described in Section \ref{formatotransfer}.


\begin{small}
\begin{alltt}
<!\textsl{ENTITY} \% condition "(and|or|not|equal|begins-with|
                       ends-with|contains-substring|in)">
<!\textsl{ENTITY} \% container "(var|clip)">
<!\textsl{ENTITY} \% sentence "(let|out|choose|modify-case|
                      call-macro|append)">
<!\textsl{ENTITY} \% value "(b|clip|lit|lit-tag|var|get-case-from|
                   case-of|concat)">
<!\textsl{ENTITY} \% stringvalue "(clip|lit|var|get-case-from|
                         case-of)">

<!\textsl{ELEMENT} \textbf{transfer} (section-def-cats, 
                    section-def-attrs, 
                    section-def-vars, 
                    section-def-lists?, 
                    section-def-macros?, 
                    section-rules)>

<!\textsl{ATTLIST} transfer default (lu|chunk) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{section-def-cats} (def-cat+)>

<!\textsl{ELEMENT} \textbf{def-cat} (cat-item+)>
<!\textsl{ATTLIST} def-cat n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{cat-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} cat-item lemma CDATA \textsl{#IMPLIED}
                   tags CDATA \textsl{#REQUIRED} >

<!\textsl{ELEMENT} \textbf{section-def-attrs} (def-attr+)>

<!\textsl{ELEMENT} \textbf{def-attr} (attr-item+)>
<!\textsl{ATTLIST} def-attr n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{attr-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} attr-item tags CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{section-def-vars} (def-var+)>

<!\textsl{ELEMENT} \textbf{def-var} \textsl{EMPTY}>
<!\textsl{ATTLIST} def-var n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-lists} (def-list)+>

<!\textsl{ELEMENT} \textbf{def-list} (list-item+)>
<!\textsl{ATTLIST} def-list n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{list-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} list-item v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-macros} (def-macro)+>

<!\textsl{ELEMENT} \textbf{def-macro} (\%sentence;)+>
<!\textsl{ATTLIST} def-macro n ID \textsl{#REQUIRED}>
<!\textsl{ATTLIST} def-macro npar CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-rules} (rule+)>

<!\textsl{ELEMENT} \textbf{rule} (pattern, action)>
<!\textsl{ATTLIST} rule comment CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{pattern} (pattern-item+)>

<!\textsl{ELEMENT} \textbf{pattern-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} pattern-item n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{action} (\%sentence;)*>

<!\textsl{ELEMENT} \textbf{choose} (when+,otherwise?)>

<!\textsl{ELEMENT} \textbf{when} (test,(\%sentence;)*)>

<!\textsl{ELEMENT} \textbf{otherwise} (\%sentence;)+>

<!\textsl{ELEMENT} \textbf{test} (\%condition;)+>

<!\textsl{ELEMENT} \textbf{and} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{or} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{not} (\%condition;)>

<!\textsl{ELEMENT} \textbf{equal} (\%value;,\%value;)>
<!\textsl{ATTLIST} equal caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{begins-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} begins-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{ends-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} ends-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{contains-substring} (\%value;,\%value;)>
<!\textsl{ATTLIST} contains-substring caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{in} (\%value;, list)>
<!\textsl{ATTLIST} in caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{list} \textsl{EMPTY}>
<!\textsl{ATTLIST} list n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{let} (\%container;, \%value;)>

<!\textsl{ELEMENT} \textbf{append} (\%value;)+>
<!\textsl{ATTLIST} append n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{out} (mlu|lu|b|chunk)+>

<!\textsl{ELEMENT} \textbf{modify-case} (\%container;, \%stringvalue;)>

<!\textsl{ELEMENT} \textbf{call-macro} (with-param)*>
<!\textsl{ATTLIST} call-macro n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{with-param} \textsl{EMPTY}>
<!\textsl{ATTLIST} with-param pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{clip} \textsl{EMPTY}>
<!\textsl{ATTLIST} clip pos CDATA \textsl{#REQUIRED}
               side (sl|tl) \textsl{#REQUIRED}
               part CDATA \textsl{#REQUIRED}
               queue CDATA \textsl{#IMPLIED}
               link-to CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{lit} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{lit-tag} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit-tag v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{var} \textsl{EMPTY}>
<!\textsl{ATTLIST} var n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{get-case-from} (clip|lit|var)>
<!\textsl{ATTLIST} get-case-from pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{case-of} \textsl{EMPTY}>
<!\textsl{ATTLIST} case-of pos CDATA \textsl{#REQUIRED}
                  side (sl|tl) \textsl{#REQUIRED}
                  part CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{concat} (\%value;)+>

<!\textsl{ELEMENT} \textbf{mlu} (lu+)>

<!\textsl{ELEMENT} \textbf{lu} (\%value;)+>

<!\textsl{ELEMENT} \textbf{chunk} (tags,(mlu|lu|b)+)>
<!\textsl{ATTLIST} chunk name CDATA \textsl{#IMPLIED}
                namefrom CDATA \textsl{#IMPLIED}
                case CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{tags} (tag+)>
<!\textsl{ELEMENT} \textbf{tag} (\%value;)>

<!\textsl{ELEMENT} \textbf{b} \textsl{EMPTY}>
<!\textsl{ATTLIST} b pos CDATA \textsl{#IMPLIED}>

\end{alltt}
\end{small}



\newpage
\section{DTD of the interchunk module}
\label{ss:dtdinterchunk}

DTD for the format of the structural transfer rules in the
\texttt{interchunk} module. This definition is provided with the
\texttt{apertium} package (version 2.0) which can be downloaded from
\url{http://www.sourceforge.net}.

Its elements are described in Section \ref{formatotransfer}.


\begin{small}
\begin{alltt}

<!\textsl{ENTITY} \% condition "(and|or|not|equal|begins-with|
                       ends-with|contains-substring|in)">
<!\textsl{ENTITY} \% container "(var|clip)">
<!\textsl{ENTITY} \% sentence "(let|out|choose|modify-case|
                      call-macro|append)">
<!\textsl{ENTITY} \% value "(b|clip|lit|lit-tag|var|get-case-from|
                   case-of|concat)">
<!\textsl{ENTITY} \% stringvalue "(clip|lit|var|get-case-from|
                         case-of)">

<!\textsl{ELEMENT} \textbf{interchunk} (section-def-cats, 
                      section-def-attrs, 
                      section-def-vars, 
                      section-def-lists?, 
                      section-def-macros?, 
                      section-rules)>

<!\textsl{ELEMENT} \textbf{section-def-cats} (def-cat+)>

<!\textsl{ELEMENT} \textbf{def-cat} (cat-item+)>
<!\textsl{ATTLIST} def-cat n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{cat-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} cat-item lemma CDATA \textsl{#IMPLIED}
                    tags CDATA \textsl{#REQUIRED} >

<!\textsl{ELEMENT} \textbf{section-def-attrs} (def-attr+)>

<!\textsl{ELEMENT} \textbf{def-attr} (attr-item+)>
<!\textsl{ATTLIST} def-attr n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{attr-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} attr-item tags CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{section-def-vars} (def-var+)>

<!\textsl{ELEMENT} \textbf{def-var} \textsl{EMPTY}>
<!\textsl{ATTLIST} def-var n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-lists} (def-list)+>

<!\textsl{ELEMENT} \textbf{def-list} (list-item+)>
<!\textsl{ATTLIST} def-list n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{list-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} list-item v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-macros} (def-macro)+>

<!\textsl{ELEMENT} \textbf{def-macro} (\%sentence;)+>
<!\textsl{ATTLIST} def-macro n ID \textsl{#REQUIRED}>
<!\textsl{ATTLIST} def-macro npar CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-rules} (rule+)>

<!\textsl{ELEMENT} \textbf{rule} (pattern, action)>
<!\textsl{ATTLIST} rule comment CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{pattern} (pattern-item+)>

<!\textsl{ELEMENT} \textbf{pattern-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} pattern-item n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{action} (\%sentence;)*>

<!\textsl{ELEMENT} \textbf{choose} (when+,otherwise?)>

<!\textsl{ELEMENT} \textbf{when} (test,(\%sentence;)*)>

<!\textsl{ELEMENT} \textbf{otherwise} (\%sentence;)+>

<!\textsl{ELEMENT} \textbf{test} (\%condition;)+>

<!\textsl{ELEMENT} \textbf{and} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{or} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{not} (\%condition;)>

<!\textsl{ELEMENT} \textbf{equal} (\%value;,\%value;)>
<!\textsl{ATTLIST} equal caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{begins-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} begins-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{ends-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} ends-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{contains-substring} (\%value;,\%value;)>
<!\textsl{ATTLIST} contains-substring caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{in} (\%value;, list)>
<!\textsl{ATTLIST} in caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{list} \textsl{EMPTY}>
<!\textsl{ATTLIST} list n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{let} (\%container;, \%value;)>

<!\textsl{ELEMENT} \textbf{append} (\%value;)+>
<!\textsl{ATTLIST} append n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{out} (b|chunk)+>

<!\textsl{ELEMENT} \textbf{modify-case} (\%container;, \%stringvalue;)>

<!\textsl{ELEMENT} \textbf{call-macro} (with-param)*>
<!\textsl{ATTLIST} call-macro n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{with-param} \textsl{EMPTY}>
<!\textsl{ATTLIST} with-param pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{clip} \textsl{EMPTY}>
<!\textsl{ATTLIST} clip pos CDATA \textsl{#REQUIRED}
               part CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{lit} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{lit-tag} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit-tag v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{var} \textsl{EMPTY}>
<!\textsl{ATTLIST} var n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{get-case-from} (clip|lit|var)>
<!\textsl{ATTLIST} get-case-from pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{case-of} \textsl{EMPTY}>
<!\textsl{ATTLIST} case-of pos CDATA \textsl{#REQUIRED}
                  part CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{concat} (\%value;)+>

<!\textsl{ELEMENT} \textbf{chunk} (\%value;)+>

<!\textsl{ELEMENT} \textbf{pseudolemma} (\%value;)>

<!\textsl{ELEMENT} \textbf{b} \textsl{EMPTY}>
<!\textsl{ATTLIST} b pos CDATA \textsl{#IMPLIED}>

\end{alltt}
\end{small}

\newpage

\section{DTD of the postchunk module}
\label{ss:dtdpostchunk}

DTD for the format of the structural transfer rules in the
\texttt{postchunk} module. This definition is provided with the
\texttt{apertium} package (version 2.0) which can be downloaded from
\url{http://www.sourceforge.net}.

Its elements are described in Section \ref{formatotransfer}.



\begin{small}
\begin{alltt}
<!\textsl{ENTITY} \% condition "(and|or|not|equal|begins-with|
                       ends-with|contains-substring|in)">
<!\textsl{ENTITY} \% container "(var|clip)">
<!\textsl{ENTITY} \% sentence "(let|out|choose|modify-case|
                      call-macro|append)">
<!\textsl{ENTITY} \% value "(b|clip|lit|lit-tag|var|get-case-from|
                   case-of|concat)">
<!\textsl{ENTITY} \% stringvalue "(clip|lit|var|get-case-from|
                         case-of)">

<!\textsl{ELEMENT} \textbf{postchunk} (section-def-cats, 
                      section-def-attrs, 
                      section-def-vars, 
                      section-def-lists?, 
                      section-def-macros?, 
                      section-rules)>

<!\textsl{ELEMENT} \textbf{section-def-cats} (def-cat+)>

<!\textsl{ELEMENT} \textbf{def-cat} (cat-item+)>
<!\textsl{ATTLIST} def-cat n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{cat-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} cat-item name CDATA \textsl{#REQUIRED}>
 
<!\textsl{ELEMENT} \textbf{section-def-attrs} (def-attr+)>

<!\textsl{ELEMENT} \textbf{def-attr} (attr-item+)>
<!\textsl{ATTLIST} def-attr n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{attr-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} attr-item tags CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{section-def-vars} (def-var+)>

<!\textsl{ELEMENT} \textbf{def-var} \textsl{EMPTY}>
<!\textsl{ATTLIST} def-var n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-lists} (def-list)+>

<!\textsl{ELEMENT} \textbf{def-list} (list-item+)>
<!\textsl{ATTLIST} def-list n ID \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{list-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} list-item v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-def-macros} (def-macro)+>

<!\textsl{ELEMENT} \textbf{def-macro} (\%sentence;)+>
<!\textsl{ATTLIST} def-macro n ID \textsl{#REQUIRED}>
<!\textsl{ATTLIST} def-macro npar CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{section-rules} (rule+)>

<!\textsl{ELEMENT} \textbf{rule} (pattern, action)>
<!\textsl{ATTLIST} rule comment CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{pattern} (pattern-item+)>

<!\textsl{ELEMENT} \textbf{pattern-item} \textsl{EMPTY}>
<!\textsl{ATTLIST} pattern-item n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{action} (\%sentence;)*>

<!\textsl{ELEMENT} \textbf{choose} (when+,otherwise?)>

<!\textsl{ELEMENT} \textbf{when} (test,(\%sentence;)*)>

<!\textsl{ELEMENT} \textbf{otherwise} (\%sentence;)+>

<!\textsl{ELEMENT} \textbf{test} (\%condition;)+>

<!\textsl{ELEMENT} \textbf{and} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{or} ((\%condition;),(\%condition;)+)>

<!\textsl{ELEMENT} \textbf{not} (\%condition;)>

<!\textsl{ELEMENT} \textbf{equal} (\%value;,\%value;)>
<!\textsl{ATTLIST} equal caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{begins-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} begins-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{ends-with} (\%value;,\%value;)>
<!\textsl{ATTLIST} ends-with caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{contains-substring} (\%value;,\%value;)>
<!\textsl{ATTLIST} contains-substring caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{in} (\%value;, list)>
<!\textsl{ATTLIST} in caseless (no|yes) \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{list} \textsl{EMPTY}>
<!\textsl{ATTLIST} list n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{let} (\%container;, \%value;)>

<!\textsl{ELEMENT} \textbf{append} (\%value;)+>
<!\textsl{ATTLIST} append n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{out} (b|lu|mlu)+>

<!\textsl{ELEMENT} \textbf{modify-case} (\%container;, \%stringvalue;)>

<!\textsl{ELEMENT} \textbf{call-macro} (with-param)*>
<!\textsl{ATTLIST} call-macro n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{with-param} \textsl{EMPTY}>
<!\textsl{ATTLIST} with-param pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{clip} \textsl{EMPTY}>
<!\textsl{ATTLIST} clip pos CDATA \textsl{#REQUIRED}
               part CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{lit} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{lit-tag} \textsl{EMPTY}>
<!\textsl{ATTLIST} lit-tag v CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{var} \textsl{EMPTY}>
<!\textsl{ATTLIST} var n \textsl{IDREF} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{get-case-from} (clip|lit|var)>
<!\textsl{ATTLIST} get-case-from pos CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{case-of} \textsl{EMPTY}>
<!\textsl{ATTLIST} case-of pos CDATA \textsl{#REQUIRED}
                  part CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{concat} (\%value;)+>

<!\textsl{ELEMENT} \textbf{mlu} (lu+)>

<!\textsl{ELEMENT} \textbf{lu} (\%value;)+>

<!\textsl{ELEMENT} \textbf{b} \textsl{EMPTY}>
<!\textsl{ATTLIST} b pos CDATA \textsl{#IMPLIED}>

\end{alltt}
\end{small}

\newpage


\section[DTD for the format rules]{DTD for the format specification
rules}
\label{ss:dtd_formato}

DTD for the format specification rules. This definition can be
downloaded from the web page
\url{http://cvs.sourceforge.net/viewcvs.py/apertium/apertium/apertium/format.dtd}. \nota{needs
updating}


Its elements are described in Section \ref{ss:reglasformato}.

\begin{small}
\begin{alltt} 
<!\textsl{ELEMENT} \textbf{format} (options,rules)>
<!\textsl{ATTLIST} format name \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{options} (largeblocks, input, output, 
                   escape-chars, space-chars, case-sensitive)>

<!\textsl{ELEMENT} \textbf{largeblocks} \textsl{EMPTY}>
<!\textsl{ATTLIST} largeblocks size \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{input} \textsl{EMPTY}>
<!\textsl{ATTLIST} input zip-path \textsl{CDATA} \textsl{#IMPLIED}
                encoding \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{output} \textsl{EMPTY}>
<!\textsl{ATTLIST} output zip-path \textsl{CDATA} \textsl{#IMPLIED}
                 encoding \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{escape-chars} \textsl{EMPTY}>
<!\textsl{ATTLIST} escape-chars regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{space-chars} \textsl{EMPTY}>
<!\textsl{ATTLIST} space-chars regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{case-sensitive} \textsl{EMPTY}>
<!\textsl{ATTLIST} case-sensitive value (yes|no) \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{rules} (format-rule|replacement-rule)+>

<!\textsl{ELEMENT} \textbf{format-rule} (begin-end|(begin,end))>
<!\textsl{ATTLIST} format-rule eos (yes|no) \textsl{#IMPLIED}
                      priority \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{begin-end} \textsl{EMPTY}>
<!\textsl{ATTLIST} begin-end regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{begin} \textsl{EMPTY}>
<!\textsl{ATTLIST} begin regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{end} \textsl{EMPTY}>
<!\textsl{ATTLIST} end regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{replacement-rule} (replace+)>
<!\textsl{ATTLIST} replacement-rule regexp \textsl{CDATA} \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{replace} \textsl{EMPTY}>
<!\textsl{ATTLIST} replace source \textsl{CDATA} \textsl{#REQUIRED}
                  target \textsl{CDATA} \textsl{#REQUIRED}
                  prefer (yes|no) \textsl{#IMPLIED}>

\end{alltt}
\end{small}

\newpage
\section{DTD for the form paradigms}
\label{ss:dtdparadigmes}

DTD for the format of the paradigm files used in the forms. This
definition is included in the package
\texttt{apertium-lexical-webform}.

\begin{small}
\begin{alltt}


<!\textsl{ELEMENT} \textbf{form} (entry)+>

<!\textsl{ATTLIST} \textbf{form}
        lang CDATA \textsl{#REQUIRED}
        langpair CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{entry} (endings, paradigms)+>

<!\textsl{ATTLIST} \textbf{entry}
        PoS CDATA \textsl{#REQUIRED}
        nbr CDATA \textsl{#IMPLIED}
        gen CDATA \textsl{#IMPLIED}>

<!\textsl{ELEMENT} \textbf{endings} (stem, ending+)>

<!\textsl{ELEMENT} \textbf{stem} (\textsl{#PCDATA})>

<!\textsl{ELEMENT} \textbf{ending} (\textsl{#PCDATA})>

<!\textsl{ELEMENT} \textbf{paradigms} (par+)>

<!\textsl{ATTLIST} \textbf{paradigms} howmany CDATA \textsl{#REQUIRED}>

<!\textsl{ELEMENT} \textbf{par} \textsl{EMPTY}>

<!\textsl{ATTLIST} \textbf{par} n CDATA \textsl{#REQUIRED}>


\end{alltt}
\end{small}
