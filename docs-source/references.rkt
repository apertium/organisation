#lang racket

(require scriblib/autobib)

(provide (all-defined-out)
         (all-from-out scriblib/autobib))

(define-cite ~cite citet generate-bibliography #:style number-style)

(define forcada00j
  (make-bib
   #:title "interNOSTRUM: a Spanish-Catalan Machine Translation System"
   #:author (authors (author-name "Raül" "Canals")
		     (author-name "Anna" "Esteve")
		     (author-name "Alicia" "Garrido")
		     (author-name "M. Isabel" "Guardiola")
		     (author-name "Amaia" "Iturraspe-Bellver")
		     (author-name "Sandra" "Montserrat")
		     (author-name "Pedro" "Pérez-Antón")
		     (author-name "Sergio" "Ortiz")
		     (author-name "Herminia" "Pastor")
		     (author-name "Mikel L." "Forcada"))
   #:location (journal-location "Machine Translation Review"
				#:pages '(21 25)
				#:number 11)
   #:date 2000))
	       
(define garrido03p
  (make-bib
   #:title "Shallow parsing for Portuguese-Spanish machine translation"
   #:author (authors (author-name "Alicia" "Garrido-Alenda")
                     (author-name "Patricia" "Gilabert Zarco")
                     (author-name "Juan Antonio" "Pérez-Ortiz")
                     (author-name "Antonio" "Pertusa-Ibáñez")
                     (author-name "Gema" "Ramírez-Sánchez")
                     (author-name "Felipe" "Sánchez-Martínez")
                     (author-name "Miriam A." "Scalco")
                     (author-name "Mikel L." "Forcada"))
   #:location (proceedings-location
	       "TASHA 2003: Workshop on Tagging and Shallow Processing of Portuguese"
               #:pages '(21 24))
   #:date 2003))

(define canals01b
  (make-bib
   #:title "El sistema de traducción automática Castellano-Catalán interNOSTRUM"
   #:author (authors (author-name "R." "Canals-Marote")
		     (author-name "A." "Esteve-Guillén")
		     (author-name "A." "Garrido-Alenda")
		     (author-name "M." "Guardiola-Savall")
		     (author-name "A." "Iturraspe-Bellver")
		     (author-name "S." "Monserrat-Buendia")
		     (author-name "S." "Ortiz-Rojas")
		     (author-name "H." "Pastor-Pina")
		     (author-name "P.M." "Perez-Antón")
		     (author-name "M.L." "Forcada"))
   #:location (journal-location "Procesamiento del Lenguaje Natural"
				#:pages '(151 156)
				#:volume 27)
   #:date 2001))

(define garridoalenda01p
  (make-bib
   #:title "MorphTrans: un lenguaje y un compilador para especificar y
       generar módulos de transferencia morfológica para sistemas
       de traducción automática"
   #:author (authors (author-name "Alicia" "Garrido-Alenda")
		     (author-name "Mikel L." "Forcada"))
   #:location (journal-location "Procesamiento del Lenguaje Natural"
				#:pages '(157 164)
				#:volume 27)
   #:date 2001))

(define garrido99j
  (make-bib
   #:title "A compiler for morphological analysers and generators based on finite-state transducers"
   #:author (authors (author-name "A." "Garrido")
		     (author-name "A." "Iturraspe")
		     (author-name "S." "Montserrat")
		     (author-name "H." "Pastor")
		     (author-name "M.L." "Forcada"))
   #:location (journal-location "Procesamiento del Lenguaje Natural"
				#:pages '(93 98)
				#:volume 25)
   #:date 1999))

(define gilabert03j
  (make-bib
   #:title "Construcción rápida de un sistema de traducción
           automática español-portugués partiendo de un sistema español--catalán"
   #:author (authors (author-name "Patrícia Gilabert" "Zarco")
		     (author-name "Javier" "Herrero-Vicente")
		     (author-name "Sergio" "Ortiz-Rojas")
		     (author-name "Antonio" "Pertusa-Ibáñez")
		     (author-name "Gema" "Ramírez-Sánchez")
		     (author-name "Felipe" "Sánchez-Martínez")
		     (author-name "Marcial" "Samper-Asensio")
		     (author-name "Míriam A." "Scalco")
		     (author-name "Mikel L." "Forcada"))
   #:location (journal-location "Procesamiento del Lenguaje Natural"
				#:pages '(279 285)
				#:volume 32)
   #:date 2003))

(define ide00
  (make-bib #:title "The XML Framework and Its Implications for the Development
                     of Natural Language Processing Tools"
	    #:author (authors (author-name "N." "Ide"))
	    #:location (proceedings-location "Proceedings of the COLING Workshop on Using
                                       Toolsets and Architectures to Build NLP Systems,
                                       Luxembourg")
	    #:date 2000))
