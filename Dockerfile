FROM ruby:3.2.2

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/gems

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    sqlite3

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .


EXPOSE 3000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]
