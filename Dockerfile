FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends git ffmpeg curl unzip nodejs npm && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://deno.land/install.sh | sh && \
    ln -s /root/.deno/bin/deno /usr/local/bin/deno

# Clone and build the bgutil PO Token generator script (required by
# bgutil-ytdlp-pot-provider -- the pip package only ships the yt-dlp
# plugin glue code, not the actual token-generating script).
RUN git clone --depth 1 https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git /opt/bgutil-ytdlp-pot-provider && \
    cd /opt/bgutil-ytdlp-pot-provider/server && \
    npm ci && \
    npx tsc

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["python3", "-m", "AnnieXMedia"]