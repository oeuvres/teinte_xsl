<?xml version="1.0" encoding="UTF-8"?>
<!--
Part of Teinte suite https://github.com/oeuvres/teinte_xsl
BSD-3-Clause https://opensource.org/licenses/BSD-3-Clause
© 2019 Frederic.Glorieux@fictif.org & LABEX OBVIL & Optéos
© 2013 Frederic.Glorieux@fictif.org & LABEX OBVIL
© 2012 Frederic.Glorieux@fictif.org
© 2010 Frederic.Glorieux@fictif.org & École nationale des chartes
© 2007 Frederic.Glorieux@fictif.org
© 2005 ajlsm.com (Cybertheses)

XSLT 1.0, compatible browser, PHP, Python, Java…
-->
<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.tei-c.org/ns/1.0"
  
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:opf="http://www.idpf.org/2007/opf"

  exclude-result-prefixes="dc dcterms opf"
  
  xmlns:exslt="http://exslt.org/common"
  xmlns:date="http://exslt.org/dates-and-times"
  extension-element-prefixes="date exslt"

  >
  <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
  
  
  <xsl:template name="opf:teiHeader" match="/*">
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <xsl:apply-templates select="dc:title"/>
          <xsl:apply-templates select="dc:creator"/>
        </titleStmt>
        <publicationStmt>
          <p>
            <xsl:text>file generated with Teinte</xsl:text>
            <xsl:if test="function-available('date:date-time')">
              <xsl:text> </xsl:text>
              <xsl:value-of select="date:date-time()"/>
            </xsl:if>
          </p>
        </publicationStmt>
        <sourceDesc>
          <bibl>
            <xsl:for-each select="dc:date">
              <date><xsl:apply-templates select="." mode="year"/></date>
              <xsl:text>, </xsl:text>
            </xsl:for-each>
            <xsl:apply-templates select="dc:publisher"/>
          </bibl>
        </sourceDesc>
      </fileDesc>
      <profileDesc>
        <xsl:apply-templates select="dc:language"/>
        <xsl:variable name="year">
          <xsl:apply-templates select="dc:date[1]" mode="year"/>
        </xsl:variable>
        <xsl:if test="$year != ''">
          <creation>
            <date when="{$year}"/>
          </creation>
        </xsl:if>
      </profileDesc>
    </teiHeader>
  </xsl:template>

  <!-- Give year -->
  <xsl:template match="dc:date" mode="year">
  <!--
    <date>
      <xsl:value-of select="substring(., 1, 4)"/>
    </date>
    -->
    <xsl:variable name="text" select="."/>
    <!-- Try to find a year -->
    <xsl:variable name="XXXX" select="translate($text,'0123456789', '##########')"/>
    <xsl:choose>
      <xsl:when test="contains($XXXX, '####')">
        <xsl:variable name="pos" select="string-length(substring-before($XXXX,'####')) + 1"/>
        <xsl:value-of select="substring($text, $pos, 4)"/>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="dc:publisher">
    <publisher>
      <xsl:apply-templates/>
    </publisher>
  </xsl:template>

  <xsl:template match="dc:language">
    <langUsage>
      <language ident="{.}"/>
    </langUsage>
  </xsl:template>

  <xsl:template match="dc:title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>
  <!-- 
  <dc:creator opf:role="aut" opf:file-as="Lambron, Marc">Marc Lambron</dc:creator>
  -->
  <xsl:template match="dc:creator">
    <author>
      <xsl:if test="@opf:file-as !=''">
        <xsl:attribute name="key">
          <xsl:value-of select="@opf:file-as"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </author>
  </xsl:template>
</xsl:transform>