FROM linuxserver/code-server:v3.4.0-ls46

ENV SDKMAN_DIR="/usr/local/.sdkman"

SHELL ["/bin/bash", "-c", "-l"]

RUN apt-get update && apt-get install -y --no-install-recommends \
  # Utils 
  build-essential \
  curl \
  wget \
  zip \
  unzip \
  # VCS 
  git \
  # Editors \
  emacs-nox \
  vim \
  # Database clients
  mysql-client postgresql-client \
  # Programming languages
  python3 \
  # Dependencies for Intellij Idea
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 

# Tool to easily install java dev tools.  
RUN curl -s "https://get.sdkman.io" | bash && \
    rm -rf /var/lib/apt/lists/* && \
    echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config
RUN source $SDKMAN_DIR/bin/sdkman-init.sh && \
	sdk install java 14.0.1.hs-adpt && \
	sdk install maven 3.6.3

# The Intellij idea ultimate editor
ARG IDEA_VERSION=2020.1.2
ARG idea_source=https://download-cf.jetbrains.com/idea/ideaIU-${IDEA_VERSION}.tar.gz

RUN mkdir -p /opt/idea && cd /opt/idea && curl -fsSL $idea_source -o /opt/idea/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz && cd

ENV PATH /opt/idea/bin:$PATH

#Adds local files
COPY /root /