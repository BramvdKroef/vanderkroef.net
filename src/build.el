(let
    ((srcdir "~/Code/vanderkroef.net/src/")
     (builddir "~/Code/vanderkroef.net/public_html/"))

  (setq org-publish-project-alist
      '(("orgfiles"
         :base-directory srcdir
         :base-extension "org"
         :publishing-directory builddir
         :publishing-function org-publish-org-to-html
         :headline-levels 3
         :section-numbers nil       ;; headings don't have numbers
         :table-of-contents nil     ;; don't add a toc by default
         :style-include-default nil ;; don't include default styles
         :style "<link rel=\"stylesheet\"
                       href=\"/css/style.css\" type=\"text/css\"/>"
         :auto-preamble t
         :auto-postamble nil
         :email "bram@vanderkroef.net")
        
        ("css"
         :base-directory (concat srcdir "css/")
         :base-extension "less"
         :publishing-directory (concat builddir "css/")
         :publishing-function my-org-lessc-compile)
        
        ("images"
         :base-directory (concat srcdir "img/")
         :base-extension "jpg\\|png"
         :publishing-directory (concat builddir "images/")
         :publishing-function org-publish-attachment))))
