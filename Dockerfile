FROM python:3-alpine3.6 

LABEL maintainer="OpenSVC Ansible Team <ansible@opensvc.com>"
LABEL vendor1="OpenSVC"

COPY requirements.txt /tmp
RUN apk add --update --no-cache ca-certificates \
                                openssh-client \
                                build-base \
                                gcc \
                                g++ \
                                make \
                                python-dev \
                                py-pip \
                                libffi-dev \
                                sshpass \
                                libressl-dev &&\
                                pip install --upgrade pip && \
                                pip install -r /tmp/requirements.txt &&\
                                apk del -r --purge gcc make g++ &&\
                                rm -rf /source/* &&\
                                rm -rf /var/cache/apk/* &&\
                                rm -rf /tmp/*

WORKDIR /opt
ADD ansible_collections/opensvc/ /opt/opensvc/

RUN ansible-galaxy collection build --force opensvc/cluster && \
    for i in *.tar.gz; do ansible-galaxy collection install $i -p /usr/share/ansible/collections; done

WORKDIR /examples

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["check"]
