;; This file is needed to build the .org files with org-mode.
;; To compile the org files run emacs in batch mode like so:
;;   emacs -q --no-site-file -batch -l build.el sourcefile.org

(require 'org-publish)

(let
    ((org-export-html-coding-system 'utf-8)
     (org-publish-use-timestamps-flag nil)
     ;; Don't create backups when overwriting output files.
     (make-backup-files nil)
     (project (list "orgfiles"
                    :base-directory "src"
                    :base-extension "org"
                    :exclude "menu\\(-projects\\)?.org"
                    :publishing-directory "public_html"
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
 media=\"screen, projection\"/>
<link rel=\"shortcut icon\" href=\"/favicon.ico\" />"
                    :html-preamble "Bram van der Kroef"
                    :auto-postamble nil
                    :email "bram@vanderkroef.net")))

  (if (not noninteractive)
      (error "This build file is to be used only with -batch"))

  (if command-line-args-left
      (org-publish-file (expand-file-name
                         (car command-line-args-left))
                        project)
    (error "Please specify a .org file argument" )))
  
