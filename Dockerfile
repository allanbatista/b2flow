FROM ruby:2.6.5

LABEL author="Allan Batista <allan@allanbatista.com.br>"

# default sh as bash
SHELL ["/bin/bash", "-c"]

# expose
EXPOSE 3000

# no interaction
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes

# language
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# define default app location
ENV HOME_APP=/opt/app
RUN mkdir -p ${HOME_APP}
COPY . ${HOME_APP}
WORKDIR ${HOME_APP}

# install dependencies
RUN apt-get update && apt-get install locales -y

# install dependencies and build
RUN bundle install

# start up project
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "/opt/app/entrypoint.sh" ]
CMD ["/opt/app/entrypoint.sh", "webapp"]