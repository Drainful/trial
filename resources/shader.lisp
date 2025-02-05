#|
 This file is a part of trial
 (c) 2017 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)

(defclass shader (gl-resource)
  ((shader-type :initarg :type :accessor shader-type)
   (shader-source :initarg :source :accessor shader-source))
  (:default-initargs
   :type (error "TYPE required.")
   :source (error "SOURCE required.")))

(defmethod initialize-instance :before ((shader shader) &key type)
  (check-shader-type type))

(defmethod print-object ((shader shader) stream)
  (print-unreadable-object (shader stream :type T :identity T)
    (format stream "~a" (shader-type shader))))

(defmethod allocate ((shader shader))
  (let ((source (shader-source shader))
        (shdr (gl:create-shader (shader-type shader))))
    (with-cleanup-on-failure (gl:delete-shader shdr)
      (with-new-value-restart (source input-source) (use-source "Supply new source code directly.")
        (unless (search "#version " source)
          (setf source (format NIL "~a~%~a" (glsl-version-header *context*) source))
          (when (eql :es (profile *context*))
            (setf source (glsl-toolkit:transform source :es (version *context*)))))
        (gl:shader-source shdr source)
        (gl:compile-shader shdr)
        (unless (gl:get-shader shdr :compile-status)
          (error 'shader-compilation-error :shader shader :log (gl:get-shader-info-log shdr)))
        (v:debug :trial.asset "Compiled shader ~a: ~%~a" shader source)
        (setf (data-pointer shader) shdr)))))

(defmethod deallocate ((shader shader))
  (gl:delete-shader (gl-name shader)))
