FROM ubuntu:16.04

MAINTAINER Evan Wang <ywang@ausmed.com.au>

WORKDIR /tmp

RUN apt-get clean && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    gdebi \
    wget \
    python-pip && \
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar xfv wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    cp -R wkhtmltox/* /usr/local/ && \
    rm -rf wkhtmltox && \
    rm wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf && \
    ln -s /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage

WORKDIR /

COPY app.py /app.py
COPY requeriments.txt /requeriments.txt

RUN pip install -r requeriments.txt

EXPOSE 80

CMD ["python","app.py"]
