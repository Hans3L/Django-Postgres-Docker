FROM centos:centos7
MAINTAINER by Hansel Ingaruca Rimac <hansel.hir@gmail.com>

RUN  yum install -y \
     python3-pip \
#    python3-dev \
    && yum clean all \
    && mkdir /django

WORKDIR /django

ADD requirements.txt /django/

RUN pip3 install -r requirements.txt

# ADD . /django/
COPY . /django/
# COPY /apps /django
# COPY /Project_encuesta /django

#ADD manage.py /django/
# ssh




EXPOSE 8080
CMD ["python3", "/django/manage.py" , "runserver" , "0.0.0.0:8080"]

