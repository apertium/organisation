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
       generar m\'odulos de transferencia morfol\'ogica para sistemas
       de traducci\'on autom\'atica"
   #:author (authors (author-name "Alicia" "Garrido-Alenda")
		     (author-name "Mikel L." "Forcada"))))

(define garrido99j
  (make-bib
   #:title "A compiler for morphological analysers and generators based on finite-state transducers"
   #:author (authors (author-name "Alicia" "Garrido-Alenda"))))

(define gilabert03j
  (make-bib

   #:title "Construcción rápida de un sistema de traducción
           automática español-portugués partiendo de un sistema español--catalán"))
