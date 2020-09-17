# See https://www.digitalocean.com/community/tutorials/how-to-build-and-deploy-a-flask-application-using-docker-on-ubuntu-18-04
FROM tiangolo/uwsgi-nginx-flask:python3.7

ARG AIIDA_VERSION=1.2.1
ARG AIIDA_TAG=""

# Install AiiDA
#RUN pip install aiida-core[rest,atomic_tools]==$AIIDA_VERSION
RUN if [ -z "$AIIDA_TAG" ]; then pip install aiida-core[rest,atomic_tools]==$AIIDA_VERSION; \
    else pip install https://github.com/aiidateam/aiida-core/archive/$AIIDA_TAG.tar.gz#egg=aiida-core[rest,atomic_tools]; fi
RUN reentry scan -r aiida

# Scripts for REST API
COPY main.py /app
COPY uwsgi.ini /app

# Container vars
ENV AIIDA_PATH /app

# AiiDA profile vars
ENV AIIDA_PROFILE generic
ENV AIIDADB_HOST host.docker.internal
ENV AIIDADB_PORT 5432
ENV AIIDADB_ENGINE postgresql_psycopg2
ENV AIIDADB_NAME generic_db
ENV AIIDADB_USER db_user
ENV AIIDADB_PASS ""
ENV AIIDADB_BACKEND django
ENV default_user_email info@materialscloud.org

# start AiiDA REST API
EXPOSE 5000
