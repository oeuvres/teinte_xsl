<?xml version="1.0" encoding="UTF-8"?>
<!--

LGPL  http://www.gnu.org/licenses/lgpl.html
© 2013 Frederic.Glorieux@fictif.org et LABEX OBVIL

Extraction du texte d'un corpus TEI pour recherche plein texte ou traitements linguistiques
(ex : suppressions des notes, résolution de l'apparat)
Doit pouvoir fonctionner en import.


-->
<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei"
  >
  <!-- Importer des dates -->
  <xsl:import href="tei2iramuteq.xsl"/>
  
  <xsl:template match="/">
    <xsl:call-template name="roles"/>
  </xsl:template>
  
  <xsl:template name="roles">
    <xsl:for-each select="//tei:role[@xml:id]">
      <xsl:variable name="id" select="@xml:id"/>
      <xsl:variable name="sp" select="key('who', $id)"/>
      <xsl:if test="count($sp) &gt; $minsp">
        <xsl:value-of select="$docid"/>
        <xsl:value-of select="$tab"/>
        <xsl:value-of select="@xml:id"/>
        <xsl:value-of select="$tab"/>
        <xsl:call-template name="gender"/>
        <xsl:value-of select="$tab"/>
        <xsl:call-template name="age"/>
        <xsl:value-of select="$tab"/>
        <xsl:call-template name="status"/>
        <xsl:value-of select="$tab"/>
        <xsl:call-template name="function"/>
        <xsl:value-of select="$tab"/>
        <xsl:variable name="txt">
          <xsl:for-each select="$sp">
            <xsl:value-of select="$lf"/>
            <xsl:apply-templates mode="iramuteq"/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="string-length(normalize-space($txt))"/>
        <xsl:value-of select="$lf"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="scenes">
    <xsl:for-each select="//*[@type = 'scene']">
      <xsl:value-of select="$docid"/>
      <xsl:value-of select="$tab"/>
      <xsl:value-of select="@xml:id"/>
      <xsl:value-of select="$tab"/>
      <xsl:variable name="txt">
        <xsl:apply-templates mode="iramuteq"/>
      </xsl:variable>
      <xsl:value-of select="string-length(normalize-space($txt))"/>
      <xsl:value-of select="$lf"/>
    </xsl:for-each>
  </xsl:template>
  </xsl:transform>