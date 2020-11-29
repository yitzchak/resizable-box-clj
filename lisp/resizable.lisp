(in-package #:resizable-box)


(defclass resizable-layout (jupyter-widgets:layout)
  ((resize
     :accessor resize
     :initarg :resize
     :initform nil
     :trait :string))
  (:metaclass jupyter-widgets:trait-metaclass)
  (:documentation "")
  (:default-initargs
    :%model-name "ResizableLayoutModel"
    :%model-module +module-name+
    :%model-module-version +module-version+
    :%view-name "ResizableLayoutView"
    :%view-module +module-name+
    :%view-module-version +module-version+))

(jupyter-widgets:register-widget resizable-layout)


(defclass resizable-grid-box (jupyter-widgets:grid-box)
  ((enable-full-screen
     :accessor enable-full-screen
     :initarg :enable-full-screen
     :initform nil
     :trait :bool)
   (on-full-screen
     :accessor widget-on-full-screen
     :initarg :on-full-screen
     :initform nil))
  (:metaclass jupyter-widgets:trait-metaclass)
  (:documentation "")
  (:default-initargs
    :layout (make-instance 'resizable-layout)
    :%model-name "ResizableGridBoxModel"
    :%model-module +module-name+
    :%model-module-version +module-version+
    :%view-name "ResizableGridBoxView"
    :%view-module +module-name+
    :%view-module-version +module-version+))

(jupyter-widgets:register-widget resizable-grid-box)


(defun enter-full-screen (instance)
  (check-type instance resizable-grid-box)
  (jupyter-widgets:send-custom instance
                               (jupyter:json-new-obj
                                 ("do" "enter_full_screen")))
  (values))


(defun exit-full-screen (instance)
  (check-type instance resizable-grid-box)
  (jupyter-widgets:send-custom instance
                               (jupyter:json-new-obj
                                 ("do" "exit_full_screen")))
  (values))


(defun on-full-screen (instance handler)
  (push handler (widget-on-full-screen instance)))


(defmethod on-custom-message ((w resizable-grid-box) content buffers)
  (declare (ignore buffers))
  (if (equal (jupyter:json-getf content "event") "full_screen")
    (dolist (handler (widget-on-full-screen w))
            ()
      (funcall handler w (jupyter:json-getf content "state")))
    (call-next-method)))
