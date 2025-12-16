# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Install Python dependencies (without installing the project itself)
RUN poetry config virtualenvs.create false && \
    poetry install --only main --no-interaction --no-ansi --no-root

# Copy application files
COPY . .

# Copy Docker-specific settings file
RUN cp settings.py.docker settings.py

# Install the project in editable mode (if needed)
RUN poetry install --only-root --no-interaction --no-ansi || true

# Create necessary directories
RUN mkdir -p upload scripts

# Copy and set permissions for entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set environment variables defaults
ENV TELEGRAM_API_TOKEN=""
ENV ENABLED_USERS=""
ENV MAX_TASK_OUTPUT=99999
ENV PORT=8443

# Run the bot
CMD ["python", "bot.py"]
