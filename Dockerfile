FROM alpine:3.20

RUN apk add --no-cache bash && adduser -D appuser

WORKDIR /app

COPY app/ /app/

RUN chmod +x /app/*.sh

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD ["/app/health-check.sh"]

ENTRYPOINT ["/app/diagnostic.sh"]
CMD ["help"]
