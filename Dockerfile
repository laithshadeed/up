FROM ruby:2.5.1

ADD bin /root/bin
ADD lib /root/lib

ENTRYPOINT ["/root/bin/up"]
