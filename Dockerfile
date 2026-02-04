# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:485b1a9342ad7bcddc4b4bd1f675e42464add629866d3066388664b587f30812 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:968ae4081adaaef9dfc82fc8d418b094b6cbc7189798752d21871831319d61c8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
