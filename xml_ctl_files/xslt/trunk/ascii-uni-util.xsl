<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common">

  <!-- keys for lookup table -->
  <xsl:key name="unic-ascii-lookup" match="uni-ascii-table/entry" use="unic"/>

  <!--
    Table mapping Unicode to Transliterated Ascii
    
    Each entry in the table contains a precombined Unicode sequence 
    (<unic> element) and the corresponding Ascii transliteration for
    that sequence.

    This is only partially implemented at the moment. It contains
    transliterations for precombined Latin-1 and Latin-2 vowels only
    
    To get around tree fragment restrictions in XSLT 1.0, the actual variable
    uses exsl:node-set().
  -->
  <xsl:variable name="raw-table">
    <uni-ascii-table>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c0;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c1;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c2;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c3;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c4;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x00c5;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x0100;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x0102;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>A</ascii>
        <unic>&#x0104;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e0;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e1;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e2;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e3;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e4;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x00e5;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x0101;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x0103;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>a</ascii>
        <unic>&#x0105;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>AE</ascii>
        <unic>&#x00c6;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>ae</ascii>
        <unic>&#x00e6;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x00c8;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x00c9;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x00ca;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x00cb;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x0112;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x0114;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x0116;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x0118;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>E</ascii>
        <unic>&#x011a;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x00e8;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x00e9;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x00ea;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x00eb;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x0113;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x0115;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x0117;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x0119;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>e</ascii>
        <unic>&#x011b;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x00cc;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x00cd;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x00ce;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x00cf;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x0128;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x012a;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x012c;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x012e;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>I</ascii>
        <unic>&#x0130;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x00ec;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x00ed;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x00ee;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x00ef;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x0129;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x012b;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x012d;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x012f;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>i</ascii>
        <unic>&#x0131;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x00d2;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x00d3;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x00d4;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x00d5;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x00d6;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x014c;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x014e;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>O</ascii>
        <unic>&#x0150;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x00f2;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x00f3;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x00f4;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x00f5;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x00f6;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x014d;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x014f;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>o</ascii>
        <unic>&#x0151;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>OE</ascii>
        <unic>&#x0152;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>oe</ascii>
        <unic>&#x0153;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x00d9;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x00da;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x00db;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x00dc;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x0168;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x016a;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x016c;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x016e;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x0170;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>U</ascii>
        <unic>&#x0172;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x00f9;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x00fa;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x00fb;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x00fc;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x0169;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x016b;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x016d;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x016f;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x0171;</unic>
        <unid></unid>
      </entry>
      <entry>
        <ascii>u</ascii>
        <unic>&#x0173;</unic>
        <unid></unid>
      </entry>
      
    </uni-ascii-table>
    
  </xsl:variable>
  <xsl:variable name="uni-ascii-table"
    select="exsl:node-set($raw-table)/uni-ascii-table"/>

  <!--
    Convert unicode to transliterated ascii
    Parameters:
    $key          unicode character 
  -->
  <xsl:template match="uni-ascii-table" mode="u2a">
    <xsl:param name="key"/>
    
    <xsl:variable name="keylen" select="string-length($key)"/>

    <!-- if key exists -->
    <xsl:if test="$keylen > 0">
      <!-- try to find key in table -->
      <xsl:variable name="value">
        <xsl:value-of select="(key('unic-ascii-lookup', $key)/ascii)[1]/text()"/>
      </xsl:variable>

      <xsl:if test="string-length($value) > 0">
          <xsl:value-of select="$value"/>
      </xsl:if>

      <!-- otherwise, ignore it -->
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
