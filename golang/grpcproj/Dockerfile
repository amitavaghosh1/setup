FROM ruby:2.6-slim

WORKDIR /srv/slate

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        nodejs npm

RUN git config --global http.sslverify false \
    && git clone https://github.com/slatedocs/slate.git slatebuild \
    && cp -r slatebuild/* /srv/slate/ \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf slatebuild


COPY docs/index.html.md /srv/slate/source/

RUN chmod +x /srv/slate/slate.sh

ENTRYPOINT ["/srv/slate/slate.sh"]
CMD ["build"]
