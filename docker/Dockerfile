FROM allanbatista/b2flow-base

LABEL author="Allan Batista <allan@allanbatista.com.br>"

# expose
EXPOSE 3000

# define default app location
ENV HOME_APP=/opt/app
RUN mkdir -p ${HOME_APP}
COPY . ${HOME_APP}
WORKDIR ${HOME_APP}

VOLUME ${HOME_APP}/storage

# install dependencies and build
RUN bundle install

# start up project
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "/opt/app/entrypoint.sh" ]
CMD ["webapp"]