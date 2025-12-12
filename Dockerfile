FROM docker.io/library/debian:12.7-slim as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /macro11 \
    && git clone --depth 1 --branch macro11-v0.9 https://gitlab.com/Rhialto/macro11.git /macro11 \
    && make -C /macro11

FROM docker.io/library/debian:12.7-slim
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y --no-install-recommends \
    perl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /macro11/macro11 /bin/macro11
COPY --from=builder --chmod=0755 /macro11/obj2bin/obj2bin.pl /bin/obj2bin.pl
COPY --from=builder /macro11/dumpobj /bin/dumpobj
CMD ["/bin/macro11"]
