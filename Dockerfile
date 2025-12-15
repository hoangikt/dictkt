# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4f38919abd322d122a8219a7b6147e419806c29ad3b269596288bf61a0a40867 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5e61aa6065e00ae3449521ae86e3ed096a729e1fb9d2f40e9e4c8d342379c5f0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
