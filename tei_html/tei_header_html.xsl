<?xml version="1.0" encoding="UTF-8"?>
<!--
  
Interpret TEI header as html.

Part of Teinte https://github.com/oeuvres/teinte
BSD-3-Clause https://opensource.org/licenses/BSD-3-Clause
© 2012, 2015 Frédéric Glorieux

-->
<xsl:transform version="1.0"   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 

  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="tei"
>
  <xsl:param name="publisher"/>
  <xsl:param name="licence"/>
  <xsl:variable name="up" >ABCDEFGHIJKLMNOPQRSTUVWXYZÀÂÄÉÈÊÏÎÔÖÛÜÇÆŒàâäéèêëïîöôüûæœ_ ,.'’ #</xsl:variable>
  <xsl:variable name="low">abcdefghijklmnopqrstuvwxyzaaaeeeiioouuceeaaaeeeeiioouuee_</xsl:variable>
  <!-- 
<h3>teiHeader</h3>
  -->
  <xsl:template match="tei:TEI|tei:TEI.2" priority="-1">
    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc"/>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader" priority="-1">
    <header class="center">
      <xsl:variable name="biblStruct" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct[1]"/>
      <div class="titleresp">
        <h1 class="title">
          <xsl:choose>
            <xsl:when test="$biblStruct/tei:analytic">
              <xsl:apply-templates select="$biblStruct/tei:analytic/tei:title/node()"/>
            </xsl:when>
            <xsl:when test="$biblStruct/tei:monogr">
              <xsl:apply-templates select="$biblStruct/tei:monogr/tei:title/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </h1>
        <p class="authors">
          <xsl:choose>
            <xsl:when test="$biblStruct/tei:analytic">
              <xsl:for-each select="$biblStruct/tei:analytic/tei:author">
                <xsl:if test="position() != 1">, </xsl:if>
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="$biblStruct/tei:monogr/tei:author">
              <xsl:for-each select="$biblStruct/tei:analytic/tei:author">
                <xsl:if test="position() != 1">, </xsl:if>
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$biblStruct/tei:monogr/tei:author">
                <xsl:if test="position() != 1">, </xsl:if>
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>.</xsl:text>
        </p>
        <p class="date">
          <xsl:variable name="date" select="/*/tei:teiHeader/tei:profileDesc/tei:creation/tei:date"/>
          <xsl:text>(</xsl:text>
          <xsl:choose>
            <xsl:when test="$biblStruct/@type = 'book' and $date/@when">
              <xsl:value-of select="substring($date/@when, 1, 4)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$date"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>)</xsl:text>
        </p>
      </div>
      <xsl:if test="/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl">
        <p class="bibl">
          <span>Réf. originale : </span>
          <xsl:apply-templates select="/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl[1]/node()"/>
        </p>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$publisher">
          <p class="publisher">
            <xsl:copy-of select="$publisher"/>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$licence">
          <p class="licence">
            <xsl:copy-of select="$licence"/>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
        </xsl:otherwise>
      </xsl:choose>
    </header>
  </xsl:template>
  <xsl:template match="tei:teiHeader//tei:title" priority="-1">
    <cite>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </cite>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:*" priority="-1">
    <div>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <!-- Réordonner le bloc de description du fichier -->
  <xsl:template match="tei:fileDesc">
    <xsl:param name="el">div</xsl:param>
    <xsl:choose>
      <xsl:when test="normalize-space(.) = ''"/>
      <xsl:otherwise>
        <xsl:element name="{$el}" namespace="http://www.w3.org/1999/xhtml">
          <xsl:call-template name="headatts"/>
          <!-- Envoyer la page de titre -->
          <xsl:apply-templates select="tei:titleStmt"/>
          <xsl:apply-templates select="tei:publicationStmt"/>
          <xsl:apply-templates select="tei:sourceDesc"/>
          <xsl:apply-templates select="tei:notesStmt"/>
          <xsl:apply-templates select="tei:editionStmt"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:notesStmt">
    <div class="headnotes">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="tei:notesStmt/tei:note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="tei:teiHeader // tei:bibl // tei:note">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <!-- Liste of revisions -->
  <xsl:template match="tei:revisionDesc">
    <table>
      <xsl:call-template name="headatts">
        <xsl:with-param name="class">data</xsl:with-param>
      </xsl:call-template>
      <caption class="revisionDesc">
      </caption>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <!-- Liste spéciale, journal des modifications  -->
  <xsl:template match="tei:change">
    <tr>
      <xsl:call-template name="headatts"/>
      <td>
        <xsl:value-of select="@when"/>
      </td>
      <td>
        <xsl:apply-templates select="@who" mode="anchors"/>
      </td>
      <td>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title">
    <xsl:choose>
      <xsl:when test="@type= 'formal' or @type='reference' or @type='DEAF' or @type='gmd'"/>
      <xsl:otherwise>
        <h1>
          <xsl:choose>
            <xsl:when test="@type">
              <xsl:attribute name="class">
                <xsl:value-of select="@type"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="../tei:title[@type='main']">
              <xsl:attribute name="class">notmain</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:variable name="uri">
            <xsl:choose>
              <xsl:when test="../../tei:publicationStmt/tei:idno">
                <xsl:value-of select="../../tei:publicationStmt/tei:idno"/>
              </xsl:when>
              <xsl:when test="../../tei:editionStmt/tei:edition/@xml:base">
                <xsl:value-of select="../../tei:editionStmt/tei:edition/@xml:base"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$uri != ''">
              <a href="{$uri}">
                <xsl:apply-templates/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </h1>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:publicationStmt/tei:publisher">
    <p class="publisher">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- Bloc de publication, réordonné -->
  <xsl:template match="tei:fileDesc/tei:publicationStmt">
    <xsl:choose>
      <!-- bug -->
      <xsl:when test="normalize-space(.) =''"/>
      <xsl:when test="tei:distributor">
        <div>
          <xsl:call-template name="headatts"/>
          <xsl:for-each select="*">
            <div>
              <xsl:call-template name="headatts"/>
              <xsl:apply-templates/>
            </div>
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:when test="tei:p">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <xsl:call-template name="headatts"/>
          <xsl:if test="tei:idno">
            <div class="idno">
              <xsl:for-each select="tei:idno">
                <xsl:apply-templates select="."/>
                <xsl:choose>
                  <xsl:when test="position() = last()">.</xsl:when>
                  <xsl:otherwise>, </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </div>
          </xsl:if>
          <div class="imprint">
            <xsl:for-each select="tei:publisher">
              <xsl:if test="position() != 1">, </xsl:if>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:if test="tei:date">, </xsl:if>
            <xsl:apply-templates select="tei:date"/>
            <xsl:if test="tei:availability/tei:licence[@target]">, </xsl:if>
            <xsl:apply-templates select="tei:availability/tei:licence"/>
            <xsl:text>.</xsl:text>
          </div>
          <!--
          <xsl:apply-templates select="../tei:sourceDesc"/>
          <xsl:apply-templates select="../tei:extent"/>
          <xsl:apply-templates select="tei:publisher"/>
          <xsl:apply-templates select="tei:address"/>
          <xsl:apply-templates select="tei:availability"/>
          -->
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Section avec titre prédéfini -->
  <xsl:template match="tei:encodingDesc"/>
  <xsl:template match="tei:availability | tei:editorialDecl | tei:projectDesc | tei:samplingDecl ">
    <xsl:param name="el">div</xsl:param>
    <xsl:element name="{$el}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- éléments teiHeader retenus -->
  <xsl:template match="tei:charDecl | tei:langUsage | tei:catRef"/>
  <!-- Ligne avec intitulé -->
  <xsl:template match="tei:sourceDesc">
    <xsl:choose>
      <xsl:when test="tei:bibl/tei:ref">
        <div>
          <xsl:call-template name="headatts"/>
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <!-- Paul Fièvre, temporaire -->
      <xsl:when test="tei:permalien | tei:inspiration | tei:genre"/>
      <xsl:when test="normalize-space(.) = ''"/>
      <xsl:otherwise>
        <p>
          <xsl:call-template name="headatts"/>
          <xsl:choose>
            <xsl:when test="tei:bibl">
              <xsl:for-each select="tei:bibl">
                <xsl:apply-templates select="./node()"/>
                <xsl:if test="position()!=last()"><br/></xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="tei:msDesc">
              <xsl:apply-templates select="tei:msDesc[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </p>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:msDesc">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates select="tei:msContents"/>
      <xsl:apply-templates select="tei:msIdentifier"/>
    </span>
  </xsl:template>
  <xsl:template match="tei:msContents">
    <xsl:choose>
      <xsl:when test="tei:p/tei:biblStruct">
        <xsl:apply-templates select="tei:p/tei:biblStruct"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:biblStruct">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="tei:monogr | tei:analytic">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:for-each select="*[not(@type = 'titre_court')]">
        <xsl:apply-templates select="."/>
        <xsl:variable name="last" select="substring(normalize-space(.), string-length(normalize-space(.)) ) "/>
        <xsl:choose>
          <xsl:when test="translate($last, '.,;?!', '') = ''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>. </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </span>
  </xsl:template>
  <xsl:template match="tei:licence">
    <p>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!-- Éléments avec intitulé -->
  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:funder | tei:fileDesc/tei:titleStmt/tei:edition | tei:fileDesc/tei:titleStmt/tei:editor | tei:fileDesc/tei:titleStmt/tei:extent">
    <div>
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="tei:titleStmt/tei:author" priority="3">
    <xsl:variable name="author">
      <xsl:call-template name="header_name"/>
    </xsl:variable>
    <xsl:if test="$author != ''">
      <p>
        <xsl:call-template name="headatts"/>
        <xsl:copy-of select="$author"/>
      </p>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="header_name">
    <xsl:choose>
      <xsl:when test="normalize-space(.) != ''">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="@key">
        <xsl:choose>
          <xsl:when test="contains(@key, '(')">
            <xsl:value-of select="normalize-space(substring-before(@key, '('))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(@key)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- Différents titres de responsabilité intellectuelle -->
  <xsl:template match="
  tei:fileDesc/tei:titleStmt/tei:editor[position() != 1]
| tei:fileDesc/tei:titleStmt/tei:principal[position() != 1]
| tei:fileDesc/tei:titleStmt/tei:sponsor[position() != 1]
    "/>
  <xsl:template match="
  tei:fileDesc/tei:titleStmt/tei:editor[1]
| tei:fileDesc/tei:titleStmt/tei:principal[1]
| tei:fileDesc/tei:titleStmt/tei:sponsor[1]
    ">
    <div>
      <xsl:call-template name="headatts"/>
      <xsl:variable name="name" select="local-name()"/>
      <xsl:apply-templates/>
      <xsl:for-each select="following-sibling::*[local-name() = $name]">
        <xsl:choose>
          <xsl:when test="following-sibling::*[local-name() = $name]">, </xsl:when>
          <xsl:otherwise>
            <xsl:text> &amp; </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="header_name"/>
      </xsl:for-each>
      <!--
      <xsl:text>.</xsl:text>
      -->
    </div>
  </xsl:template>

  <!-- Les liens dans un <teiHeader> pour une page de titre sont généralement absolus -->
  <xsl:template match="tei:teiHeader//tei:ref">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  <xsl:template match="tei:teiHeader//tei:hi">
    <xsl:variable name="rend" select="translate(@rend, $up, $low)"></xsl:variable>
    <xsl:choose>
      <xsl:when test=". =''"/>
      <!-- si @rend est un nom d'élément HTML -->
      <xsl:when test="contains( ' b big em i s small strike strong sub sup tt u ', concat(' ', $rend, ' '))">
        <xsl:element name="{$rend}" namespace="http://www.w3.org/1999/xhtml">
          <xsl:if test="@type">
            <xsl:attribute name="class">
              <xsl:value-of select="@type"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with($rend, 'it')">
        <i>
          <xsl:apply-templates/>
        </i>
      </xsl:when>
      <xsl:when test="contains($rend, 'bold') or contains($rend, 'gras')">
        <b>
          <xsl:apply-templates/>
        </b>
      </xsl:when>
      <xsl:when test="starts-with($rend, 'ind')">
        <sub>
          <xsl:apply-templates/>
        </sub>
      </xsl:when>
      <xsl:when test="starts-with($rend, 'exp')">
        <sup>
          <xsl:apply-templates/>
        </sup>
      </xsl:when>
      <xsl:when test="@rend != ''">
        <span class="{@rend}">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <i>
          <xsl:apply-templates/>
        </i>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Réordonner la page de titre du fichier -->
  <xsl:template match="tei:fileDesc/tei:titleStmt">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = ''"/>
      <xsl:otherwise>
        <div>
          <xsl:call-template name="headatts"/>
          <!-- Reorder -->
          <xsl:apply-templates select="tei:title"/>
          <xsl:apply-templates select="tei:author"/>
          <xsl:apply-templates select="/*/tei:teiHeader[1]/tei:profileDesc[1]/tei:creation[1]"/>
          <xsl:apply-templates select="tei:editor | tei:funder | tei:meeting | tei:principal | tei:sponsor"/>
          <xsl:apply-templates select="tei:respStmt"/>
          <!--
          <xsl:if test="../tei:publicationStmt/tei:date">
            <div class="date">
              <xsl:apply-templates select="../tei:publicationStmt/tei:date"/>
            </div>
          </xsl:if>
          -->
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:fileDesc/tei:editionStmt">
    <!-- ../tei:titleStmt/tei:respStmt ??? CESR -->
    <xsl:choose>
      <xsl:when test="not(tei:respStmt/tei:name[normalize-space(.) != ''] | ../tei:titleStmt/tei:respStmt)"/>
      <xsl:otherwise>
        <p>
          <xsl:call-template name="headatts"/>
          <xsl:for-each select="../tei:titleStmt/tei:respStmt | tei:respStmt">
            <xsl:choose>
              <xsl:when test="position() = 1"/>
              <xsl:when test="position() = last()"> et </xsl:when>
              <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
              <span class="resp">
                <xsl:apply-templates select="tei:name" mode="txt"/>
                <xsl:if test="tei:resp">
                  <xsl:text> (</xsl:text>
                  <xsl:apply-templates select="tei:resp" mode="txt"/>
                  <xsl:text>)</xsl:text>
                </xsl:if>
              </span>
          </xsl:for-each>
          <xsl:text>.</xsl:text>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <!-- special CESR -->
    <xsl:if test="tei:edition/@xml:base">
      <div class="idno">
        <a href="{tei:edition/@xml:base}">
          <xsl:value-of select="tei:edition/@xml:base"/>
        </a>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:teiHeader//tei:biblFull | tei:teiHeader//tei:biblScope | tei:teiHeader//tei:collation | tei:teiHeader//tei:collection | tei:teiHeader//tei:country | tei:teiHeader//tei:dim | tei:teiHeader//tei:editor | tei:teiHeader//tei:edition | tei:teiHeader//tei:extent | tei:teiHeader//tei:funder | tei:teiHeader//tei:institution | tei:teiHeader//tei:name | tei:teiHeader//tei:persName | tei:teiHeader//tei:biblFull/tei:publicationStmt | tei:teiHeader//tei:publisher | tei:teiHeader//tei:pubPlace | tei:teiHeader//tei:repository | tei:teiHeader//tei:settlement | tei:teiHeader//tei:stamp  | tei:teiHeader//tei:biblFull/tei:seriesStmt | tei:teiHeader//tei:biblFull/tei:titleStmt | tei:teiHeader//tei:biblFull/tei:titleStmt/tei:title">
    <xsl:variable name="element">
      <xsl:choose>
        <xsl:when test="self::title">cite</xsl:when>
        <xsl:otherwise>span</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$element}">
      <xsl:call-template name="headatts"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tei:teiHeader//tei:author | tei:biblStruct//tei:author">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:choose>
        <!-- mixed -->
        <xsl:when test="../text()[normalize-space(.) != '']">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="count(*) = 1">
          <xsl:apply-templates select="*"/>
        </xsl:when>
        <xsl:when test="tei:forename and tei:surname and count(*) = 2">
          <xsl:apply-templates select="tei:forename"/>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="tei:surname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <xsl:template match="tei:msIdentifier">
    <xsl:text> </xsl:text>
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:text>(</xsl:text>
      <xsl:for-each select="*">
        <xsl:apply-templates select="."/>
        <xsl:choose>
          <xsl:when test="position() = last()"/>
          <xsl:otherwise> ; </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </span>
  </xsl:template>
  <!-- What for ?
  <xsl:template match="*[tei:surname]" mode="txt">
    <xsl:variable name="txt">
      <xsl:apply-templates select="."/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($txt)"/>
  </xsl:template>
  <xsl:template match="*[tei:surname]">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:for-each select="*">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
      </xsl:for-each>
    </span>
  </xsl:template>
  -->
  <xsl:template match="tei:imprint">
    <span>
      <xsl:call-template name="headatts"/>
      <xsl:choose>
        <xsl:when test="text()[normalize-space(.) != '']">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
            <xsl:choose>
              <xsl:when test="self::tei:pubPlace"> : </xsl:when>
              <xsl:when test="position() != last()">, </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <!-- Personne avec role -->
  <xsl:template match="tei:respStmt">
    <span class="resp">
      <xsl:choose>
        <xsl:when test="tei:name[@ref]">
          <xsl:variable name="string">
            <xsl:value-of select="substring-before(tei:name/@ref, '@')"/>
            <xsl:text>'+'\x40'+'</xsl:text>
            <xsl:value-of select="substring-after(tei:name/@ref, '@')"/>
          </xsl:variable>
          <a href="#">
            <xsl:attribute name="onmouseover">if(this.ok) return; this.href='mailto:<xsl:value-of select="$string"/>'; this.ok=true; </xsl:attribute>
            <xsl:apply-templates select="tei:name" mode="txt"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="tei:name | tei:persName" mode="txt"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="tei:resp">
        <xsl:text> (</xsl:text>
        <xsl:variable name="txt">
          <xsl:apply-templates select="tei:resp" mode="txt"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($txt)"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>
  <xsl:template match="tei:creation">
    <xsl:variable name="date">
      <xsl:apply-templates select="tei:date[1]"/>
    </xsl:variable>  
    <xsl:if test="$date != ''">
      <div class="creation">
        <xsl:copy-of select="$date"/>
      </div>
    </xsl:if>
  </xsl:template>
  <!-- Champs blocs  -->
  <xsl:template match=" tei:addrLine | tei:keywords | tei:profileDesc | tei:textClass ">
    <xsl:if test="normalize-space(.) != ''">
      <div>
        <xsl:call-template name="headatts"/>
        <xsl:apply-templates/>
        <!-- Ramener une description du projet ? -->
        <!--
        <xsl:apply-templates select="../../tei:encodingDesc/tei:projectDesc"/>
        -->
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:teiHeader" mode="title">
    <xsl:apply-templates select="tei:fileDesc/tei:titleStmt" mode="txt"/>
  </xsl:template>
  <xsl:template match="tei:fileDesc/tei:titleStmt" mode="txt">
    <xsl:choose>
      <xsl:when test="tei:author">
        <xsl:apply-templates select="tei:author" mode="txt"/>
        <xsl:text> ; </xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="tei:title" mode="txt"/>
  </xsl:template>


  <!-- CSS declaration, should be called from <head> -->
  <xsl:template match="tei:tagsDecl">
      <xsl:if test="tei:rendition[not(@scheme) or @scheme='css']">
        <style type="text/css" xml:space="preserve">
          <xsl:for-each select="tei:rendition[not(@scheme) or @scheme='css']">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </style>
      </xsl:if>
  </xsl:template>
  <xsl:template match="tei:rendition"/>
  <xsl:template match="tei:rendition[not(@scheme) or @scheme='css']">
    <xsl:text>.</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:if test="@scope">
      <xsl:text>:</xsl:text>
      <xsl:value-of select="@scope"/>
    </xsl:if>
    <xsl:text> {</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text> }</xsl:text>
  </xsl:template>
  <!-- dates -->
  <xsl:template match="tei:date" mode="txt">
    <xsl:variable name="txt">
      <xsl:apply-templates select="."/>
    </xsl:variable>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$txt"/>
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="tei:date | tei:docDate | tei:origDate">
    <xsl:variable name="el">
      <xsl:choose>
        <xsl:when test="parent::tei:div">div</xsl:when>
        <xsl:otherwise>time</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="att">title</xsl:variable>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="@cert">~</xsl:when>
        <xsl:when test="@scope">~</xsl:when>
      </xsl:choose>
      <xsl:variable name="from">
        <xsl:choose>
          <xsl:when test="@from">
            <xsl:value-of select="number(substring(@from, 1, 4))"/>
          </xsl:when>
          <xsl:when test="@notBefore">
            <xsl:value-of select="number(substring(@notBefore, 1, 4))"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="to">
        <xsl:choose>
          <xsl:when test="@to">
            <xsl:value-of select="number(substring(@to, 1, 4))"/>
          </xsl:when>
          <xsl:when test="@notAfter">
            <xsl:value-of select="number(substring(@notAfter, 1, 4))"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="when">
        <xsl:value-of select="number(substring(@when, 1, 4))"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$when != 'NaN'">
          <xsl:value-of select="$when"/>
        </xsl:when>
        <xsl:when test="$from = $to and $from != 'NaN'">
          <xsl:value-of select="$from"/>
        </xsl:when>
        <xsl:when test="$from != 'NaN' and $to != 'NaN'">
          <xsl:value-of select="$from"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$to"/>
        </xsl:when>
        <xsl:when test="$from != 'NaN'">
          <xsl:value-of select="$from"/>
          <xsl:text>/…</xsl:text>
        </xsl:when>
        <xsl:when test="$to != 'NaN'">
          <xsl:text>…–</xsl:text>
          <xsl:value-of select="$to"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test=". = '' and $value = ''"/>
      <xsl:when test=". = '' and $value != ''">
        <xsl:element name="{$el}" namespace="http://www.w3.org/1999/xhtml">
          <xsl:call-template name="headatts"/>
          <xsl:attribute name="{$att}">
            <xsl:value-of select="$value"/>
          </xsl:attribute>
          <xsl:value-of select="$value"/>
        </xsl:element>
       </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$el}" namespace="http://www.w3.org/1999/xhtml">
          <xsl:call-template name="headatts"/>
          <xsl:if test="$value != ''">
            <xsl:attribute name="{$att}">
              <xsl:value-of select="$value"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <!-- hack cesr -->
    <xsl:if test="parent::tei:resp">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <!-- identifiant bibliographique -->
  <xsl:template match="tei:idno | tei:altIdentifier">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http')">
        <a>
          <xsl:call-template name="headatts"/>
          <xsl:attribute name="href">
            <xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="@type">
              <xsl:value-of select="@type"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="headatts"/>
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="headatts">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name()"/>
    </xsl:attribute>
  </xsl:template>

</xsl:transform>
