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
  Extract treebank sentence and convert it to SVG

  Output is returned as a tree in SVG format with nodes corresponding to words
  in the sentence and arcs corresponding to dependency relations between words.
  There is a synthetic root node, with all words not dependent on any other
  in the sentence as its immediate children.

  At each level, the immediate children of a node are those that correspond to
  words dependent on that node's word.

  Associated with each text node is a line to connect that node to its parent
  and a text label for that line containing the dependency relation between the
  two words.

  Each text element corresponding to a word in the sentence has a class
  attribute whose value is the part of speech of the word.

  It is the responsibility of the caller to position the text and lines for
  display.
 :)

module namespace tbs = "http://alpheios.net/namespaces/treebank-svg";
import module namespace tbu="http://alpheios.net/namespaces/treebank-util"
              at "treebank-util.xquery";
declare namespace xlink="http://www.w3.org/1999/xlink";

(:
  Function to process set of words

  Parameters:
    $a_sentence   sentence containing words
    $a_words      words to process
    $a_nopunc     whether to suppress display of terminal punctuation

  Return value:
    SVG equivalent of words
 :)
declare function tbs:word-set(
  $a_sentence as element(),
  $a_words as element()*,
  $a_nopunc as xs:boolean) as element()*
{
  (: for each word :)
  for $word in $a_words
  (: get child words that depend on this :)
  (: ignoring terminal punctuation nodes if so requested :)
  let $children :=
    for $child in $a_sentence/word[./@head = $word/@id]
    where not($a_nopunc and
              ($child/@lemma = ("comma1", "period1", "punc1")) and
              count($a_sentence/word[./@head = $child/@id]) = 0)
    return $child
  return
  (: return group :)
  element g
  {
    attribute class { "tree-node" },
    attribute id { concat($a_sentence/@id, "-", $word/@id) },

    (: box around text :)
    element rect {},

    (: text element with form :)
    element text
    {
      attribute class { "node-label" },
      let $pos := tbu:postag-to-name("pos", $word/@postag)
      return
      if (string-length($pos) > 0)
      then
        attribute pos { $pos }
      else (),
      text { $word/@form }
    },

    (: for each child :)
    for $child in $children
    let $relation :=
      if (contains($child/@relation, "_"))
      then
        substring-before($child/@relation, "_")
      else
        string($child/@relation)
    return
    (
      (: label for arc to child word :)
      element text
      {
        attribute class { "arc-label", "alpheios-ignore" },
        attribute idref { concat($a_sentence/@id, "-", $child/@id) },
        text { tbu:relation-to-display($relation) },
        element text
        {
          attribute class { "arc-label-help" },
          attribute visibility { "hidden" },
          tbu:relation-to-help($relation)
        }
      },

      (: arc to child word :)
      element line
      {
        attribute idref { concat($a_sentence/@id, "-", $child/@id) }
      }
    ),

    (: groups for children :)
    tbs:word-set($a_sentence, $children, $a_nopunc)
  }
};

(:
  Function to convert sentence to SVG

  Parameters:
    $a_docname     name of treebank document
    $a_id          id of sentence
    $a_usespan     whether to use span as label for root node
    $a_nopunc      whether to suppress display of terminal punctuation

  Return value:
    <svg> element containing SVG equivalent of sentence,
    else <svg><text>error message</text></svg>
 :)
declare function tbs:get-svg(
  $a_docname as xs:string,
  $a_id as xs:string,
  $a_usespan as xs:boolean,
  $a_nopunc as xs:boolean) as element()?
{
  (: get sentence and create synthetic root :)
  let $doc := doc($a_docname)
  let $sentence := $doc//sentence[@id = $a_id]
  let $rootword :=
    element word
    {
      attribute id { "0" },
      attribute form { if ($a_usespan) then $sentence/@span else "" }
    }

  return
  <svg xmlns="http://www.w3.org/2000/svg"
       xmlns:xlink="http://www.w3.org/1999/xlink">
  {
    element script
    {
      attribute language { "javascript" },
      attribute type { "text/javascript" },
      attribute src { "../script/alph-align-list.js" }
    },

    (: if sentence found :)
    if ($sentence)
    then
    (
      (: tree structure :)
      element g
      {
        attribute class { "tree" },
        $sentence/@id,
        tbs:word-set($sentence, $rootword, $a_nopunc)
      },

      (: text of sentence :)
      element g
      {
        attribute class { "text" },
        for $word in $sentence/*:word
        return
        (
          element rect
          {
            attribute class { "text-word-bound" },
            attribute tbref { concat($sentence/@id, "-", $word/@id) }
          },
          element text
          {
            attribute class { "text-word" },
            attribute tbref { concat($sentence/@id, "-", $word/@id) },
            (: form preceded by non-breaking space :)
            text { concat("&#x00A0;", $word/@form) }
          }
        )
      },

      (: help :)
      element g
      {
        attribute class { "help alpheios-ignore" },
        element g
        {
          attribute class { "help-mousemove" },
          element text { "Mouse over words in sentence or tree to explore
                          structure and view morphology." }
        },
        element g
        {
          attribute class { "help-dblclick" },
          element text { "Mouse over words in sentence or tree to explore
                          structure; double-click to view morphology." }
        }
      },

      (: key :)
      element g
      {
        attribute class { "key" },
        element rect {},
        element g
        {
          attribute class { "alpheios-ignore" },
          element rect {},
          element text
          {
            attribute class { "heading" },
            "Key to Background Colors"
          },
          element rect { attribute showme { "focus" } },
          element text { "Focus word" },
          element rect { attribute showme { "focus-parent" } },
          element text { "Word that focus word depends on" },
          element rect { attribute showme { "focus-child" } },
          element text { "Words that immediately depend on focus word" },
          element rect { attribute showme { "focus-descendant" } },
          element text { "Other words that depend on focus word" },
          element rect { attribute first { "yes" } },
          element text { "First selected word" },
          element rect {},
          element text {},
          element rect {},
          element text
          {
            attribute class { "heading" },
            "Key to Text Colors"
          },
          for $pos in ("Adjective", "Adverb", "Article",
                       "Conjunction", "Interjection", "Noun",
                       "Preposition", "Pronoun", "Verb",
                       "Other parts of speech")
          return
          (
            element rect {},
            element text { attribute pos { lower-case($pos) }, $pos }
          ),
          element rect {},
          element text {},
          element rect {},
          element text { "LABEL on arc = dependency relation" }
        }
      }
    )
    else
    element text
    {
      concat("Sentence number ", $a_id, " not found")
    }
  }
  </svg>
};