(:
  Copyright 2009 Cantus Foundation
  http://alpheios.net

  This file is part of Alpheios.

  Alpheios is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Alpheios is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)

(:
  Create HTML page for editing treebank sentence
 :)

import module namespace request="http://exist-db.org/xquery/request";
import module namespace tbed="http://alpheios.net/namespaces/treebank-edit"
              at "treebank-editsentence.xquery";
declare option exist:serialize
        "method=xhtml media-type=application/xhtml+xml omit-xml-declaration=no indent=yes 
        doctype-public=-//W3C//DTD&#160;XHTML&#160;1.0&#160;Transitional//EN
        doctype-system=http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd";

let $docStem := request:get-parameter("doc", ())
let $tb := request:get-parameter("tb", ())
let $mode := request:get-parameter("mode", "expert")
let $docName := concat("/db/repository/treebank/", $docStem, ".tb.xml")
let $sentId := request:get-parameter("s", ())
let $base := request:get-url()
let $base := substring($base,
                       1,
                       string-length($base) - 
                       string-length(request:get-path-info()))
let $base := substring($base,
                       1,
                       string-length($base) -
                       string-length(tokenize($base, '/')[last()]))

return
  if (empty($docStem))
  then
    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>No document specified</body>
    </html>
  else if (empty($sentId))
  then
    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>No sentence specified</body>
    </html>
  else if (not($mode = ("expert", "novice")))
  then
    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>Invalid mode '{ $mode }' specified</body>
    </html>
  else
  tbed:get-edit-page($docName,
                     $docStem,
                     $base,
                     $tb,
                     "aldt",
                     number($sentId),
                     ($mode eq "novice"),
                     (
                        "./treebank-savesentence.xq",
                        "./treebank-getlist.xq",
                        "./treebank-editsentence.xq",
                        "./treebank-entertext.xq"
                      ),
                     "s")