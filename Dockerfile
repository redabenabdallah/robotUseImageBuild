###
# To manually start your image:
# Make sure you create the folders suites, scrips and reports
# docker run --rm -ti --network=host -v "$PWD/output:/output" -v "$PWD/suites:/suites" -v "$PWD/scripts:/scripts" -v "$PWD/reports:/reports"  robot  bash
#
# Or using docer-compose (see listing below):
# docker-compose up
# docker-compose down
###

FROM python:3.12

LABEL name="Docker build demo Robot Framework"

MAINTAINER "JDriven" <info@jdriven.com>

RUN apt-get update \
    && apt-get install -y xvfb wget ca-certificates fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 \
       libatspi2.0-0 libcups2 libdbus-1-3 libgbm1 libgtk-3-0 libnspr4 libnss3 \
       libxcomposite1 libxkbcommon0 libxrandr2 xdg-utils ntpdate openssl

RUN python3 -m pip install robotframework && pip install robotframework-requests &&  pip install robotframework-selenium2library \
    && pip install xvfbwrapper && pip install robotframework-xvfb && pip install certifi && pip install asn1crypto \
    && pip install bcrypt && pip install robotframework-sshlibrary && pip install cryptography && pip install pyOpenSSL \
    && pip install idna && pip install requests[security]

# install chrome and chromedriver in one run command to clear build caches for new versions (both version need to match)
RUN apt-get install -y wget

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb
RUN mv google-chrome*.deb /usr/bin/google-chrome

RUN wget -q https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/121.0.6167.85/linux64/chromedriver-linux64.zip
RUN unzip chromedriver-linux64.zip
RUN mv /chromedriver-linux64/chromedriver /usr/local/bin
RUN chmod +x /usr/local/bin/chromedriver

ARG USERNAME=toto
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN su - toto

RUN mkdir /work
WORKDIR /work
COPY    ./testCases/test.robot /work
CMD ["robot", "test.robot"]