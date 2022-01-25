FROM python:3.9.2-alpine3.12

LABEL maintainer="OpenSVC Ansible Team <ansible@opensvc.com>"
LABEL vendor1="OpenSVC"

COPY requirements.txt /tmp
RUN apk add --update --no-cache ca-certificates \
                                openssh-client \
                                build-base \
                                cargo \
                                gcc \
                                g++ \
                                git \
                                make \
                                python3-dev \
                                py-pip \
                                libffi-dev \
                                rust \
                                sshpass \
                                libressl-dev &&\
                                pip install --upgrade pip && \
                                pip install -r /tmp/requirements.txt &&\
                                apk del -r --purge gcc make g++ rust &&\
                                rm -rf /source/* &&\
                                rm -rf /var/cache/apk/* &&\
                                rm -rf /tmp/*

WORKDIR /opt
ADD ansible_collections/opensvc/ /opt/opensvc/

RUN ansible-galaxy collection build --force opensvc/cluster opensvc/app && \
    for i in *.tar.gz; do ansible-galaxy collection install $i -p /usr/share/ansible/collections; done

WORKDIR /examples

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["check"]
