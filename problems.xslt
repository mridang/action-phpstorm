<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings">
  <xsl:output method="text" encoding="iso-8859-1"/>
  <!-- https://stackoverflow.com/a/5738296/304151 -->
  <xsl:template match="*/text()[normalize-space()]">
      <xsl:value-of select="normalize-space()"/>
  </xsl:template>

  <xsl:template match="*/text()[not(normalize-space())]" />
  <xsl:template match="problem">
    <xsl:text>::</xsl:text>
    <xsl:text>warning </xsl:text>
    <xsl:text>file=</xsl:text>
    <xsl:value-of select="str:replace (file, 'file://$PROJECT_DIR$', '')"/>
    <xsl:text>,line=</xsl:text>
    <xsl:value-of select="line"/>
    <xsl:text>::</xsl:text>
    <xsl:value-of select="description" disable-output-escaping="yes"/>
    <!-- https://stackoverflow.com/a/25690036/304151 -->
    <xsl:if test="position () &lt; last()">
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
