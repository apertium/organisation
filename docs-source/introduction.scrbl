#lang scribble/base

@title[#:tag "intro" #:version "3.5.2"]{Introduction}

This documentation describes the Apertium platform, one of the
open-source machine translation systems which originated within the
project ``Open-Source Machine Translation for the Languages of Spain''
(``Traducción automática de código abierto para las lenguas del estado
español''). It is a shallow-transfer machine translation system,
initially designed for the translation between related language pairs,
although some of its components have been also used in the
deep-transfer architecture
(@hyperlink["https://github.com/matxin"]{Matxin}) that has been
developed in the same project for the pair Spanish-Basque.

Existing machine translation systems available at present for the
pairs @tt{es}--@tt{ca} and @tt{es}--@tt{gl} are mostly commercial or
use proprietary technologies, which makes them very hard to adapt to
new usages; furthermore, they use different technologies across
language pairs, which makes it very difficult to integrate them in a
single multilingual content management system.

One of the main novelties of the architecture described here is that
it has been released under open-source licenses (in most cases, GNU
GPL; some data still have a Creative Commons license) and is
distributed free of charge. This means that anyone having the
necessary computational and linguistic skills will be able to adapt or
enhance the platform or the language-pair data to create a new machine
translation system, even for other pairs of related languages. The
licenses chosen make these improvements immediately available to
everyone. We therefore expect that the introduction of this of
open-source machine translation architecture will solve some of the
mentioned problems (having different technologies for different pairs,
closed-source architectures being hard to adapt to new uses, etc.) and
promote the exchange of existing linguistic data through the use of
the XML-based formats defined in this documentation. On the other
hand, we think that it will help shift the current business model from
a license-centered one to a services-centered one.

It is worth mentioning that ``Open-Source Machine Translation for the
Languages of Spain'' was the first large open-source machine
translation project funded by the central Spanish Government, although
the adoption of open-source software by the Spanish governments is not
new.

\nota{Don't forget about the other funding agencies supporting open source MT; this needs some contextualization, relating to funding, etc. Mention later funding and refer to the appropriate section.}

This documentation describes in detail the characteristics of the
Apertium platform, and is organized as follows:


\begin{itemize}
\item Chapter \ref{ss:descrarq}: \textbf{general description} of the
shallow-transfer machine translation system and of the modules that
make it up.

\item Chapter \ref{se:flujodatos}: description of the \textbf{format
of the data stream} that circulates from one module to the next one.

\item Chapter \ref{se:especificmodulos}: \textbf{specification of the
modules} of the system. For each module there is a description of: the
\textit{program} and its characteristics,  the \textit{format of the data}
that the module uses, and the \textit{compilers}  used for it.
This chapter is divided in the following sections:
  \begin{itemize}
  \item [-]Section \ref{ss:modproclex}: \emph{Lexical processing
    modules}, where the morphological analyser, the lexical transfer
    module, the morphological generator and the post-generator are
    described (Section \ref{ss:funcproclex}), along with the format of
    the dictionaries used by these modules (section
    \ref{ss:diccionarios}) and their compilers (section
    \ref{se:compiladoresdic})
  \item [-]Section \ref{ss:tagger}: \emph{Part-of-speech Tagger},
    which describes the tagger (Section \ref{functagger}) and the
    format of the linguistic data used by the tagger (section
    \ref{datostagger}.
% MLF 20060328 elimina % y el compilador % correspondiente (apartado
%\ref{ss:gentagger})

\nota{falta parlar del lextor, i afegir-ho a tot arreu on es parli
dels mòduls del sistema}
     
  \item [-]Section \ref{se:pretransfer}: \emph{Pre-transfer module},
    which describes the module that runs before the structural
    transfer module to perform some operations on multiword units
  \item [-]Section \ref{ss:transfer}: \emph{Structural transfer
    module}, where there is a description of the program (section
    \ref{functransfer}) and of the format of the structural transfer
    rules (Section \ref{formatotransfer}).
% MLF 20060328 % y el % compilador correspondiente (apartado
% \ref{gentransfer})
  \item [-]Section \ref{se:desformat}: \emph{De-formatter and
    Re-formatter}, which describes these modules (section
    \ref{ss:formato}), the rules for format processing (section
    \ref{ss:reglasformato}) and how these modules are generated
    (Section \ref{se:gendeformat})
 
  \end{itemize}



\item Chapter \ref{se:instalacion}: it describes the way to 
\textbf{install the system} and to \textbf{run the translator}.

\item Chapter \ref{se:datosling}: here you will find an explanation of
  how to \textbf{modify the linguistic data} used by the translator,
  that is, the dictionaries, the part-of-speech disambiguation data
  and the structural transfer rules created in this project for
  Spanish, Catalan and Galician. Furthermore, it contains a brief
  description of the characteristics of the
available data for these three language pairs.
\nota{I would try to be more general, and perhaps remove this section or update with some other pairs. Any ideas on how to do this?}


\nota{Es diuen a tot arreu els noms de programa i en quin paquet
estan?}


\end{itemize}


The files which this documentation refers to can be found at and
downloaded from the project web page in Sourceforge:
\url{http://sourceforge.net/projects/apertium/}.  From this page you can
download the packages needed for installation, as well as view the
individual files in the SVN (main) and CVS (residual) repositories of
the project.  The machine translation systems for the different
language pairs can also be tested on the Internet at
\url{http://www.apertium.org/}.

\nota{Shouldn't we mention the debugging interfaces?}
\nota{Should we define SVN and CVS?}

%El presente documento tiene algunas secciones que están incompletas o
%no han sido escritas todavía.


\paragraph*{Acknowledgements:} The present work has benefited from the
contribution of many people and institutions:
\begin{itemize}
\item The Spanish Ministry of Industry, Commerce and Tourism has
  funded the development of this toolbox through the projects
  ``Open-Source Machine Translation for the Languages of Spain'', code
  FIT-340101-2004-3, and its extension FIT-340001-2005-2, and
  ``EurOpenTrad: Open-Source Advanced Machine Translation for the
  European Integration of the Languages of Spain'', code
  FIT-350101-2006-5, all of them belonging to the PROFIT program.



\item Workers and scholars from other machine translation projects at
the Universitat d'Alacant: Míriam Antunes Scalco, Carme Armentano i
Oller, Raül Canals i Marote, Alicia Garrido Alenda, Patrícia Gilabert
i Zarco, Maribel Guardiola i Savall, Javier Herrero Vicente, Amaia
Iturraspe Bellver, Sandra Montserrat i Buendia, Hermínia Pastor Pina,
Antonio Pertusa Ibáñez, Francisco Javier Ramos Salas, Marcial Samper
Asensio and Miguel Sánchez Molina.
\item The companies and institutions that have funded these other
machine translation projects: Spanish Ministry of Science and
Technology, Caja de Ahorros del Mediterráneo, Universitat d'Alacant
and Portal Universia, S.A.
\item Iñaki Alegria, from the Ixa group of the Euskal Herriko
Unibertsitatea (University of the Basque Country), for his close
reading of previous versions of this document.
\item Google, who, through the Google Summer of Code programme,
funded the development of several new modules.
\end{itemize}
