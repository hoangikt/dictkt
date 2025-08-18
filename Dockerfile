# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a50c75eaa9a9d0f681029d74f7498258308fe50594f92c7dc6ef3d883f79c570 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d409289a0684e02b95c10b586048c465f4032bc31b4055f59f38a73f914e7537

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
