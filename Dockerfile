# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:619a84b84f8bb1f3c724d7c98c0b195059554e04ae92cb6f579efed6718d13ee as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:14afb7f0d9d217f3ef592bdcd02b301a191913c8d3c2cf39f63cfe2030cdd2b7

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
