<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common">

  <!-- Upper/lower tables.  Note: J is not a valid betacode base character. -->
  <xsl:variable name="beta-uppers">ABCDEFGHIKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="beta-lowers">abcdefghiklmnopqrstuvwxyz</xsl:variable>

  <!-- diacritics in betacode and combining unicode -->
  <xsl:variable name="beta-diacritics">()+/\=|_^&apos;</xsl:variable>
  <xsl:variable name="uni-diacritics"
    >&#x0314;&#x0313;&#x0308;&#x0301;&#x0300;&#x0342;&#x0345;&#x0304;&#x0306;&#x1FBD;</xsl:variable>

  <!-- characters with and without length diacritics -->
  <xsl:variable name="beta-with-length">_^+</xsl:variable>
  <xsl:variable name="beta-without-length"></xsl:variable>
  <xsl:variable name="uni-with-length"
    >&#x1FB0;&#x1FB1;&#x1FB8;&#x1FB9;&#x1FD0;&#x1FD1;&#x1FD8;&#x1FD9;&#x1FE0;&#x1FE1;&#x1FE8;&#x1FE9;&#x0390;&#x03AA;&#x03AB;&#x03B0;&#x03CA;&#x03CB;&#x1FD2;&#x1FD3;&#x1FD7;&#x1FE2;&#x1FE3;&#x1FE7;&#x1FC1;&#x1FED;&#x1FEE;&#x00A8;&#x00AF;&#x0304;&#x0306;&#x0308;</xsl:variable>
  <xsl:variable name="uni-without-length"
    >&#x03B1;&#x03B1;&#x0391;&#x0391;&#x03B9;&#x03B9;&#x0399;&#x0399;&#x03C5;&#x03C5;&#x03A5;&#x03A5;&#x03AF;&#x0399;&#x03A5;&#x03CD;&#x03B9;&#x03C5;&#x1F76;&#x1F77;&#x1FD6;&#x1F7A;&#x1F7B;&#x1FE6;&#x1FC0;&#x1FEF;&#x1FFD;</xsl:variable>

  <!-- characters denoting a word separation: punctuation plus whitespace -->
  <xsl:variable name="beta-separators">
    .,:;_&#x0009;&#x000A;&#x000D;&#x0020;&#x0085;&#x00A0;&#x1680;&#x180E;
    &#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;&#x2006;&#x2007;&#x2008;&#x2009;&#x200A;
    &#x2028;&#x2029;&#x202F;&#x205F;&#x3000;
  </xsl:variable>

  <!-- more characters the denoting end of a word -->
  <xsl:variable name="beta-separators2">0123456789[]{}</xsl:variable>

  <!-- keys for lookup table -->
  <xsl:key name="beta-uni-lookup" match="beta-uni-table/entry" use="beta"/>
  <xsl:key name="unic-beta-lookup" match="beta-uni-table/entry" use="unic"/>

  <!--
    Table mapping betacode sequences to Unicode
    Betacode sequences have the form
      <letter><diacritics>
    where
      - <letter> is one of the base Greek characters as
        represented in betacode
      - <diacritics> is a string in canonical order:
        * = capitalize
        ( = dasia/rough breathing
        ) = psili/smooth breathing
        + = diaeresis
        / = acute accent
        \ = grave accent
        = = perispomeni
        | = ypogegrammeni
        _ = macron [non-standard, Perseus]
        ^ = breve [non-standard, Perseus]
        ' = koronis [non-standard]

    Each entry in the table contains a betacode sequence
    plus the corresponding precomposed Unicode sequence (<unic> element)
    and decomposed Unicode sequence (<unid> element>.
    But for entries for which the <beta> content contains only diacritics,
    <unic> holds the non-combining form, while <unid> holds the combining form.

    To get around tree fragment restrictions in XSLT 1.0, the actual variable
    uses exsl:node-set().
  -->
  <xsl:variable name="raw-table">
    <beta-uni-table>
      <entry>
        <beta>a*(/|</beta>
        <unic>&#x1F8D;</unic>
        <unid>&#x0391;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*(/</beta>
        <unic>&#x1F0D;</unic>
        <unid>&#x0391;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a*(\|</beta>
        <unic>&#x1F8B;</unic>
        <unid>&#x0391;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*(\</beta>
        <unic>&#x1F0B;</unic>
        <unid>&#x0391;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a*(=|</beta>
        <unic>&#x1F8F;</unic>
        <unid>&#x0391;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*(=</beta>
        <unic>&#x1F0F;</unic>
        <unid>&#x0391;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>a*(|</beta>
        <unic>&#x1F89;</unic>
        <unid>&#x0391;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*(</beta>
        <unic>&#x1F09;</unic>
        <unid>&#x0391;&#x0314;</unid>
      </entry>
      <entry>
        <beta>a*)/|</beta>
        <unic>&#x1F8C;</unic>
        <unid>&#x0391;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*)/</beta>
        <unic>&#x1F0C;</unic>
        <unid>&#x0391;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a*)\|</beta>
        <unic>&#x1F8A;</unic>
        <unid>&#x0391;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*)\</beta>
        <unic>&#x1F0A;</unic>
        <unid>&#x0391;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a*)=|</beta>
        <unic>&#x1F8E;</unic>
        <unid>&#x0391;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*)=</beta>
        <unic>&#x1F0E;</unic>
        <unid>&#x0391;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>a*)|</beta>
        <unic>&#x1F88;</unic>
        <unid>&#x0391;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*)</beta>
        <unic>&#x1F08;</unic>
        <unid>&#x0391;&#x0313;</unid>
      </entry>
      <entry>
        <beta>a*/</beta>
        <unic>&#x0386;</unic>
        <unid>&#x0391;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a*\</beta>
        <unic>&#x1FBA;</unic>
        <unid>&#x0391;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a*|</beta>
        <unic>&#x1FBC;</unic>
        <unid>&#x0391;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a*_</beta>
        <unic>&#x1FB9;</unic>
        <unid>&#x0391;&#x0304;</unid>
      </entry>
      <entry>
        <beta>a*^</beta>
        <unic>&#x1FB8;</unic>
        <unid>&#x0391;&#x0306;</unid>
      </entry>
      <entry>
        <beta>a*</beta>
        <unic>&#x0391;</unic>
        <unid>&#x0391;</unid>
      </entry>
      <entry>
        <beta>a(/|</beta>
        <unic>&#x1F85;</unic>
        <unid>&#x03B1;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a(/</beta>
        <unic>&#x1F05;</unic>
        <unid>&#x03B1;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a(\|</beta>
        <unic>&#x1F83;</unic>
        <unid>&#x03B1;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a(\</beta>
        <unic>&#x1F03;</unic>
        <unid>&#x03B1;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a(=|</beta>
        <unic>&#x1F87;</unic>
        <unid>&#x03B1;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a(=</beta>
        <unic>&#x1F07;</unic>
        <unid>&#x03B1;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>a(|</beta>
        <unic>&#x1F81;</unic>
        <unid>&#x03B1;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a(</beta>
        <unic>&#x1F01;</unic>
        <unid>&#x03B1;&#x0314;</unid>
      </entry>
      <entry>
        <beta>a)/|</beta>
        <unic>&#x1F84;</unic>
        <unid>&#x03B1;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a)/</beta>
        <unic>&#x1F04;</unic>
        <unid>&#x03B1;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a)\|</beta>
        <unic>&#x1F82;</unic>
        <unid>&#x03B1;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a)\</beta>
        <unic>&#x1F02;</unic>
        <unid>&#x03B1;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a)=|</beta>
        <unic>&#x1F86;</unic>
        <unid>&#x03B1;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a)=</beta>
        <unic>&#x1F06;</unic>
        <unid>&#x03B1;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>a)|</beta>
        <unic>&#x1F80;</unic>
        <unid>&#x03B1;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a)</beta>
        <unic>&#x1F00;</unic>
        <unid>&#x03B1;&#x0313;</unid>
      </entry>
      <entry>
        <beta>a/|</beta>
        <unic>&#x1FB4;</unic>
        <unid>&#x03B1;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a/</beta>
        <unic>&#x03AC;</unic>
        <unid>&#x03B1;&#x0301;</unid>
      </entry>
      <entry>
        <beta>a\|</beta>
        <unic>&#x1FB2;</unic>
        <unid>&#x03B1;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a\</beta>
        <unic>&#x1F70;</unic>
        <unid>&#x03B1;&#x0300;</unid>
      </entry>
      <entry>
        <beta>a=|</beta>
        <unic>&#x1FB7;</unic>
        <unid>&#x03B1;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a=</beta>
        <unic>&#x1FB6;</unic>
        <unid>&#x03B1;&#x0342;</unid>
      </entry>
      <entry>
        <beta>a|</beta>
        <unic>&#x1FB3;</unic>
        <unid>&#x03B1;&#x0345;</unid>
      </entry>
      <entry>
        <beta>a_</beta>
        <unic>&#x1FB1;</unic>
        <unid>&#x03B1;&#x0304;</unid>
      </entry>
      <entry>
        <beta>a^</beta>
        <unic>&#x1FB0;</unic>
        <unid>&#x03B1;&#x0306;</unid>
      </entry>
      <entry>
        <beta>a</beta>
        <unic>&#x03B1;</unic>
        <unid>&#x03B1;</unid>
      </entry>
      <entry>
        <beta>b*</beta>
        <unic>&#x0392;</unic>
        <unid>&#x0392;</unid>
      </entry>
      <entry>
        <beta>b</beta>
        <unic>&#x03B2;</unic>
        <unid>&#x03B2;</unid>
      </entry>
      <entry>
        <beta>c*</beta>
        <unic>&#x039E;</unic>
        <unid>&#x039E;</unid>
      </entry>
      <entry>
        <beta>c</beta>
        <unic>&#x03BE;</unic>
        <unid>&#x03BE;</unid>
      </entry>
      <entry>
        <beta>d*</beta>
        <unic>&#x0394;</unic>
        <unid>&#x0394;</unid>
      </entry>
      <entry>
        <beta>d</beta>
        <unic>&#x03B4;</unic>
        <unid>&#x03B4;</unid>
      </entry>
      <entry>
        <beta>e*(/</beta>
        <unic>&#x1F1D;</unic>
        <unid>&#x0395;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e*(\</beta>
        <unic>&#x1F1B;</unic>
        <unid>&#x0395;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e*(</beta>
        <unic>&#x1F19;</unic>
        <unid>&#x0395;&#x0314;</unid>
      </entry>
      <entry>
        <beta>e*)/</beta>
        <unic>&#x1F1C;</unic>
        <unid>&#x0395;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e*)\</beta>
        <unic>&#x1F1A;</unic>
        <unid>&#x0395;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e*)</beta>
        <unic>&#x1F18;</unic>
        <unid>&#x0395;&#x0313;</unid>
      </entry>
      <entry>
        <beta>e*/</beta>
        <unic>&#x0388;</unic>
        <unid>&#x0395;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e*\</beta>
        <unic>&#x1FC8;</unic>
        <unid>&#x0395;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e*</beta>
        <unic>&#x0395;</unic>
        <unid>&#x0395;</unid>
      </entry>
      <entry>
        <beta>e(/</beta>
        <unic>&#x1F15;</unic>
        <unid>&#x03B5;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e(\</beta>
        <unic>&#x1F13;</unic>
        <unid>&#x03B5;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e(</beta>
        <unic>&#x1F11;</unic>
        <unid>&#x03B5;&#x0314;</unid>
      </entry>
      <entry>
        <beta>e)/</beta>
        <unic>&#x1F14;</unic>
        <unid>&#x03B5;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e)\</beta>
        <unic>&#x1F12;</unic>
        <unid>&#x03B5;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e)</beta>
        <unic>&#x1F10;</unic>
        <unid>&#x03B5;&#x0313;</unid>
      </entry>
      <entry>
        <beta>e/</beta>
        <unic>&#x03AD;</unic>
        <unid>&#x03B5;&#x0301;</unid>
      </entry>
      <entry>
        <beta>e\</beta>
        <unic>&#x1F72;</unic>
        <unid>&#x03B5;&#x0300;</unid>
      </entry>
      <entry>
        <beta>e</beta>
        <unic>&#x03B5;</unic>
        <unid>&#x03B5;</unid>
      </entry>
      <entry>
        <beta>f*</beta>
        <unic>&#x03A6;</unic>
        <unid>&#x03A6;</unid>
      </entry>
      <entry>
        <beta>f</beta>
        <unic>&#x03C6;</unic>
        <unid>&#x03C6;</unid>
      </entry>
      <entry>
        <beta>g*</beta>
        <unic>&#x0393;</unic>
        <unid>&#x0393;</unid>
      </entry>
      <entry>
        <beta>g</beta>
        <unic>&#x03B3;</unic>
        <unid>&#x03B3;</unid>
      </entry>
      <entry>
        <beta>h*(/|</beta>
        <unic>&#x1F9D;</unic>
        <unid>&#x0397;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*(/</beta>
        <unic>&#x1F2D;</unic>
        <unid>&#x0397;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h*(\|</beta>
        <unic>&#x1F9B;</unic>
        <unid>&#x0397;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*(\</beta>
        <unic>&#x1F2B;</unic>
        <unid>&#x0397;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h*(=|</beta>
        <unic>&#x1F9F;</unic>
        <unid>&#x0397;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*(=</beta>
        <unic>&#x1F2F;</unic>
        <unid>&#x0397;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>h*(|</beta>
        <unic>&#x1F99;</unic>
        <unid>&#x0397;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*(</beta>
        <unic>&#x1F29;</unic>
        <unid>&#x0397;&#x0314;</unid>
      </entry>
      <entry>
        <beta>h*)/|</beta>
        <unic>&#x1F9C;</unic>
        <unid>&#x0397;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*)/</beta>
        <unic>&#x1F2C;</unic>
        <unid>&#x0397;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h*)\|</beta>
        <unic>&#x1F9A;</unic>
        <unid>&#x0397;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*)\</beta>
        <unic>&#x1F2A;</unic>
        <unid>&#x0397;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h*)=|</beta>
        <unic>&#x1F9E;</unic>
        <unid>&#x0397;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*)=</beta>
        <unic>&#x1F2E;</unic>
        <unid>&#x0397;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>h*)|</beta>
        <unic>&#x1F98;</unic>
        <unid>&#x0397;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*)</beta>
        <unic>&#x1F28;</unic>
        <unid>&#x0397;&#x0313;</unid>
      </entry>
      <entry>
        <beta>h*/</beta>
        <unic>&#x0389;</unic>
        <unid>&#x0397;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h*\</beta>
        <unic>&#x1FCA;</unic>
        <unid>&#x0397;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h*|</beta>
        <unic>&#x1FCC;</unic>
        <unid>&#x0397;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h*</beta>
        <unic>&#x0397;</unic>
        <unid>&#x0397;</unid>
      </entry>
      <entry>
        <beta>h(/|</beta>
        <unic>&#x1F95;</unic>
        <unid>&#x03B7;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h(/</beta>
        <unic>&#x1F25;</unic>
        <unid>&#x03B7;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h(\|</beta>
        <unic>&#x1F93;</unic>
        <unid>&#x03B7;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h(\</beta>
        <unic>&#x1F23;</unic>
        <unid>&#x03B7;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h(=|</beta>
        <unic>&#x1F97;</unic>
        <unid>&#x03B7;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h(=</beta>
        <unic>&#x1F27;</unic>
        <unid>&#x03B7;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>h(|</beta>
        <unic>&#x1F91;</unic>
        <unid>&#x03B7;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h(</beta>
        <unic>&#x1F21;</unic>
        <unid>&#x03B7;&#x0314;</unid>
      </entry>
      <entry>
        <beta>h)/|</beta>
        <unic>&#x1F94;</unic>
        <unid>&#x03B7;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h)/</beta>
        <unic>&#x1F24;</unic>
        <unid>&#x03B7;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h)\|</beta>
        <unic>&#x1F92;</unic>
        <unid>&#x03B7;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h)\</beta>
        <unic>&#x1F22;</unic>
        <unid>&#x03B7;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h)=|</beta>
        <unic>&#x1F96;</unic>
        <unid>&#x03B7;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h)=</beta>
        <unic>&#x1F26;</unic>
        <unid>&#x03B7;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>h)|</beta>
        <unic>&#x1F90;</unic>
        <unid>&#x03B7;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h)</beta>
        <unic>&#x1F20;</unic>
        <unid>&#x03B7;&#x0313;</unid>
      </entry>
      <entry>
        <beta>h/|</beta>
        <unic>&#x1FC4;</unic>
        <unid>&#x03B7;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h/</beta>
        <unic>&#x03AE;</unic>
        <unid>&#x03B7;&#x0301;</unid>
      </entry>
      <entry>
        <beta>h\|</beta>
        <unic>&#x1FC2;</unic>
        <unid>&#x03B7;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h\</beta>
        <unic>&#x1F74;</unic>
        <unid>&#x03B7;&#x0300;</unid>
      </entry>
      <entry>
        <beta>h=|</beta>
        <unic>&#x1FC7;</unic>
        <unid>&#x03B7;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h=</beta>
        <unic>&#x1FC6;</unic>
        <unid>&#x03B7;&#x0342;</unid>
      </entry>
      <entry>
        <beta>h|</beta>
        <unic>&#x1FC3;</unic>
        <unid>&#x03B7;&#x0345;</unid>
      </entry>
      <entry>
        <beta>h</beta>
        <unic>&#x03B7;</unic>
        <unid>&#x03B7;</unid>
      </entry>
      <entry>
        <beta>i*(/</beta>
        <unic>&#x1F3D;</unic>
        <unid>&#x0399;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i*(\</beta>
        <unic>&#x1F3B;</unic>
        <unid>&#x0399;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i*(=</beta>
        <unic>&#x1F3F;</unic>
        <unid>&#x0399;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i*(</beta>
        <unic>&#x1F39;</unic>
        <unid>&#x0399;&#x0314;</unid>
      </entry>
      <entry>
        <beta>i*)/</beta>
        <unic>&#x1F3C;</unic>
        <unid>&#x0399;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i*)\</beta>
        <unic>&#x1F3A;</unic>
        <unid>&#x0399;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i*)=</beta>
        <unic>&#x1F3E;</unic>
        <unid>&#x0399;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i*)</beta>
        <unic>&#x1F38;</unic>
        <unid>&#x0399;&#x0313;</unid>
      </entry>
      <entry>
        <beta>i*+</beta>
        <unic>&#x03AA;</unic>
        <unid>&#x0399;&#x0308;</unid>
      </entry>
      <entry>
        <beta>i*/</beta>
        <unic>&#x038A;</unic>
        <unid>&#x0399;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i*\</beta>
        <unic>&#x1FDA;</unic>
        <unid>&#x0399;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i*_</beta>
        <unic>&#x1FD9;</unic>
        <unid>&#x0399;&#x0304;</unid>
      </entry>
      <entry>
        <beta>i*^</beta>
        <unic>&#x1FD8;</unic>
        <unid>&#x0399;&#x0306;</unid>
      </entry>
      <entry>
        <beta>i*</beta>
        <unic>&#x0399;</unic>
        <unid>&#x0399;</unid>
      </entry>
      <entry>
        <beta>i(/</beta>
        <unic>&#x1F35;</unic>
        <unid>&#x03B9;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i(\</beta>
        <unic>&#x1F33;</unic>
        <unid>&#x03B9;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i(=</beta>
        <unic>&#x1F37;</unic>
        <unid>&#x03B9;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i(</beta>
        <unic>&#x1F31;</unic>
        <unid>&#x03B9;&#x0314;</unid>
      </entry>
      <entry>
        <beta>i)/</beta>
        <unic>&#x1F34;</unic>
        <unid>&#x03B9;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i)\</beta>
        <unic>&#x1F32;</unic>
        <unid>&#x03B9;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i)=</beta>
        <unic>&#x1F36;</unic>
        <unid>&#x03B9;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i)</beta>
        <unic>&#x1F30;</unic>
        <unid>&#x03B9;&#x0313;</unid>
      </entry>
      <entry>
        <beta>i+/</beta>
        <unic>&#x0390;</unic>
        <unid>&#x03B9;&#x0308;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i+\</beta>
        <unic>&#x1FD2;</unic>
        <unid>&#x03B9;&#x0308;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i+=</beta>
        <unic>&#x1FD7;</unic>
        <unid>&#x03B9;&#x0308;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i+</beta>
        <unic>&#x03CA;</unic>
        <unid>&#x03B9;&#x0308;</unid>
      </entry>
      <entry>
        <beta>i/</beta>
        <unic>&#x03AF;</unic>
        <unid>&#x03B9;&#x0301;</unid>
      </entry>
      <entry>
        <beta>i\</beta>
        <unic>&#x1F76;</unic>
        <unid>&#x03B9;&#x0300;</unid>
      </entry>
      <entry>
        <beta>i=</beta>
        <unic>&#x1FD6;</unic>
        <unid>&#x03B9;&#x0342;</unid>
      </entry>
      <entry>
        <beta>i_</beta>
        <unic>&#x1FD1;</unic>
        <unid>&#x03B9;&#x0304;</unid>
      </entry>
      <entry>
        <beta>i^</beta>
        <unic>&#x1FD0;</unic>
        <unid>&#x03B9;&#x0306;</unid>
      </entry>
      <entry>
        <beta>i</beta>
        <unic>&#x03B9;</unic>
        <unid>&#x03B9;</unid>
      </entry>
      <entry>
        <beta>k*</beta>
        <unic>&#x039A;</unic>
        <unid>&#x039A;</unid>
      </entry>
      <entry>
        <beta>k</beta>
        <unic>&#x03BA;</unic>
        <unid>&#x03BA;</unid>
      </entry>
      <entry>
        <beta>l*</beta>
        <unic>&#x039B;</unic>
        <unid>&#x039B;</unid>
      </entry>
      <entry>
        <beta>l</beta>
        <unic>&#x03BB;</unic>
        <unid>&#x03BB;</unid>
      </entry>
      <entry>
        <beta>m*</beta>
        <unic>&#x039C;</unic>
        <unid>&#x039C;</unid>
      </entry>
      <entry>
        <beta>m</beta>
        <unic>&#x03BC;</unic>
        <unid>&#x03BC;</unid>
      </entry>
      <entry>
        <beta>n*</beta>
        <unic>&#x039D;</unic>
        <unid>&#x039D;</unid>
      </entry>
      <entry>
        <beta>n</beta>
        <unic>&#x03BD;</unic>
        <unid>&#x03BD;</unid>
      </entry>
      <entry>
        <beta>o*(/</beta>
        <unic>&#x1F4D;</unic>
        <unid>&#x039F;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o*(\</beta>
        <unic>&#x1F4B;</unic>
        <unid>&#x039F;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o*(</beta>
        <unic>&#x1F49;</unic>
        <unid>&#x039F;&#x0314;</unid>
      </entry>
      <entry>
        <beta>o*)/</beta>
        <unic>&#x1F4C;</unic>
        <unid>&#x039F;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o*)\</beta>
        <unic>&#x1F4A;</unic>
        <unid>&#x039F;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o*)</beta>
        <unic>&#x1F48;</unic>
        <unid>&#x039F;&#x0313;</unid>
      </entry>
      <entry>
        <beta>o*/</beta>
        <unic>&#x038C;</unic>
        <unid>&#x039F;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o*\</beta>
        <unic>&#x1FF8;</unic>
        <unid>&#x039F;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o*</beta>
        <unic>&#x039F;</unic>
        <unid>&#x039F;</unid>
      </entry>
      <entry>
        <beta>o(/</beta>
        <unic>&#x1F45;</unic>
        <unid>&#x03BF;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o(\</beta>
        <unic>&#x1F43;</unic>
        <unid>&#x03BF;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o(</beta>
        <unic>&#x1F41;</unic>
        <unid>&#x03BF;&#x0314;</unid>
      </entry>
      <entry>
        <beta>o)/</beta>
        <unic>&#x1F44;</unic>
        <unid>&#x03BF;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o)\</beta>
        <unic>&#x1F42;</unic>
        <unid>&#x03BF;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o)</beta>
        <unic>&#x1F40;</unic>
        <unid>&#x03BF;&#x0313;</unid>
      </entry>
      <entry>
        <beta>o/</beta>
        <unic>&#x03CC;</unic>
        <unid>&#x03BF;&#x0301;</unid>
      </entry>
      <entry>
        <beta>o\</beta>
        <unic>&#x1F78;</unic>
        <unid>&#x03BF;&#x0300;</unid>
      </entry>
      <entry>
        <beta>o</beta>
        <unic>&#x03BF;</unic>
        <unid>&#x03BF;</unid>
      </entry>
      <entry>
        <beta>p*</beta>
        <unic>&#x03A0;</unic>
        <unid>&#x03A0;</unid>
      </entry>
      <entry>
        <beta>p</beta>
        <unic>&#x03C0;</unic>
        <unid>&#x03C0;</unid>
      </entry>
      <entry>
        <beta>q*</beta>
        <unic>&#x0398;</unic>
        <unid>&#x0398;</unid>
      </entry>
      <entry>
        <beta>q</beta>
        <unic>&#x03B8;</unic>
        <unid>&#x03B8;</unid>
      </entry>
      <entry>
        <beta>r*(</beta>
        <unic>&#x1FEC;</unic>
        <unid>&#x03A1;&#x0314;</unid>
      </entry>
      <entry>
        <beta>r*</beta>
        <unic>&#x03A1;</unic>
        <unid>&#x03A1;</unid>
      </entry>
      <entry>
        <beta>r(</beta>
        <unic>&#x1FE5;</unic>
        <unid>&#x03C1;&#x0314;</unid>
      </entry>
      <entry>
        <beta>r)</beta>
        <unic>&#x1FE4;</unic>
        <unid>&#x03C1;&#x0313;</unid>
      </entry>
      <entry>
        <beta>r</beta>
        <unic>&#x03C1;</unic>
        <unid>&#x03C1;</unid>
      </entry>
      <entry>
        <beta>s*</beta>
        <unic>&#x03A3;</unic>
        <unid>&#x03A3;</unid>
      </entry>
      <entry>
        <beta>s</beta>
        <unic>&#x03C3;</unic>
        <unid>&#x03C3;</unid>
      </entry>
      <entry>
        <beta>t*</beta>
        <unic>&#x03A4;</unic>
        <unid>&#x03A4;</unid>
      </entry>
      <entry>
        <beta>t</beta>
        <unic>&#x03C4;</unic>
        <unid>&#x03C4;</unid>
      </entry>
      <entry>
        <beta>u*(/</beta>
        <unic>&#x1F5D;</unic>
        <unid>&#x03A5;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u*(\</beta>
        <unic>&#x1F5B;</unic>
        <unid>&#x03A5;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u*(=</beta>
        <unic>&#x1F5F;</unic>
        <unid>&#x03A5;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>u*(</beta>
        <unic>&#x1F59;</unic>
        <unid>&#x03A5;&#x0314;</unid>
      </entry>
      <entry>
        <beta>u*+</beta>
        <unic>&#x03AB;</unic>
        <unid>&#x03A5;&#x0308;</unid>
      </entry>
      <entry>
        <beta>u*/</beta>
        <unic>&#x038E;</unic>
        <unid>&#x03A5;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u*\</beta>
        <unic>&#x1FEA;</unic>
        <unid>&#x03A5;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u*_</beta>
        <unic>&#x1FE9;</unic>
        <unid>&#x03A5;&#x0304;</unid>
      </entry>
      <entry>
        <beta>u*^</beta>
        <unic>&#x1FE8;</unic>
        <unid>&#x03A5;&#x0306;</unid>
      </entry>
      <entry>
        <beta>u*</beta>
        <unic>&#x03A5;</unic>
        <unid>&#x03A5;</unid>
      </entry>
      <entry>
        <beta>u(/</beta>
        <unic>&#x1F55;</unic>
        <unid>&#x03C5;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u(\</beta>
        <unic>&#x1F53;</unic>
        <unid>&#x03C5;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u(=</beta>
        <unic>&#x1F57;</unic>
        <unid>&#x03C5;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>u(</beta>
        <unic>&#x1F51;</unic>
        <unid>&#x03C5;&#x0314;</unid>
      </entry>
      <entry>
        <beta>u)/</beta>
        <unic>&#x1F54;</unic>
        <unid>&#x03C5;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u)\</beta>
        <unic>&#x1F52;</unic>
        <unid>&#x03C5;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u)=</beta>
        <unic>&#x1F56;</unic>
        <unid>&#x03C5;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>u)</beta>
        <unic>&#x1F50;</unic>
        <unid>&#x03C5;&#x0313;</unid>
      </entry>
      <entry>
        <beta>u+/</beta>
        <unic>&#x03B0;</unic>
        <unid>&#x03C5;&#x0308;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u+\</beta>
        <unic>&#x1FE2;</unic>
        <unid>&#x03C5;&#x0308;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u+=</beta>
        <unic>&#x1FE7;</unic>
        <unid>&#x03C5;&#x0308;&#x0342;</unid>
      </entry>
      <entry>
        <beta>u+</beta>
        <unic>&#x03CB;</unic>
        <unid>&#x03C5;&#x0308;</unid>
      </entry>
      <entry>
        <beta>u/</beta>
        <unic>&#x03CD;</unic>
        <unid>&#x03C5;&#x0301;</unid>
      </entry>
      <entry>
        <beta>u\</beta>
        <unic>&#x1F7A;</unic>
        <unid>&#x03C5;&#x0300;</unid>
      </entry>
      <entry>
        <beta>u=</beta>
        <unic>&#x1FE6;</unic>
        <unid>&#x03C5;&#x0342;</unid>
      </entry>
      <entry>
        <beta>u_</beta>
        <unic>&#x1FE1;</unic>
        <unid>&#x03C5;&#x0304;</unid>
      </entry>
      <entry>
        <beta>u^</beta>
        <unic>&#x1FE0;</unic>
        <unid>&#x03C5;&#x0306;</unid>
      </entry>
      <entry>
        <beta>u</beta>
        <unic>&#x03C5;</unic>
        <unid>&#x03C5;</unid>
      </entry>
      <entry>
        <beta>v*</beta>
        <unic>&#x03DC;</unic>
        <unid>&#x03DC;</unid>
      </entry>
      <entry>
        <beta>v</beta>
        <unic>&#x03DD;</unic>
        <unid>&#x03DD;</unid>
      </entry>
      <entry>
        <beta>w*(/|</beta>
        <unic>&#x1FAD;</unic>
        <unid>&#x03A9;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*(/</beta>
        <unic>&#x1F6D;</unic>
        <unid>&#x03A9;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w*(\|</beta>
        <unic>&#x1FAB;</unic>
        <unid>&#x03A9;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*(\</beta>
        <unic>&#x1F6B;</unic>
        <unid>&#x03A9;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w*(=|</beta>
        <unic>&#x1FAF;</unic>
        <unid>&#x03A9;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*(=</beta>
        <unic>&#x1F6F;</unic>
        <unid>&#x03A9;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>w*(|</beta>
        <unic>&#x1FA9;</unic>
        <unid>&#x03A9;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*(</beta>
        <unic>&#x1F69;</unic>
        <unid>&#x03A9;&#x0314;</unid>
      </entry>
      <entry>
        <beta>w*)/|</beta>
        <unic>&#x1FAC;</unic>
        <unid>&#x03A9;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*)/</beta>
        <unic>&#x1F6C;</unic>
        <unid>&#x03A9;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w*)\|</beta>
        <unic>&#x1FAA;</unic>
        <unid>&#x03A9;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*)\</beta>
        <unic>&#x1F6A;</unic>
        <unid>&#x03A9;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w*)=|</beta>
        <unic>&#x1FAE;</unic>
        <unid>&#x03A9;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*)=</beta>
        <unic>&#x1F6E;</unic>
        <unid>&#x03A9;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>w*)|</beta>
        <unic>&#x1FA8;</unic>
        <unid>&#x03A9;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*)</beta>
        <unic>&#x1F68;</unic>
        <unid>&#x03A9;&#x0313;</unid>
      </entry>
      <entry>
        <beta>w*/</beta>
        <unic>&#x038F;</unic>
        <unid>&#x03A9;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w*\</beta>
        <unic>&#x1FFA;</unic>
        <unid>&#x03A9;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w*|</beta>
        <unic>&#x1FFC;</unic>
        <unid>&#x03A9;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w*</beta>
        <unic>&#x03A9;</unic>
        <unid>&#x03A9;</unid>
      </entry>
      <entry>
        <beta>w(/|</beta>
        <unic>&#x1FA5;</unic>
        <unid>&#x03C9;&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w(/</beta>
        <unic>&#x1F65;</unic>
        <unid>&#x03C9;&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w(\|</beta>
        <unic>&#x1FA3;</unic>
        <unid>&#x03C9;&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w(\</beta>
        <unic>&#x1F63;</unic>
        <unid>&#x03C9;&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w(=|</beta>
        <unic>&#x1FA7;</unic>
        <unid>&#x03C9;&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w(=</beta>
        <unic>&#x1F67;</unic>
        <unid>&#x03C9;&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>w(|</beta>
        <unic>&#x1FA1;</unic>
        <unid>&#x03C9;&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w(</beta>
        <unic>&#x1F61;</unic>
        <unid>&#x03C9;&#x0314;</unid>
      </entry>
      <entry>
        <beta>w)/|</beta>
        <unic>&#x1FA4;</unic>
        <unid>&#x03C9;&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w)/</beta>
        <unic>&#x1F64;</unic>
        <unid>&#x03C9;&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w)\|</beta>
        <unic>&#x1FA2;</unic>
        <unid>&#x03C9;&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w)\</beta>
        <unic>&#x1F62;</unic>
        <unid>&#x03C9;&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w)=|</beta>
        <unic>&#x1FA6;</unic>
        <unid>&#x03C9;&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w)=</beta>
        <unic>&#x1F66;</unic>
        <unid>&#x03C9;&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>w)|</beta>
        <unic>&#x1FA0;</unic>
        <unid>&#x03C9;&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w)</beta>
        <unic>&#x1F60;</unic>
        <unid>&#x03C9;&#x0313;</unid>
      </entry>
      <entry>
        <beta>w/|</beta>
        <unic>&#x1FF4;</unic>
        <unid>&#x03C9;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w/</beta>
        <unic>&#x03CE;</unic>
        <unid>&#x03C9;&#x0301;</unid>
      </entry>
      <entry>
        <beta>w\|</beta>
        <unic>&#x1FF2;</unic>
        <unid>&#x03C9;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w\</beta>
        <unic>&#x1F7C;</unic>
        <unid>&#x03C9;&#x0300;</unid>
      </entry>
      <entry>
        <beta>w=|</beta>
        <unic>&#x1FF7;</unic>
        <unid>&#x03C9;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w=</beta>
        <unic>&#x1FF6;</unic>
        <unid>&#x03C9;&#x0342;</unid>
      </entry>
      <entry>
        <beta>w|</beta>
        <unic>&#x1FF3;</unic>
        <unid>&#x03C9;&#x0345;</unid>
      </entry>
      <entry>
        <beta>w</beta>
        <unic>&#x03C9;</unic>
        <unid>&#x03C9;</unid>
      </entry>
      <entry>
        <beta>x*</beta>
        <unic>&#x03A7;</unic>
        <unid>&#x03A7;</unid>
      </entry>
      <entry>
        <beta>x</beta>
        <unic>&#x03C7;</unic>
        <unid>&#x03C7;</unid>
      </entry>
      <entry>
        <beta>y*</beta>
        <unic>&#x03A8;</unic>
        <unid>&#x03A8;</unid>
      </entry>
      <entry>
        <beta>y</beta>
        <unic>&#x03C8;</unic>
        <unid>&#x03C8;</unid>
      </entry>
      <entry>
        <beta>z*</beta>
        <unic>&#x0396;</unic>
        <unid>&#x0396;</unid>
      </entry>
      <entry>
        <beta>z</beta>
        <unic>&#x03B6;</unic>
        <unid>&#x03B6;</unid>
      </entry>
      <!--
          entries for diacritics only
          here <unic> holds non-combining form,
          <unid> holds combining form 
      -->
      <entry>
        <beta>(/|</beta>
        <unic>&#x1FDE;&#x0345;</unic>
        <unid>&#x0314;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>(/</beta>
        <unic>&#x1FDE;</unic>
        <unid>&#x0314;&#x0301;</unid>
      </entry>
      <entry>
        <beta>(\|</beta>
        <unic>&#x1FDD;&#x0345;</unic>
        <unid>&#x0314;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>(\</beta>
        <unic>&#x1FDD;</unic>
        <unid>&#x0314;&#x0300;</unid>
      </entry>
      <entry>
        <beta>(=|</beta>
        <unic>&#x1FDF;&#x0345;</unic>
        <unid>&#x0314;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>(=</beta>
        <unic>&#x1FDF;</unic>
        <unid>&#x0314;&#x0342;</unid>
      </entry>
      <entry>
        <beta>(|</beta>
        <unic>&#x02BD;&#x0345;</unic>
        <unid>&#x0314;&#x0345;</unid>
      </entry>
      <entry>
        <beta>(</beta>
        <unic>&#x02BD;</unic>
        <unid>&#x0314;</unid>
      </entry>
      <entry>
        <beta>)/|</beta>
        <unic>&#x1FCE;&#x0345;</unic>
        <unid>&#x0313;&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>)/</beta>
        <unic>&#x1FCE;</unic>
        <unid>&#x0313;&#x0301;</unid>
      </entry>
      <entry>
        <beta>)\|</beta>
        <unic>&#x1FCD;&#x0345;</unic>
        <unid>&#x0313;&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>)\</beta>
        <unic>&#x1FCD;</unic>
        <unid>&#x0313;&#x0300;</unid>
      </entry>
      <entry>
        <beta>)=|</beta>
        <unic>&#x1FCF;&#x0345;</unic>
        <unid>&#x0313;&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>)=</beta>
        <unic>&#x1FCF;</unic>
        <unid>&#x0313;&#x0342;</unid>
      </entry>
      <entry>
        <beta>)|</beta>
        <unic>&#x02BC;&#x0345;</unic>
        <unid>&#x0313;&#x0345;</unid>
      </entry>
      <entry>
        <beta>)</beta>
        <unic>&#x02BC;</unic>
        <unid>&#x0313;</unid>
      </entry>
      <entry>
        <beta>+/</beta>
        <unic>&#x1FEE;</unic>
        <unid>&#x0308;&#x0301;</unid>
      </entry>
      <entry>
        <beta>+\</beta>
        <unic>&#x1FED;</unic>
        <unid>&#x0308;&#x0300;</unid>
      </entry>
      <entry>
        <beta>+=</beta>
        <unic>&#x1FC1;</unic>
        <unid>&#x0308;&#x0342;</unid>
      </entry>
      <entry>
        <beta>+</beta>
        <unic>&#x00A8;</unic>
        <unid>&#x0308;</unid>
      </entry>
      <entry>
        <beta>/|</beta>
        <unic>&#x00B4;&#x0345;</unic>
        <unid>&#x0301;&#x0345;</unid>
      </entry>
      <entry>
        <beta>/</beta>
        <unic>&#x00B4;</unic>
        <unid>&#x0301;</unid>
      </entry>
      <entry>
        <beta>\|</beta>
        <unic>&#x0060;&#x0345;</unic>
        <unid>&#x0300;&#x0345;</unid>
      </entry>
      <entry>
        <beta>\</beta>
        <unic>&#x0060;</unic>
        <unid>&#x0300;</unid>
      </entry>
      <entry>
        <beta>=|</beta>
        <unic>&#x1FC0;&#x0345;</unic>
        <unid>&#x0342;&#x0345;</unid>
      </entry>
      <entry>
        <beta>=</beta>
        <unic>&#x1FC0;</unic>
        <unid>&#x0342;</unid>
      </entry>
      <entry>
        <beta>|</beta>
        <unic>&#x1FBE;</unic>
        <unid>&#x0345;</unid>
      </entry>
      <entry>
        <beta>_</beta>
        <unic>&#x00AF;</unic>
        <unid>&#x0304;</unid>
      </entry>
      <entry>
        <beta>^</beta>
        <unic>&#x02D8;</unic>
        <unid>&#x0306;</unid>
      </entry>
      <entry>
        <beta>&apos;</beta>
        <unic>&#x1FBD;</unic>
        <unid>&#x1FBD;</unid>
      </entry>
      <!--
        entries for character forms in the extended Greek page
        that also appear in the regular Greek page
        These ensure that alternate encodings are properly
        translated to betacode, since only the preferred
        encoding from the regular page is listed above.
        These should appear last since the beta-to-unicode
        encoding uses the first entry found.
      -->
      <entry>
        <beta>a*/</beta>
        <unic>&#x1FBB;</unic>
        <unid>&#x1FBB;</unid>
      </entry>
      <entry>
        <beta>a/</beta>
        <unic>&#x1F71;</unic>
        <unid>&#x1F71;</unid>
      </entry>
      <entry>
        <beta>e*/</beta>
        <unic>&#x1FC9;</unic>
        <unid>&#x1FC9;</unid>
      </entry>
      <entry>
        <beta>e/</beta>
        <unic>&#x1F73;</unic>
        <unid>&#x1F73;</unid>
      </entry>
      <entry>
        <beta>h*/</beta>
        <unic>&#x1FCB;</unic>
        <unid>&#x1FCB;</unid>
      </entry>
      <entry>
        <beta>h/</beta>
        <unic>&#x1F75;</unic>
        <unid>&#x1F75;</unid>
      </entry>
      <entry>
        <beta>i*/</beta>
        <unic>&#x1FDB;</unic>
        <unid>&#x1FDB;</unid>
      </entry>
      <entry>
        <beta>i/</beta>
        <unic>&#x1F77;</unic>
        <unid>&#x1F77;</unid>
      </entry>
      <entry>
        <beta>i+/</beta>
        <unic>&#x1FD3;</unic>
        <unid>&#x1FD3;</unid>
      </entry>
      <entry>
        <beta>o*/</beta>
        <unic>&#x1FF9;</unic>
        <unid>&#x1FF9;</unid>
      </entry>
      <entry>
        <beta>o/</beta>
        <unic>&#x1F79;</unic>
        <unid>&#x1F79;</unid>
      </entry>
      <entry>
        <beta>s</beta>
        <unic>&#x03C2;</unic>
        <unid>&#x03C2;</unid>
      </entry>
      <entry>
        <beta>u*/</beta>
        <unic>&#x1FEB;</unic>
        <unid>&#x1FEB;</unid>
      </entry>
      <entry>
        <beta>u/</beta>
        <unic>&#x1F7B;</unic>
        <unid>&#x1F7B;</unid>
      </entry>
      <entry>
        <beta>u+/</beta>
        <unic>&#x1FE3;</unic>
        <unid>&#x1FE3;</unid>
      </entry>
      <entry>
        <beta>w*/</beta>
        <unic>&#x1FFB;</unic>
        <unid>&#x1FFB;</unid>
      </entry>
      <entry>
        <beta>w/</beta>
        <unic>&#x1F7D;</unic>
        <unid>&#x1F7D;</unid>
      </entry>
      <!--
        entries for special betacodes
      -->
      <!-- medial sigma -->
      <entry>
        <beta>s1</beta>
        <unic>&#x03C3;</unic>
        <unid>&#x03C3;</unid>
      </entry>
      <!-- final sigma -->
      <entry>
        <beta>s2</beta>
        <unic>&#x03C2;</unic>
        <unid>&#x03C2;</unid>
      </entry>
    </beta-uni-table>
  </xsl:variable>
  <xsl:variable name="beta-uni-table"
    select="exsl:node-set($raw-table)/beta-uni-table"/>

  <!--
    Insert betacode diacritic character in sorted order in string
    Parameters:
      $string       existing string
      $char         character to be inserted

    Output:
      updated string with character inserted in canonical order
  -->
  <xsl:template name="insert-diacritic">
    <xsl:param name="string"/>
    <xsl:param name="char"/>

    <xsl:choose>
      <!-- if empty string, use char -->
      <xsl:when test="string-length($string) = 0">
        <xsl:value-of select="$char"/>
      </xsl:when>

      <xsl:otherwise>
        <!-- find order of char and head of string -->
        <xsl:variable name="head" select="substring($string, 1, 1)"/>
        <xsl:variable name="charOrder">
          <xsl:call-template name="beta-order">
            <xsl:with-param name="beta" select="$char"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="headOrder">
          <xsl:call-template name="beta-order">
            <xsl:with-param name="beta" select="$head"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
          <!-- if new char is greater than head, insert it in remainder -->
          <xsl:when test="number($charOrder) > number($headOrder)">
            <xsl:variable name="tail">
              <xsl:call-template name="insert-diacritic">
                <xsl:with-param name="string" select="substring($string, 2)"/>
                <xsl:with-param name="char" select="$char"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat($head, $tail)"/>
          </xsl:when>

          <!-- if same as head, discard it (don't want duplicates) -->
          <xsl:when test="number($charOrder) = number($headOrder)">
            <xsl:value-of select="$string"/>
          </xsl:when>

          <!-- if new char comes before head -->
          <xsl:otherwise>
            <xsl:value-of select="concat($char, $string)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    Define canonical order of betacode diacritics
    Parameter:
      $beta        betacode diacritic character

    Output:
      numerical order of character in canonical ordering
  -->
  <xsl:template name="beta-order">
    <xsl:param name="beta"/>
    <xsl:choose>
      <!-- capitalization -->
      <xsl:when test="$beta = '*'">0</xsl:when>
      <!-- dasia -->
      <xsl:when test="$beta = '('">1</xsl:when>
      <!-- psili -->
      <xsl:when test="$beta = ')'">2</xsl:when>
      <!-- diaeresis -->
      <xsl:when test="$beta = '+'">3</xsl:when>
      <!-- acute -->
      <xsl:when test="$beta = '/'">4</xsl:when>
      <!-- grave -->
      <xsl:when test="$beta = '\'">5</xsl:when>
      <!-- perispomeni -->
      <xsl:when test="$beta = '='">6</xsl:when>
      <!-- ypogegrammeni -->
      <xsl:when test="$beta = '|'">7</xsl:when>
      <!-- macron -->
      <xsl:when test="$beta = '_'">8</xsl:when>
      <!-- breve -->
      <xsl:when test="$beta = '^'">9</xsl:when>
      <!-- koronis -->
      <xsl:when test="$beta = &quot;&apos;&quot;">10</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
    Strip vowel length diacritics from betacode
    Parameters:
    $input        string to strip
  -->
  <xsl:template name="beta-strip-length">
    <xsl:param name="input"/>
    <xsl:value-of select="translate($input,
                                    $beta-with-length,
                                    $beta-without-length)"/>
  </xsl:template>

  <!--
    Strip vowel length diacritics from unicode
    Parameters:
    $input        string to strip
  -->
  <xsl:template name="uni-strip-length">
    <xsl:param name="input"/>
    <xsl:value-of select="translate($input,
                                    $uni-with-length,
                                    $uni-without-length)"/>
  </xsl:template>

  <!--
    Convert betacode to unicode
    Parameters:
    $key          combined character plus diacritics
    $precomposed  whether to put out precomposed or decomposed Unicode
  -->
  <xsl:template match="beta-uni-table" mode="b2u">
    <xsl:param name="key"/>
    <xsl:param name="precomposed"/>

    <xsl:variable name="keylen" select="string-length($key)"/>

    <!-- if key exists -->
    <xsl:if test="$keylen > 0">
      <!-- try to find key in table -->
      <xsl:variable name="value">
        <xsl:choose>
          <xsl:when test="$precomposed">
            <xsl:value-of select="(key('beta-uni-lookup', $key)/unic)[1]/text()"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="(key('beta-uni-lookup', $key)/unid)[1]/text()"
            />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <!-- if key found, use value -->
        <xsl:when test="string-length($value) > 0">
          <xsl:value-of select="$value"/>
        </xsl:when>

        <!-- if key not found and contains multiple chars -->
        <xsl:when test="$keylen > 1">
          <!-- lookup key with last char removed -->
          <xsl:apply-templates select="$beta-uni-table" mode="b2u">
            <xsl:with-param name="key" select="substring($key, 1, $keylen - 1)"/>
            <xsl:with-param name="precomposed" select="$precomposed"/>
          </xsl:apply-templates>
          <!-- convert last char -->
          <!-- precomposed=false means make sure it's a combining form -->
          <xsl:apply-templates select="$beta-uni-table" mode="b2u">
            <xsl:with-param name="key" select="substring($key, $keylen)"/>
            <xsl:with-param name="precomposed" select="false()"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>

      <!-- otherwise, ignore it (probably an errant *) -->
    </xsl:if>
  </xsl:template>

  <!--
    Convert unicode to betacode
    Parameters:
    $key          Unicode character to look up
  -->
  <xsl:template match="beta-uni-table" mode="u2b">
    <xsl:param name="key"/>
    <xsl:value-of select="(key('unic-beta-lookup', $key)/beta)[1]/text()"/>
  </xsl:template>

</xsl:stylesheet>
