(in-package #:resizable-box)


(jupyter/widgets:defwidget resizable-layout (jupyter-widgets:layout)
  ((resize
     :accessor resize
     :initarg :resize
     :initform nil
     :trait :string))
  (:documentation "")
  (:default-initargs
    :%model-name "ResizableLayoutModel"
    :%model-module +module-name+
    :%model-module-version +module-version+
    :%view-name "ResizableLayoutView"
    :%view-module +module-name+
    :%view-module-version +module-version+))


(jupyter/widgets:defwidget resizable-grid-box (jupyter-widgets:grid-box)
  ((enable-full-screen
     :accessor enable-full-screen
     :initarg :enable-full-screen
     :initform nil
     :trait :bool)
   (on-full-screen
     :accessor widget-on-full-screen
     :initarg :on-full-screen
     :initform nil))
  (:documentation "")
  (:default-initargs
    :layout (make-instance 'resizable-layout)
    :%model-name "ResizableGridBoxModel"
    :%model-module +module-name+
    :%model-module-version +module-version+
    :%view-name "ResizableGridBoxView"
    :%view-module +module-name+
    :%view-module-version +module-version+))


(defun enter-full-screen (instance)
  (check-type instance resizable-grid-box)
  (jupyter-widgets:send-custom instance
                               '(:object-plist "do" "enter_full_screen"))
  (values))


(defun exit-full-screen (instance)
  (check-type instance resizable-grid-box)
  (jupyter-widgets:send-custom instance
                               '(:object-plist "do" "exit_full_screen"))
  (values))


(defun on-full-screen (instance handler)
  (push handler (widget-on-full-screen instance)))


(defmethod on-custom-message ((w resizable-grid-box) content buffers)
  (declare (ignore buffers))
  (if (equal (gethash "event" content) "full_screen")
    (dolist (handler (widget-on-full-screen w))
            ()
      (funcall handler w (gethash "state" content)))
    (call-next-method)))
