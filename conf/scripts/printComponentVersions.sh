#!/usr/bin/env bash
# Use the unofficial bash strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail; export FS=$'\n\t'

labels="Image¢Version\n"
# for image in $(cat docker-compose.yml | grep image | grep -vE '^#' | sed 's/\W\+image: //g'); do
#     label=$(docker image inspect "$image" | grep \"org.label-schema.vcs-ref\" | cut -d'"' -f 4)
#     labels="$labels$image: $label\n"
# done

while IFS= read -r line
do
    image=$(echo "$line" | grep -vE '^#' | sed 's/\W\+image: //g')
    label=$(docker image inspect "$image" --format '{{ index .ContainerConfig.Labels "org.label-schema.vcs-ref" }}')
    label="${label:-no version}"
    labels="${labels}${image}¢${label}\n"
done < <(grep image < docker-compose.yml)


echo -e "$labels" | uniq | column -t -s "¢"
