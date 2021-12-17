<?xml version="1.0" encoding="UTF-8"?>
<!--

Produce a valid xhtml fragment <article>, ready to be included in a page
Just the /TEI/text content (with footnotes) but no /html/head or toc.

BSD-3-Clause https://opensource.org/licenses/BSD-3-Clause
© 2019 Frederic.Glorieux@fictif.org & LABEX OBVIL & Optéos
© 2013 Frederic.Glorieux@fictif.org & LABEX OBVIL
© 2012 Frederic.Glorieux@fictif.org
© 2010 Frederic.Glorieux@fictif.org & École nationale des chartes
© 2007 Frederic.Glorieux@fictif.org
© 2005 ajlsm.com (Cybertheses)

XSLT 1.0, compatible browser, PHP, Python, Java…
-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
  <xsl:import href="html/flow.xsl"/>
  <xsl:import href="html/notes.xsl"/>
  <!--
  <xsl:include href="common.xsl"/>
  -->
  <!-- Name of this xsl  -->
  <xsl:param name="this">tei2html.xsl</xsl:param>
  <!-- Maybe used as a body class -->
  <xsl:param name="folder"/>
  <!--  -->
  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="yes"/>
  <!-- Racine -->
  <xsl:template match="/*">
    <xsl:variable name="bodyclass">
      <xsl:value-of select="$corpusid"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$folder"/>
    </xsl:variable>
    <article>
      <xsl:call-template name="att-lang"/>
      <xsl:if test="normalize-space($bodyclass)">
        <xsl:attribute name="class">
          <xsl:value-of select="normalize-space($bodyclass)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </article>
  </xsl:template>

  <xsl:template match="tei:text">
    <xsl:param name="level" select="count(ancestor::tei:group)"/>
    <article>
      <xsl:attribute name="id">
        <xsl:call-template name="id"/>
      </xsl:attribute>
      <xsl:call-template name="atts"/>
      <xsl:apply-templates select="*">
        <xsl:with-param name="level" select="$level +1"/>
      </xsl:apply-templates>
      <!-- groupes de textes, procéder les notes par textes -->
      <xsl:if test="not(tei:group)">
        <!-- No notes in teiHeader ? -->
        <xsl:call-template name="footnotes"/>
      </xsl:if>
    </article>
  </xsl:template>
</xsl:transform>
