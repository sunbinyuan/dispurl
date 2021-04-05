FROM ruby:2.7.2
WORKDIR /usr/src/app
COPY Gemfile ./
RUN bundle install
COPY . .
ENV PORT=8080
EXPOSE 8080
# RUN bundle exec rake db:setup
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]