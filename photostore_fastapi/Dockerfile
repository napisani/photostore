# Pull base image
FROM python:3.7

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code/

# Install dependencies
RUN pip install pipenv
COPY Pipfile Pipfile.lock /code/
RUN pipenv install --system --dev

COPY . /code/
COPY .env.docker /code/
RUN rm -rf /code/.env
RUN mv  /code/.env.docker /code/.env
RUN ["chmod", "+x", "/code/start_docker_container.sh"]

EXPOSE 8000

ENTRYPOINT ["sh","/code/start_docker_container.sh"]