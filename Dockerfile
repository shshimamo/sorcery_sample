FROM ruby:2.6.1-stretch
WORKDIR /app

ARG BUNDLE_INSTALL_ARGS="-j 4"
COPY Gemfile Gemfile.lock ./

RUN bundle config --local disable_platform_warnings true \
    && bundle install ${BUNDLE_INSTALL_ARGS}

COPY --from=node:10.15.3-stretch /usr/local/ /usr/local/
COPY --from=node:10.15.3-stretch /opt/ /opt/

COPY package.json yarn.lock ./
RUN yarn install

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY . ./

CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
