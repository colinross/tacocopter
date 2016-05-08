FROM rails:latest

# Use libxml2, libxslt a packages from alpine for building nokogiri
#RUN bundle config build.nokogiri --use-system-libraries && gem install nokogiri -- --use-system-libraries

ENV APP_HOME /usr/src/app/
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
