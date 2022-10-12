#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)

(docs:define-docs
  (variable +map-key-events+
   "Controls whether key events are mapped.

This is useful to set to NIL when within a text input field, to avoid
key bindings interfering with text input."))

(in-package #:org.shirakumo.fraf.trial.bvh2)

(docs:define-docs
  (function bvh-reinsert-all
   "Reinsert each node in BVH to its optimal position in the
tree. Results may improve with multiple passes, the number of which
may be specified by ROUNDS."))
