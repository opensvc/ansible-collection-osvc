FROM python:3.9.17-alpine3.18

LABEL maintainer="OpenSVC Ansible Team <ansible@opensvc.com>"
LABEL vendor1="OpenSVC"

ARG REQUIREMENTS_FILE=requirements.txt

COPY $REQUIREMENTS_FILE /tmp
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
                                shellcheck \
                                sshpass \
                                libressl-dev &&\
                                pip install --upgrade pip && \
                                pip install -r /tmp/$REQUIREMENTS_FILE &&\
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
