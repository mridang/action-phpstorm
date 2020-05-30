<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings">
  <xsl:output method="text" encoding="iso-8859-1"/>
  <!-- https://stackoverflow.com/a/5738296/304151 -->
  <xsl:template match="*/text()[normalize-space()]">
      <xsl:value-of select="normalize-space()"/>
  </xsl:template>
  <xsl:template match="*/text()[not(normalize-space())]" />
  <xsl:template match="problem">
    <xsl:value-of select="file"/>
    <!-- https://stackoverflow.com/a/25690036/304151 -->
    <xsl:if test="position () &lt; last()">
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
