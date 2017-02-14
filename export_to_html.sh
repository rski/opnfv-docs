# usage: export_to_html.sh somefile.org
emacs $1 --batch -f org-html-export-to-html --kill
