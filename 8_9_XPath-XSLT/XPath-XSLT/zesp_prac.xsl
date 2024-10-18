<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:template match='/'>
    <html>
        <head>
            <link href="swiat.css" rel="stylesheet" type="text/css"/>
        </head>

        <body>
            <h1 style="text-align: center;">Zespoły:</h1>

<!--            6b-->
            <ol> <xsl:apply-templates select="ZESPOLY/ROW" mode="list"/> </ol>

<!--            7-->
            <xsl:apply-templates select="ZESPOLY/ROW" mode="details"/>

<!--            6a-->
<!--            <ol><xsl:for-each select="ZESPOLY/ROW">-->
<!--                <li><xsl:value-of select="NAZWA"/></li>-->
<!--            </xsl:for-each></ol>-->

        </body>
    </html>
    </xsl:template>

<!--    6b-->
    <xsl:template match="*" mode="list">
            <li><a href="#{NAZWA}"><xsl:value-of select="NAZWA"/></a></li>
    </xsl:template>

<!--    7-->
    <xsl:template match="*" mode="details">
        <div>
            <h2 id="{NAZWA}">NAZWA: <xsl:value-of select="NAZWA"/></h2>
            <h2>ADRES: <xsl:value-of select="ADRES"/></h2>

<!--            14-->
            <xsl:if test="count(PRACOWNICY/ROW) > 0">

<!--            8-->
            <table>
                <tr><th>Nazwisko</th><th>Etat</th><th>Zatrudniony</th><th>Placa pod.</th><th>Id szefa</th></tr>
                <xsl:apply-templates select="PRACOWNICY/ROW" mode="workers_table">
<!--                    10-->
                    <xsl:sort select="NAZWISKO"/>
                </xsl:apply-templates>
            </table>

            </xsl:if>

<!--            13-->
            Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>

        </div>
    </xsl:template>

<!--    8-->
    <xsl:template match="*" mode="workers_table">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
<!--            <td><xsl:value-of select="ID_SZEFA"/></td>-->
<!--            11-->
            <td><xsl:call-template name="getBossName"><xsl:with-param name="bossId" select="ID_SZEFA"/></xsl:call-template></td>
        </tr>
    </xsl:template>

<!--    11-->
    <xsl:template name="getBossName">
        <xsl:param name="bossId"/>
        <!--        <xsl:value-of select="//ROW[ID_PRAC=$bossId]/NAZWISKO"/>-->

<!--        12-->
        <xsl:choose>
            <xsl:when test="$bossId != ''">
                <xsl:value-of select="//ROW[ID_PRAC=$bossId]/NAZWISKO"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>brak</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>