# Teinte, TEI shades, XSL pack

[teinte_xsl](https://github.com/oeuvres/teinte_xsl/) is an XSLT-1.0 pack to transform TEI documents, from, and to, different formats.


![Teinte xsl graph](docs/teinte_xsl.png)

This pack ic compatible with xsltproc and other XSLT engine. Tested with
 * PHP: [teinte_php](https://github.com/oeuvres/teinte_php)
 * Java: [alix](https://github.com/oeuvres/alix)
 * Python: a command line pilot for Python is planned, needs support [teinte_py](https://github.com/oeuvres/teinte_py)
 * Javascript: direct transformation in browser (see below)
 * Bash: (see below)

# Browser

All modern browsers has the xsltproc library embedded. This allows to provide direct transformations in the browser. Visit for example this [example XML file](https://oeuvres.github.io/teinte_xsl/tests/moliere_misanthrope.xml) under a web server, you should see a nicely formatted theatre play, even if it’s an [XML/TEI source](https://github.com/oeuvres/teinte_xsl/tests/moliere_misanthrope.xml).

![Teinte xsl graph](docs/teinte_misanthrope.png)

The magic rely on the XML prolog of the file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Link to a transformation for the browser -->
<?xml-stylesheet type="text/xsl" href="http://oeuvres.github.io/teinte_xsl/tei_html.xsl"?>
```

