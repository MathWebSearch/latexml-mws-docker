## Dockerfile for latexml-plugin-ltxmojo with MathWebSearch support
## 
## By default, this image includes only the latexml-plugin-ltxmojo, 
## along with hypnotoads. To build this image, use:
##
## > docker build -t latexml-mws .
##
## You can optionally add a full textlive installation to it, by
## setting the `WITH_TEXLIVE` build_arg to "yes":
##
## > docker build -t latexml-mws --build-arg WITH_TEXLIVE=yes .
##
## Building the image this way will take some time, and also make the image
## several gigabytes big. 
##
## The Docker Image exposes the web service on port 8080. To run it, use:
##
## docker run -p 8080:8080 --rm latexml-plugin-ltxmojo

FROM alpine:3.7

# Start by installing the system dependencies
RUN apk add --no-cache \
    db-dev \
    g++ \
    gcc \
    gcc \
    git \
    libc-dev \
    libgcrypt \
    libgcrypt-dev \
    libxml2 \
    libxml2-dev \
    libxslt \
    libxslt-dev \
    make \
    patch \
    perl \
    perl-dev \
    perl-utils \
    wget \
    zlib \
    zlib-dev

# Optionally enable support for TeXLive
# Use "yes" to enable, "no" to disable
ARG WITH_TEXLIVE="no"

# Install TeXLive if not disabled
RUN [ "$WITH_TEXLIVE" == "no" ] || (\
           apk add --no-cache -U --repository http://dl-3.alpinelinux.org/alpine/edge/main      poppler harfbuzz-icu \
        && apk add --no-cache -U --repository http://dl-3.alpinelinux.org/alpine/edge/community zziplib texlive-full \
        && ln -s /usr/bin/mktexlsr /usr/bin/mktexlsr.pl \
    )

# install cpanminus
RUN apk add --no-cache -U --repository http://dl-3.alpinelinux.org/alpine/edge/community perl-app-cpanminus

# versions of LaTeXML and Mojolicious to install
# accepts anything cpanm-like, by default we simply
# the latest ones
ARG LATEXML_VERSION="LaTeXML"
ARG LATEXML_MWS_VERSION="https://github.com/MathWebSearch/LaTeXML-Plugin-MathWebSearch.git"
ARG MOJOLICIOUS_VERSION="Mojolicious"

# Add all of the files
RUN mkdir -p /opt/ltxmojo

# Install the plugin via cpanminus
WORKDIR /opt/ltxmojo
RUN git clone https://github.com/dginev/LaTeXML-Plugin-ltxmojo . && cpanm --notest $LATEXML_VERSION $LATEXML_MWS_VERSION $MOJOLICIOUS_VERSION .

# All glory to the hypnotoad on port 8080
EXPOSE 8080
ENTRYPOINT [ "hypnotoad", "-f", "script/ltxmojo" ]