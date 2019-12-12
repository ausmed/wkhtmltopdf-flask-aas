FROM ubuntu:18.04

MAINTAINER Evan Wang <ywang@ausmed.com.au>

WORKDIR /tmp

RUN apt-get update && apt-get install -y gnupg

# Set Environment Variable
ENV LC_ALL=C.UTF-8

# Install dependencies and tools
RUN set -x; \
  apt-get install -yq --no-install-recommends \
    curl \
    python3-pip \
    # Libraries needed to install the pip modules (libpq-dev for pg_config > psycopg2)
    python3.7 \
    python3.7-dev \
    python3.7-distutils \
    # to install portable C which is a distant dependency for pysftp 
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    python3-setuptools \
    build-essential 

# Install wkhtmltox 0.12.5
RUN apt-get install -y software-properties-common \
    && apt-add-repository -y "deb http://archive.ubuntu.com/ubuntu bionic-security main" \
    && apt-get update
ADD https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb /opt/sources/wkhtmltox.deb
ADD http://archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_2.0.3-0ubuntu1_amd64.deb /opt/sources/libjpeg-turbo8.deb
RUN set -x; \
  apt-get install -y --no-install-recommends \
    libxrender1 \
    libfontconfig1 \
    libx11-dev \
    libjpeg62 \
    libxtst6 \
    fontconfig \
    xfonts-75dpi \
    xfonts-base \
  && dpkg -i /opt/sources/libjpeg-turbo8.deb \
  && rm -rf /opt/sources/libjpeg-turbo8.deb \
  && dpkg -i /opt/sources/wkhtmltox.deb \
  && rm -rf /opt/sources/wkhtmltox.deb \
  && ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf \
  && ln -s /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage

WORKDIR /

COPY app.py /app.py
COPY requeriments.txt /requeriments.txt

RUN pip3 install -r requeriments.txt

EXPOSE 80

CMD ["python3","app.py"]
