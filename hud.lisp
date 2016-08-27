#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)
(in-readtable :qtools)

(define-subject hud (layer-set persistent)
  ((width :initarg :width :accessor width)
   (height :initarg :height :accessor height)))

(define-handler (hud enter) (ev entity)
  (when (typep entity 'hud-entity)
    (enter entity hud)))

(define-handler (hud leave) (ev entity)
  (when (typep entity 'hud-entity)
    (leave entity hud)))

(define-handler (hud resize) (ev width height)
  (setf (width hud) width
        (height hud) height))

;; This avoids the hud from being added to the actual scene
;; list of units while still making it tied in with the
;; event handling part of it.
(defmethod enter ((hud hud) (scene scene)))
(defmethod leave ((hud hud) (scene scene)))

(defmethod paint ((hud hud) target)
  (gl:with-pushed-matrix* (:projection)
    (gl:load-identity)
    (gl:ortho 0 (width hud) (height hud) 0 -1 10)
    (gl:matrix-mode :modelview)
    (gl:load-identity)
    (gl:disable :cull-face)
    (gl:clear :depth-buffer)
    (for:for ((layer across (objects hud)))
      (for:for ((item over layer))
        (paint item hud))))
  (gl:matrix-mode :modelview))

(defclass hud-entity (entity)
  ((hud-layer :initarg :hud-layer :accessor hud-layer))
  (:default-initargs :hud-layer 0))

(defmethod enter ((entity hud-entity) (hud hud))
  (enter entity (unit (hud-layer entity) hud)))

(defmethod leave ((entity hud-entity) (hud hud))
  (leave entity (unit (hud-layer entity) hud)))

(defmethod paint ((entity hud-entity) (hud hud)))
