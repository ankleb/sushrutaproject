<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[local-name()='l' and *[local-name()='label']]">
    
    <xsl:element name="lg" namespace="{namespace-uri()}">
      
      <xsl:element name="l" namespace="{namespace-uri()}">
        <xsl:apply-templates select="@*"/>
        
        <xsl:apply-templates select="node()[
            not(local-name()='label') and 
            not(local-name()='caesura' and preceding-sibling::*[1][local-name()='label'])
        ]"/>
      </xsl:element>
      
      <xsl:element name="trailer" namespace="{namespace-uri()}">
        <xsl:apply-templates select="*[local-name()='label']/@*"/>
        <xsl:apply-templates select="*[local-name()='label']/node()"/>
      </xsl:element>
      
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
