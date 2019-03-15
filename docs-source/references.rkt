#lang racket

(require scriblib/autobib)

(provide (all-defined-out)
         (all-from-out scriblib/autobib))

(define-cite ~cite citet generate-bibliography #:style number-style)

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
   #:location (proceedings-location "TASHA 2003: Workshop on Tagging and
                                     Shallow Processing of Portuguese"
                                    #:pages '(21 24))
   #:date 2003))

(define canals01b
  (make-bib
   #:title "El sistema de traducción automática castellano-catalán interNOSTRUM"
   #:author (authors (author-name "R." "Canals-Marote"))))

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
