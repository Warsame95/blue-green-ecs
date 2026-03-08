FROM python:3.13-slim AS build

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

COPY src/ ./src

FROM python:3.13-slim

WORKDIR /app

ENV TABLE_NAME=my_db

COPY --from=build /install /usr/local
COPY --from=build /app/src ./src

USER 1001:1001

EXPOSE 8080

CMD ["python3", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
