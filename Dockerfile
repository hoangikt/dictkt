# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d864099fc2fa5729ef12af94aa74dcb32a56b68469863cc0eba8f06533928673 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:60accf4950efb9bca9ddcbd6c85c5bb564a40a63168b3e206dd342e7deeb61a4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
