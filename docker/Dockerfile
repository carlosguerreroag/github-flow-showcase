FROM python:3.10-slim

RUN useradd -r -s /sbin/nologin -M appuser

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

COPY app/app.py .
COPY app/templates/ ./templates/

RUN chown -R appuser:appuser /app

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD curl -f http://localhost:5000 || exit 1

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
