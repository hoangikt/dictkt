# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:574e6e4294783a75a1247084290139c1f957ba100ef3388b1b8804d0c1f80239 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ac4b95e8109791aaf0ba8af76f10c53c3977040420981c0c2ef86e5533a69e72

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
