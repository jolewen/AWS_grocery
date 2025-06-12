FROM python:3.11-slim
LABEL authors="johannes"

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "run.py"]