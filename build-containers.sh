# git pull
# docker login
DOCKERHUB_VERSION=0.1
UPLOAD="NO"
# UPLOAD="YES"

# run from the docker directory
build () {
  {
    if [[ "$1" == "NO" ]]; then
      docker build --build-arg DOCKERHUB_VERSION_UPDATE=${DOCKERHUB_VERSION} --no-cache -t $USER/${LABEL}:latest .
    else
      docker build --build-arg DOCKERHUB_VERSION_UPDATE=${DOCKERHUB_VERSION} -t $USER/${LABEL}:latest .
    fi
  } || {
    echo "-----------------------------------------------------------------------"
    echo "Docker build for ${LABEL} was not successful"
    echo "-----------------------------------------------------------------------"
    sleep 3s
    exit 1
  }
  if [ "${UPLOAD}" == "YES" ]; then
    docker tag $USER/${LABEL}:latest $USER/${LABEL}:${DOCKERHUB_VERSION}
    docker push $USER/${LABEL}:${DOCKERHUB_VERSION}; docker push $USER/${LABEL}:latest
  fi
}

# create or update the renv.lock file
R -e 'renv::snapshot(".", lockfile = "./renv.lock", confirm = FALSE)'

LABEL="test-project"
build
