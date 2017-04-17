FROM jenkins:latest

MAINTAINER Guillaume Ferrand <guillaume.ferrand@gmail.com>


ARG user=jenkins

USER root

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common && \

    update-ca-certificates && \

    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \

    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \

    apt-get update && \
    apt-get install -y docker-ce && \
    usermod -aG docker ${user} && \

    curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose


# back to $user
USER ${user}


# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
