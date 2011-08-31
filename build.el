;; This file is needed to build the .org files with org-mode.
;; In Emacs, include the file with =load-file= and run
;; =org-publish-all= to publish all source files in the public_html
;; dir.
;;
;; To publish a part individually use =org-publish-project=. These are
;; the available projects:
;;  - orgfiles -- compiles the .org files to .html files in public_html
;;  - css      -- minifies the .css files and moves the result to
;;                public_html
;;  - cv       -- compiles src/cv/curiculum_vitae.tex and moves the pdf to
;;                public_html/files 
;;  - images   -- copies the images in src/images to public_html/images
;;  - files    -- copies all files in src/files to public_html/files

(setq
 portfolio-base "~/Dropbox/Projects/Web/vanderkroef.net/"
 
 org-publish-project-alist
      (list
       (list "orgfiles"
         :base-directory (concat portfolio-base "src")
         :base-extension "org"
         :exclude "menu.org"
         :publishing-directory (concat portfolio-base "public_html")
         :publishing-function 'org-publish-org-to-html
         :headline-levels 3
         :section-numbers nil       ;; headings don't have numbers
         :table-of-contents nil     ;; don't add a toc by default
         :style-include-default nil ;; don't include default styles
         :style "<link rel=\"stylesheet\" href=\"/css/screen.css\"
 type=\"text/css\" media=\"screen, projection\"/>
<link rel=\"stylesheet\" href=\"/css/print.css\" type=\"text/css\"
 media=\"print\"/> 
<!--[if IE]>
<link rel=\"stylesheet\" href=\"/css/ie.css\" type=\"text/css\"  media=\"screen,
 projection\"/> 
<![endif]-->
<link rel=\"stylesheet\" href=\"/css/style.css\" type=\"text/css\"
 media=\"screen, projection\"/>"
         :preamble "<div class=\"site-title\">Bram van der Kroef</div>"
         :auto-postamble nil
         :email "bram@vanderkroef.net")
        
       (list "css"
         :base-directory (concat portfolio-base "src/css")
         :base-extension "css"
         :publishing-directory (concat portfolio-base "public_html/css")
         :publishing-function 'my-org-css-minify)

       (list "cv"
             :base-directory (concat portfolio-base "src/cv")
             :base-extension "tex"
             :publishing-directory (concat portfolio-base "public_html/files")
             :publishing-function 'my-compile-latex)
        
       (list "images"
         :base-directory (concat portfolio-base "src/images")
         :recursive t
         :base-extension "jpg\\|png"
         :publishing-directory (concat portfolio-base "public_html/images")
         :publishing-function 'org-publish-attachment)
       (list "files"
             :base-directory (concat portfolio-base "src/files")
             :base-extension 'any
             :publishing-directory (concat portfolio-base "public_html/files")
             :publishing-function 'org-publish-attachment)))

(defvar my-org-lessc-compiler "lessc")
(defvar my-org-css-compressor "yuicompressor")
(defun my-org-lessc-compile (plist filename pub-dir)
  "Compile less files to css files"
  (call-process my-org-lessc-compiler nil nil nil filename
                (concat pub-dir (file-name-nondirectory
                                 (file-name-sans-extension filename)) ".css")))

(defun my-org-css-minify (plist filename pub-dir)
  "Compress a css file and place the result in the pub-dir"
  (call-process my-org-css-compressor nil nil nil filename "-o"
                (concat pub-dir (file-name-nondirectory filename))))

(defun my-compile-latex (plist filename pub-dir)
  "Compile latex file and move the resulting pdf to pub-dir"
  (let ((default-directory (file-name-directory filename))
        (pdffile (concat (file-name-sans-extension
                          (file-name-nondirectory filename))".pdf"))
        (sourcedir (file-name-directory filename)))
    (call-process "pdflatex" nil nil nil (file-name-nondirectory filename))
    (rename-file (concat sourcedir pdffile)
                 (concat pub-dir pdffile) t)))

