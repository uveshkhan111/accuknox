FROM debian:stable-slim

# Install bash, cowsay, fortune-mod, fortunes, and netcat
RUN apt-get update && \
    apt-get install -y bash cowsay fortune-mod fortunes netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499

CMD ["/bin/bash", "/app/wisecow.sh"]
