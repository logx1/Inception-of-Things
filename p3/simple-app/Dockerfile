FROM python:3.12

COPY django-on-ec2 /app/django-on-ec2

WORKDIR /app/django-on-ec2

RUN pip install -r requirements.txt

RUN python manage.py makemigrations && \
    python manage.py migrate

EXPOSE 80


# # CMD ["nohup", "python", "manage.py", "runserver", "0.0.0.0:8000", "&"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]



