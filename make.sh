#!/bin/bash

rm ditaa-images/*

emacs -q --eval "(progn (load-file \"conversion-code.el\")(find-file \"notes.org\")(cs61b-export-to-html)(find-file \"index.org\")(org-export-as-html 3)(kill-emacs))"

#clean
for f in $( ls | grep "notes[0-9]\+.org" ); do
     rm $f
done
