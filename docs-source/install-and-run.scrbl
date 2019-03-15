#lang scribble/manual

@(require scriblib/figure)

@title[#:tag "install-and-run" #:version "3.5.2"]{Installing and running the system}

\section{System requirements}

The system where you want to install and run Apertium must have the
following programs installed:

\begin{itemize}
\item \texttt{libxml2} version 2.6.17 or later (on Ubuntu you may need
to install \texttt{libxml2-dev} too)

\item \texttt{xmllint} tool (usually comes with \texttt{libxml2}, but
may be an independent package on your system, i.e. Debian GNU-Linux)

\item \texttt{xsltproc} tool (non-PowerPC users); also comes with
\texttt{libxml2} but may also be an independent package in your
system, as happens with the \texttt{xmllint} tool

\item \texttt{sabcmd} tool (PowerPC users), provided by package
\texttt{sablotron}

\item flex 2.5.4 or earlier (in some distributions, flex-old package)
\item GNU \texttt{make}, \texttt{gcc} (\texttt{g++}), \texttt{bash}
shell

\end{itemize}

\section{Installing program packages}

To install the Apertium machine translation system programs and
libraries first you need to download (from
\url{http://sourceforge.net/projects/apertium}), compile and install
the latest version of the following packages, in the specified order:

\begin{enumerate}
\item \texttt{lttoolbox}
\item \texttt{apertium}
\end{enumerate}

The simplest way to compile each package is:

\begin{enumerate}
\item Go to the directory containing the package's source code and
type \texttt{./configure} to configure the package for your system.
If you're using csh on an old version of System V, you might need to
type \texttt{sh ./configure} instead to prevent \texttt{csh} (the
default shell in old System V) from trying to execute
\texttt{configure} itself. Running \texttt{configure} takes a
while. While running, it prints some messages telling which features
it is checking for.

\item Type \texttt{make} to compile the package

\item Type \texttt{make install} (possibly with root privileges) to
install the programs and any data files and documentation.

\item You can remove the program binaries and object files from the
  source code directory by typing \texttt{make clean}. To remove also
  the files that \texttt{configure} created (so you can compile the
  package for a different kind of computer), type \texttt{make
  distclean}. There is also a\\ \texttt{maintainer-clean} option in
  the Makefile, but that is intended mainly for the package's
  developers. If you use it, you may have to get all sorts of other
  programs in order to regenerate files that came with the
  distribution.
\end{enumerate}

If you don't have root privileges to install the programs in your
system, you can use the \texttt{-prefix} flag with the configure
script to install them at your user account. For example:

\begin{small}
\begin{alltt} 
  \verb!$! pwd 
  /home/me/lttoolbox-0.9.1 
  \verb!$! ./configure --prefix=/home/me/myinstall
\end{alltt}
\end{small}

Libraries will be installed in the \texttt{LIBDIR=\$prefix/lib}
directory. If no \texttt{-prefix} flag is specified with configure
script, LIBDIR will be \texttt{/usr/local/lib}.


If you find some error to link against installed libraries in a given
directory \texttt{LIBDIR}, you must either use libtool, and specify
the full pathname of the library, or use the \texttt{LIBDIR} flag
during linking and do at least one of the following:

\begin{itemize}

\item add \verb!LIBDIR! to the \verb!LD_LIBRARY_PATH! environment
variable during execution

\item add \verb!LIBDIR! to the \verb!LD_RUN_PATH! environment variable
during linking

\item use the \texttt{-Wl}, \texttt{--rpath -Wl}, \texttt{LIBDIR}
linker flag

\item have your system administrator add \texttt{LIBDIR} to
\texttt{/etc/ld.so.conf} and run \texttt{ldconfig}

\end{itemize}

See any operating system documentation about shared libraries for more
information, such as the \texttt{ld(1)} and \texttt{ld.so(8)} manual
pages.

\section{Installing data packages}

To install the linguistic data packages, follow these steps:

\begin{enumerate}

\item Download a data package
(\texttt{apertium-}$LANG_1$\texttt{-}$LANG_2$\texttt{-}$VERSION$\texttt{.tar.gz})
from Apertium's website in Sourceforge
(\url{http://apertium.sourceforge.net/}). For example, to get version
0.9 of the linguistic data for the Spanish--Catalan translator, you
need to download the package \texttt{apertium-es-ca-0.9.tar.gz}.

\item Unpack the tarball in any directory, go to this directory and
type \texttt{make} in the terminal. Wait while linguistic data are
compiled.


\end{enumerate}


\section{Using the translator}

There are Apertium versions that work both in Linux systems (always
more up-to-date) and in Windows systems.  The information in this
section is intended for Linux users.


To run the translator, you have to use the
\texttt{apertium} tool referring to the directory where
linguistic data are saved, and specifying the translation direction
(\texttt{es-ca}, \texttt{ca-es}, \texttt{es-gl}, etc.), the file
format (\texttt{txt}, \texttt{html}, \texttt{rtf}), the name of the
file to be translated and the name of the output file. So, the command
structure is as follows:


\begin{small}
\begin{alltt} 
\$ apertium -d <directory> <translation> <format> \\ 
                           < input_file > output_file
\end{alltt}
\end{small}


For example, if your directory is \texttt{/home/maria/apertium-es-ca},
you have to type the following to translate a file in \texttt{txt}
format from Spanish to Catalan:

\begin{small}
\begin{alltt} 
\$ apertium -d /home/maria/apertium-es-ca es-ca \\txt <file_sp >file_ca
\end{alltt}
\end{small}

It is recommended to go to the directory where linguistic data are
saved, because this way you only need to type a dot to refer to the
current directory:

\begin{small}
\begin{alltt} 
\$ apertium -d . es-ca txt <file_sp >file_ca
\end{alltt}
\end{small}

If no format is specified, the default format is \texttt{txt}. When
working with the \texttt{txt}, \texttt{html} and \texttt{rtf} formats,
unknown words are marked with an asterisk (*) and errors with a symbol
(@"@", \# or /); if you wish that neither unknown words nor errors are
marked, you have to add a \texttt{u} to the format name. Therefore,
the format options are the following:

\begin{itemize}
\item \texttt{txt} : Default option, text with marks for unknown words
and errors

\item \texttt{txtu} : text without marks for unknown words and errors

\item \texttt{html} : HTML with marks for unknown words and errors

\item \texttt{htmlu} : HTML without marks for unknown words and errors

\item \texttt{rtf} : RTF with marks for unknown words and errors

\item \texttt{rtfu} : RTF without marks for unknown words and errors

\end{itemize}

If you do not wish to translate a file but just a sentence or a
paragraph in the screen, you can run the \texttt{apertium}
tool without specifying any file name. The command, if you are in the
directory where linguistic data are saved, would be the following:

\begin{small}
\begin{alltt} 
\$ apertium -d . es-ca
\end{alltt}
\end{small}

Then, you have to type or paste the text you wish to translate (it can
contain line breaks). To get the translated version, press Ctrl +
D. The translation will be displayed on the screen.

A third way of translating with Apertium is using the \texttt{echo}
command to send text through the translator:

\begin{small}
\begin{alltt} 
\$ echo "text to be translated" | apertium . es-ca
\end{alltt}
\end{small}
