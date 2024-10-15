(:26:)
(:for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT:)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:27:)
(:for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:28:)
(:for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, 'A')]:)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:29:)
(:for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, substring(STOLICA, 1, 1))]:)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:30:)
(:for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/swiat.xml')//KRAJ:)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:31:)
(:doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml'):)

(:32:)
(:doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:33:)
(:doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)

(:34:)
(:count(doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP='10']/PRACOWNICY/ROW):)

(:35:)
(:doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_SZEFA='100']/NAZWISKO:)

(:36:)
for $k in doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')/ZESPOLY/ROW[ID_ZESP=
doc('file:///C:/Users/neuba/Documents/semestr9/ZTPD/lab/kod/8_XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]

return sum($k/PRACOWNICY/ROW/PLACA_POD)
