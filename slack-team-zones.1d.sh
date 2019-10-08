#!/usr/bin/env bash
#
# Displays the status Niteans
# https://api.slack.com/custom-integrations/legacy-tokens
TOKEN="GET TOKEN FROM ABOVE"
echo "| image=iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QA/wD/AP+gvaeTAAABk0lEQVQ4y53Uv2sUQRjG8c+ee/66oI2FiARtLSwUQYhahFil0kKsLQKCpZWFdoog2EiEKwSxsfMfkBRywYBocYWdKFHENuFWTy+5tdjZuLm7NZt9YVj2mXe/+7wz804kRK8NDmAJ51WLFczi19RCJsQTktaxho0dYHHIHROL0ccCDiLdARjhZ/jmnxhK3YObuIBBBVgR2kQHT7GZO5zCNVysCBqNY3iBtRyYhFJnsXeXDv/INjLJ1/AqboTJzZoO54OJZ3FwNV8TNBpfYjzEmyAMa4Ia4fk2xtcwZnC6BrSBLpbzNYTDeIxzNR2+w2WFXe7hOT6pfw57uZAR21tJc7IDXqVTOngNZb28H/cCsEp0wthqv1HgRprqNiInGpHB/0jDVHOY6kbR9kskKr702rSaWveXT51ZXW8djaLJZaepaPpQ8uPOzMcPyUCSlzsGhOmzV+ARblHqsoknuL36/tW2ibH7sJH9oo99YZRFf5IYlyQv4ggu4WQB/BufZZ21uBvgd9n9eBzX8SDod/ES35Qcq7957GYIlVf3+AAAAABJRU5ErkJggg=="
echo "---"

while IFS= read -r p; do
  name=$(echo "$p" | jq -cMr '.[1]')
  mail=$(echo "$p" | jq -cMr '.[3]')

  tz=$(echo "$p" | jq -cMr '.[2]')

  if [[ "$mail" =~ niteo.co ]]; then
    time=$(env TZ="$tz" date +'%H:%M:%S %z')
    img=$(echo "$p" | jq -cMr '.[4]' | xargs curl -s | base64 -w0)
    echo "<b>$time</b> $name | href=\"mailto:$mail\" image=\"$img\" imageWidth=25"
  fi
done < <(curl -s "https://slack.com/api/users.list?token=$TOKEN" | jq '.members[] | select(.deleted == false) | select(.is_bot == false) | [.name, .real_name, .tz, .profile.email, .profile.image_48]' -cM)
