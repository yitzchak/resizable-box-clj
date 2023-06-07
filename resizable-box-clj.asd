(asdf:defsystem #:resizable-box-clj
  :description "A resizable box widget for Common Lisp Jupyter."
  :version "0.1.0"
  :author "Tarn W. Burton"
  :license "MIT"
  :defsystem-depends-on (#:jupyter-lab-extension)
  :depends-on (#:common-lisp-jupyter)
  :components ((:jupyter-lab-extension resizable-box-clj
                :pathname "prebuilt/")
               (:module lisp
                :serial t
                :components ((:file "packages")
                             (:file "version")
                             (:file "resizable")))))
