FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential

ADD . /lizard
WORKDIR /lizard/programs
RUN make -j8

RUN mkdir -p /deps
RUN ldd /lizard/programs/lizard | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /lizard/programs/lizard /lizard/programs/lizard
ENV LD_LIBRARY_PATH=/deps
