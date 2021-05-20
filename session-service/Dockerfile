FROM ruby:2.6

ENV APP_PATH=/usr/src
WORKDIR $APP_PATH

COPY Gemfile* $APP_PATH/
RUN bundle install

EXPOSE 8680

ADD . .

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8680"]
