# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:32d981225ff8dfa1f5d5cf4525f1a223879ef0e7c6afa521a1be09a65e3bf134 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:67f2a11126fc38c9c9a9aed1f7fa9ed24e4ac45b3e019be1c2f10f9f419e8550

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
