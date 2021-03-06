FROM golang:alpine AS builder

RUN apk update && apk add --no-cache make bash
RUN adduser -D -g '' appuser

WORKDIR /app
COPY . .

RUN make build

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /app/bin/cc /app/bin/cc
COPY --from=builder /app/bin/clicks.json /app/bin/clicks.json

USER appuser
EXPOSE 9000

ENTRYPOINT ["/app/bin/cc"]