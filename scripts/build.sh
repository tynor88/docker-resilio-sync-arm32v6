# build image
docker build -t tynor88/resilio-sync-arm32v6 .
# test image
docker run tynor88/resilio-sync-arm32v6 uname -a
