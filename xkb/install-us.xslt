<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"/>

  <xsl:template match="/xkbConfigRegistry/layoutList/layout[configItem/name = 'us']/variantList">
    <xsl:element name="variantList">
      <xsl:apply-templates select="*|text()" />

      <xsl:text>  </xsl:text>
      <xsl:element name="variant">
        <xsl:text>
          </xsl:text>
          <xsl:element name="configItem">
            <xsl:text>
            </xsl:text>
            <xsl:element name="name">
              <xsl:text>mac_avm</xsl:text>
            </xsl:element>
            <xsl:text>
            </xsl:text>
            <xsl:element name="description">
              <xsl:text>English (Macintosh, Alexey Martynov)</xsl:text>
            </xsl:element>
            <xsl:text>
          </xsl:text>
          </xsl:element>
          <xsl:text>
        </xsl:text>
      </xsl:element>
      <xsl:text>
      </xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
