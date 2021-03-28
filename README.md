# LaTeXML-MathWebSearch-Docker

A Docker Image for the LaTeXML part of MathWebSearch. 

It is published on GitHub Packages as the automated build [mathwebsearch/latexml](ghcr.io/mathwebsearch/latexml) and can be run as:

```
    docker run -p 8080:8080 ghcr.io/mathwebsearch/latexml
```

When a full texlive is needed, you can also use:

```
    docker run -p 8080:8080 ghcr.io/mathwebsearch/latexml:withtexlive
```