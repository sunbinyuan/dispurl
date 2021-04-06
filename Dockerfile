FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y nodejs
WORKDIR /usr/src/app
COPY Gemfile ./
RUN bundle install
COPY . .
ENV PORT=8080
#RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8080
RUN bundle exec rake db:migrate

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "8080"]