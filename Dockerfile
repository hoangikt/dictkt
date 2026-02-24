# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1e3d3b3e7613f024a212737de914d323ceb210ace0d41a8dbb596f8d80feae34 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:47fe69adf3f2a9a8875b1bbfa1a1eeccf1a79dec952cdf5334b8517141a025a9

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
