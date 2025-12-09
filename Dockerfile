# syntax=docker/dockerfile:1

FROM python:3.12-slim

WORKDIR /build
COPY samsungtvws samsungtvws
COPY LICENSE LICENSE
COPY README.md README.md
COPY pyproject.toml pyproject.toml
COPY requirements.txt requirements.txt
COPY setup.py setup.py
RUN pip3 install . -r requirements.txt

WORKDIR /app
# COPY example/web_interface web_interface
# RUN pip3 install -r web_interface/requirements.txt
COPY example/async_art_update_from_directory.py async_art_update_from_directory.py

# Define an environment variable for the port with a default value
ENV MATTE=none
ENV SLIDESHOW_UPDATE_INTERVAL_MINS=360
ENV CHECK_FOR_NEW_ART_INTERVAL_MINS=5
ENV DEBUG=false

CMD /app/async_art_update_from_directory.py "$TV_IP" \
    --folder /app/images \
    --matte "$MATTE" \
    --data_dir /app/data \
    --token_file token.txt \
    --update "$SLIDESHOW_UPDATE_INTERVAL_MINS" \
    --check "$CHECK_FOR_NEW_ART_INTERVAL_MINS" \
#    --debug
