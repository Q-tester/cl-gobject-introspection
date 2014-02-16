(defpackage #:gir.field
  (:use #:cl)
  (:export #:get #:set)
  (:shadow #:get #:set))

(in-package #:gir.field)

(cffi:defcfun g-field-info-get-field 
    :boolean (field gir::info-ffi) (obj :pointer) (value :pointer))
(cffi:defcfun g-field-info-set-field 
    :boolean (field gir::info-ffi) (obj :pointer) (value :pointer))

(defun get (ptr field)
  (let ((giarg-res (cffi:foreign-alloc '(:union gir:argument))))
    (unless (g-field-info-get-field field ptr giarg-res)
      (error "FFI get field failed: ~a" (gir:info-get-name field)))
    (car (gir:make-out (gir:build-translator (gir:field-info-get-type field))
		       giarg-res nil nil))))

(defun set (ptr field value)
  (let* ((translators (list (gir:build-translator 
                             (gir:field-info-get-type field))))
         (giargs-out (gir:giargs translators (list value))))
    (unless (g-field-info-set-field field ptr giargs-out)
      (error "FFI set field failed: ~a" (gir:info-get-name field)))))
