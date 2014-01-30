;;code to help convert diagrams to proper ditaa format
;; and wrap code in org blocks

(defun fix-ditaa ()
  (interactive)
  (save-excursion
    (goto-char 1)
    ;; (while (re-search-forward "\\.\\+--" nil t)
    ;;   (replace-match " +--"))
    ;; (goto-char 1)
    ;; (while (re-search-forward "--\\+\\." nil t)
    ;;   (replace-match "--+ "))
    ;; (goto-char 1)
    (while (re-search-forward "+\\||" nil t)
      (let ((p (1- (point)))
	    above below)
	(goto-char p)
	(previous-line)
	(if (and (looking-at-p "-") ;;check if we are at a corner
		 (or (or (bolp)
			 (save-excursion
			   (backward-char)
			   (looking-at-p "[^-]")))
		     (or (eolp)
			 (save-excursion
			   (forward-char)
			   (looking-at-p "[^-]")))))
	    
	    
	    (setq above (point)))
	(goto-char p)
	(next-line)
	(if (and (looking-at-p "-") ;;check if we are at a corner
		 (or (or (bolp)
			 (save-excursion
			   (backward-char)
			   (looking-at-p "[^-]")))
		     (or (eolp)
			 (save-excursion
			   (forward-char)
			   (looking-at-p "[^-]")))))
	    (setq below (point)))
	
	(when (and above below)
	  (goto-char above)
	  (delete-char 1)
	  (insert "+")
	  (goto-char below)
	  (delete-char 1)
	  (insert "+"))
	(goto-char (1+ p))
	))))

(setq ditaa-block-counter 0)
(defun ditaa-wrap-block (&optional image-dir file)
  (interactive)
  (setq image-dir (or image-dir "ditaa-images"))
  (unless (file-directory-p image-dir)
    (make-directory image-dir))
  (setq file (or file (format "img%s" (setq ditaa-block-counter
					    (1+ ditaa-block-counter)))))
  (mbs-wrap-region (format "#+begin_ditaa %s" (file-path-concat image-dir
								file))
		   "#+end_ditaa"))
(defun java-wrap-block ()
  (interactive)
  (mbs-wrap-region "#+Begin_SRC java" "#+END_SRC"))

(defun mbs-wrap-region (begin end)
  (interactive)
  (save-excursion 
    (goto-char (region-end))
    (unless (bolp)
      (insert "\n"))
    (insert end)
    (unless (eolp)
      (insert "\n"))
    
    (goto-char (region-beginning))
    (unless (bolp)
      (insert "\n"))
    (insert begin)
    (unless (eolp)
      (insert "\n"))))


;; manual conversions:
;;
;; this kind of list:
;; (1) ...
;; (2) ...

;; should to be changed to:
;; 1. ...
;; 2. ...

;; underlines like this
;; _empty_string_
;; need to be changed to
;; _empty\_string_ or _empty string_