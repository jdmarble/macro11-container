FROM docker.io/library/debian:12.6-slim as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install -y --no-install-recommends \
 build-essential=12.9 \
 ca-certificates=20230311 \
 git=1:2.39.2-1.1 \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /macro11 \
 && git clone --depth 1 --branch macro11-v0.9 https://gitlab.com/Rhialto/macro11.git /macro11 \
 && make -C /macro11

FROM docker.io/library/debian:12.6-slim
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install -y --no-install-recommends \
 perl=5.36.0-7+deb12u1\
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /macro11/macro11 /bin/macro11
COPY --from=builder --chmod=0755 /macro11/obj2bin/obj2bin.pl /bin/obj2bin.pl
COPY --from=builder /macro11/dumpobj /bin/dumpobj
CMD ["/bin/macro11"]
