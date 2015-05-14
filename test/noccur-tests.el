;;; noccur-tests.el --- Tests for noccur.el

;; Copyright (C) 2014 Nicolas Petton

;; Author: Nicolas Petton <petton.nicolas@gmail.com>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for noccur.el

;;; Code:

(require 'noccur)
(require 'ert)


(ert-deftest filenames-with-spaces-without-git ()
  "Test that filenames with spaces are correctly grep-ed, using 'find' command."
  (let* ((root (expand-file-name (make-temp-name "noccur-")
                                 temporary-file-directory))
         (dir1  (expand-file-name "dir1"   root))
         (file1 (expand-file-name "file1"  dir1))
         (file2 (expand-file-name "file 2" dir1))
         (dir2  (expand-file-name "dir 2"  root))
         (file3 (expand-file-name "file3"  dir2))
         (file4 (expand-file-name "file 4" dir2)))
    (make-directory root)               ; create directory structure
    (make-directory dir1)
    (with-temp-file file1 (insert "happy"))
    (with-temp-file file2 (insert "happier"))
    (make-directory dir2)
    (with-temp-file file3 (insert "unhappy"))
    (with-temp-file file4 (insert "happiness"))
    (cd root)                           ; change directory
    (should
     (equal
      '("" "./dir 2/file 4" "./dir 2/file3" "./dir1/file 2" "./dir1/file1")
      (sort (noccur--find-files-project "happ") 'string<)))
    (should
     (equal
      '("" "./dir 2/file3" "./dir1/file1")
      (sort (noccur--find-files-project "happy") 'string<)))
    (delete-directory root t nil)))    ; clean recursively


(ert-deftest filenames-with-spaces-with-git ()
  "Test that filenames with spaces are correctly grep-ed, when under git."
  (let* ((root (expand-file-name (make-temp-name "noccur-")
                                 temporary-file-directory))
         (dir1  (expand-file-name "dir1"   root))
         (file1 (expand-file-name "file1"  dir1))
         (file2 (expand-file-name "file 2" dir1))
         (dir2  (expand-file-name "dir 2"  root))
         (file3 (expand-file-name "file3"  dir2))
         (file4 (expand-file-name "file 4" dir2)))
    (make-directory root)               ; create directory structure
    (make-directory dir1)
    (with-temp-file file1 (insert "happy"))
    (with-temp-file file2 (insert "happier"))
    (make-directory dir2)
    (with-temp-file file3 (insert "unhappy"))
    (with-temp-file file4 (insert "happiness"))
    (cd root)                           ; change directory
    (shell-command "git init")          ; add to git
    (shell-command "git add .")
    (should
     (equal
      '("" "dir 2/file 4" "dir 2/file3" "dir1/file 2" "dir1/file1")
      (sort (noccur--find-files-project "happ") 'string<)))
    (should
     (equal
      '("" "dir 2/file3" "dir1/file1")
      (sort (noccur--find-files-project "happy") 'string<)))
    (delete-directory root t nil)))     ; clean recursively


(ert-deftest directory-without-git ()
  "Grep in directory, not recursively, using 'find' command."
  (let* ((root (expand-file-name (make-temp-name "noccur-")
                                 temporary-file-directory))
         (file1 (expand-file-name "file1"  root))
         (file2 (expand-file-name "file 2" root))
         (dir1  (expand-file-name "dir1"   root))
         (file3 (expand-file-name "file3"  dir1))
         (file4 (expand-file-name "file 4" dir1))
         (dir2  (expand-file-name "dir 2"  root))
         (file5 (expand-file-name "file5"  dir2))
         (file6 (expand-file-name "file 6" dir2)))
    (make-directory root)               ; create directory structure
    (with-temp-file file1 (insert "happiest"))
    (with-temp-file file2 (insert "happily"))
    (make-directory dir1)
    (with-temp-file file3 (insert "happy"))
    (with-temp-file file4 (insert "happier"))
    (make-directory dir2)
    (with-temp-file file5 (insert "unhappy"))
    (with-temp-file file6 (insert "happiness"))
    (cd root)                           ; change directory
    (should
     (equal
      '("" "./file 2" "./file1")
      (sort (noccur--find-files-directory "happ") 'string<)))
    (should
     (equal
      '("" "./file1")
      (sort (noccur--find-files-directory "happie") 'string<)))
    (delete-directory root t nil)))     ; clean recursively


(ert-deftest directory-with-git ()
  "Grep in directory, not recursively, when under git."
  (let* ((root (expand-file-name (make-temp-name "noccur-")
                                 temporary-file-directory))
         (file1 (expand-file-name "file1"  root))
         (file2 (expand-file-name "file 2" root))
         (dir1  (expand-file-name "dir1"   root))
         (file3 (expand-file-name "file3"  dir1))
         (file4 (expand-file-name "file 4" dir1))
         (dir2  (expand-file-name "dir 2"  root))
         (file5 (expand-file-name "file5"  dir2))
         (file6 (expand-file-name "file 6" dir2)))
    (make-directory root)               ; create directory structure
    (with-temp-file file1 (insert "happiest"))
    (with-temp-file file2 (insert "happily"))
    (make-directory dir1)
    (with-temp-file file3 (insert "happy"))
    (with-temp-file file4 (insert "happier"))
    (make-directory dir2)
    (with-temp-file file5 (insert "unhappy"))
    (with-temp-file file6 (insert "happiness"))
    (cd root)                           ; change directory
    (shell-command "git init")          ; add to git
    (shell-command "git add .")
    (should
     (equal
      '("" "file 2" "file1")
      (sort (noccur--find-files-directory "happ") 'string<)))
    (should
     (equal
      '("" "file1")
      (sort (noccur--find-files-directory "happie") 'string<)))
    (delete-directory root t nil)))     ; clean recursively


(provide 'noccur-tests)

;;; noccur-tests.el ends here
