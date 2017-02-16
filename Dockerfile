FROM ubuntu:16.04

MAINTAINER Evan Wang <ywang@ausmed.com.au>

RUN apt-get clean && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    gdebi \
    wget \
    python-pip

WORKDIR /tmp

RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xfv wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    cp -R wkhtmltox/* / && \
    rm -rf wkhtmltox && \
    rm wkhtmltox-0.12.4_linux-generic-amd64.tar.xz

WORKDIR /

COPY app.py /app.py
COPY requeriments.txt /requeriments.txt

RUN pip install -r requeriments.txt

EXPOSE 80

CMD ["python","app.py"]
