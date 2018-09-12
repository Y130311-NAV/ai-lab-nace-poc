FROM python:3

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText  && \
  cd /tmp/fastText && \
  pip install . && \
  rm -rf /tmp/fastText && \
  cd /

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the gcloud package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz > /dev/null \
  && /usr/local/gcloud/google-cloud-sdk/install.sh > /dev/null

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

COPY ./app /app
COPY ./scripts/dockerEntryPoint.sh /

WORKDIR /app

RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash", "/dockerEntryPoint.sh"]