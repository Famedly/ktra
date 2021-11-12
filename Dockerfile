FROM docker.io/rust as builder

ARG DB="db-sled"
ARG MIRRORING="crates-io-mirroring"
COPY . /app
WORKDIR /app
RUN cargo build --release --no-default-features --features=secure-auth,${DB},${MIRRORING}

FROM docker.io/debian:buster-slim

LABEL org.opencontainers.image.source https://github.com/Famedly/ktra
LABEL org.opencontainers.image.documentation https://book.ktra.dev
LABEL org.opencontainers.image.licenses "(Apache-2.0 OR MIT)"

RUN apt update; apt install -y libssl1.1 ca-certificates
COPY --from=builder /app/target/release/ktra /usr/local/bin/ktra

ENTRYPOINT [ "/usr/local/bin/ktra" ]
CMD []
