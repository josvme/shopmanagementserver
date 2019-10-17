# Setup first temporary container for building elixir.
FROM elixir:1.9.2-alpine as build-elixir

# Install build dependencies
RUN apk add --update git

# Set our work directory in docker container
RUN mkdir /app
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV. This might not be necessary
ENV MIX_ENV=prod

# Install all mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Compile all mix dependencies
COPY config ./config/
RUN mix deps.compile

# Now we selectively copy all required files from local system to docker container
COPY lib ./lib/
COPY priv ./priv/
COPY rel ./rel/

# Run digest. This is not required for us, as we don't serve as static files from phoenix.
RUN mix phx.digest

# Build our release
RUN mix release

# Now this container will have our Elixir release compiled. We just need to copy it to our production container. 
# We use multiple containers because, we don't want to have all development tools and files in our production server. 


# Production Elixir server
FROM alpine:3.10

# Install openssl and bash
RUN apk add --update bash openssl

RUN mkdir /app 
WORKDIR /app

# We run as root, we can change it in the future
USER root

# Copy all build artifacts from previous container. Notice the --from
COPY --from=build-elixir /app/_build/prod/rel/ms ./

# Copy required scripts to run when the container starts
COPY entrypoint.sh .

# Setting environment variables
ARG VERSION
ENV VERSION=$VERSION
ENV REPLACE_OS_VARS=true

# Make our build runnable
RUN chmod 755 /app/bin/ms

# Expose our app to port 4000
EXPOSE 4000

# These two environment variables are checked in phoenix server, to find the secret key and database url.
ENV DATABASE_URL=ecto://postgres:postgres@postgres/ms_prod
ENV SECRET_KEY_BASE=6jSLHKOk3s645E27EZVULIAuopigrSaiTgi+aKz7dtqKw0qRwjKWwQIkXqyyzkZc

# Set script to run when the server starts
CMD ["./entrypoint.sh"]