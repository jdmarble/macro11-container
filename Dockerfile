FROM registry.access.redhat.com/ubi10-minimal:10.1 as builder

RUN microdnf install --assumeyes \
    gcc-14.3.1 \
    make-4.4.1 \
    git-2.47.3 \
    && microdnf clean all

RUN mkdir /macro11 \
    && git clone --depth 1 --branch macro11-v0.9 https://gitlab.com/Rhialto/macro11.git /macro11 \
    && make -C /macro11

FROM registry.access.redhat.com/ubi10-minimal:10.1
RUN microdnf install --assumeyes \
    perl-5.40.2 \
    && microdnf clean all

COPY --from=builder /macro11/macro11 /bin/macro11
COPY --from=builder --chmod=0755 /macro11/obj2bin/obj2bin.pl /bin/obj2bin.pl
COPY --from=builder /macro11/dumpobj /bin/dumpobj
CMD ["/bin/macro11"]
