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
COPY example/web_interface web_interface
RUN pip3 install -r web_interface/requirements.txt

# Define an environment variable for the port with a default value
ENV PORT=5000
ENV MATTE=none
ENV SLIDESHOW_UPDATE_INTERVAL_MINS=360
ENV CHECK_FOR_NEW_ART_INTERVAL_MINS=600
ENV PREVIEW_DURATION_SECS=30
ENV DEBUG=false

EXPOSE ${PORT}/tcp

CMD web_interface/web_interface.py "$TV_IP" \
    --port "$PORT" \
    --folder /app/images \
    --matte "$MATTE" \
    --token_file /app/conf/token.txt \
    --update "$SLIDESHOW_UPDATE_INTERVAL_MINS" \
    --check "$CHECK_FOR_NEW_ART_INTERVAL_MINS" \
    --display_for "$PREVIEW_DURATION_SECS" \
    --debug
