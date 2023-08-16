FROM python:3.9.17-slim-bullseye

RUN apt-get update &&\
    apt-get upgrade &&\
    apt-get install jq -y &&\
    pip install --upgrade pip &&\
    pip install checkov

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]