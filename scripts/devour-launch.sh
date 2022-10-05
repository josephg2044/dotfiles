#!/bin/sh
#
# Launches files based on their mimetypes
# Usage: launch [FILE...]
# Dependencies: file

case $(file --mime-type "$@" -bL) in
   # Check for the mimetype of your file (This is POSIX regex)
   video/* | audio/* | image/gif)
      # Launch using your favorite application
      devour mpv "$@"
      ;;
   # So on and so forth...
   application/pdf | application/postscript)
      devour zathura "$@"
      ;;
   *) exit 1 ;;
esac
