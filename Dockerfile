# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:cac95f01d791abe0abdc183b59628b191a54f02a2d55b7251d12080108fdbe29 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:136aad7020e00a98f617f3d3343cc7601b7823405eb2bc581eae5f5a8c21e8d0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
