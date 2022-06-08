FROM ubuntu:20.04

ENV APT_INSTALL="DEBIAN_FRONTEND=noninteractive apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -q install --no-install-recommends -y" \
    APT_CLEANUP="rm -rf /var/lib/apt/lists /dvisvgm-2.4 /usr/share/doc ~/.cache"

RUN bash -c "${APT_INSTALL} \
 wget \
 libvoikko1 \
 libyaml-dev \
 voikko-fi \
 software-properties-common \
 && ${APT_CLEANUP}"

RUN bash -c "add-apt-repository -y ppa:deadsnakes/ppa && ${APT_CLEANUP}"
RUN bash -c "${APT_INSTALL} python3.10 python3.10-distutils && ${APT_CLEANUP}"

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 20
RUN wget -q https://bootstrap.pypa.io/get-pip.py && python3.10 get-pip.py && rm get-pip.py

ENV PIP_INSTALL="python3.10 -m pip install"
RUN bash -c "${PIP_INSTALL} --upgrade poetry==1.2.0b2 requests && ${APT_CLEANUP}"

WORKDIR /app
COPY . ./
RUN bash -c "poetry config virtualenvs.create false --local && \
poetry install && \
${APT_CLEANUP} && \
rm pyproject.toml poetry.lock poetry.toml"

CMD [ "gunicorn", "-c", "./oiko/gunicorn.config.py", "oiko.app:app" ]