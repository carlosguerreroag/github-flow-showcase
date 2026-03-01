FROM python:3.10-slim

WORKDIR /app

COPY ../app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

COPY ../app/app.py .
COPY ../app/templates/ ./templates/

EXPOSE 5000

CMD ["python", "app.py"]
