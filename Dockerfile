FROM debian:bullseye-slim

WORKDIR /

ENV COWRIE_GROUP=cowrie \
    COWRIE_USER=cowrie \
    COWRIE_HOME=/home/cowrie \
    TZ="Europe/Madrid"

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get -q update && \
    apt-get -q install -y \
	 git \	 
	 libssl-dev \
	 libffi-dev \
   procps \
	 build-essential \
	 libpython3-dev \
	 python3-minimal \
	 authbind \	 
   python3-pip  

RUN rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "" ${COWRIE_USER}

USER ${COWRIE_USER}
WORKDIR ${COWRIE_HOME}

RUN git clone https://github.com/cowrie/cowrie
WORKDIR ${COWRIE_HOME}/cowrie

RUN python3 -m pip install --upgrade pip && python3 -m pip install --upgrade -r requirements.txt
RUN export PATH=$PATH:/home/cowrie/.local/bin
COPY --chmod=755 start.sh ${COWRIE_HOME}/cowrie
ENV PATH=$PATH:/home/cowrie/.local/bin
VOLUME [ "/home/cowrie/cowrie/var", "/home/cowrie/cowrie/etc" ]


#CMD [ "/home/cowrie/cowrie/start.sh"]
ENTRYPOINT [ "/home/cowrie/cowrie/start.sh"]

EXPOSE 2222 2223