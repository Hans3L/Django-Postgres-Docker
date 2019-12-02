FROM centos:centos7
MAINTAINER by Hansel Ingaruca Rimac <hansel.hir@gmail.com>

RUN  yum install -y \
     python3-pip \
    && yum clean all \
    && mkdir /django

WORKDIR /django

ADD requirements.txt /django/

RUN pip3 install -r requirements.txt


COPY . /django/

# ssh

RUN  python3  /django/manage.py makemigrations \
     && python3 /django/manage.py migrate

EXPOSE 8080
CMD ["python3", "/django/manage.py" , "runserver" , "0.0.0.0:8080"]


