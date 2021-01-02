#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
from collections import namedtuple
from collections import OrderedDict
import base64  
from io import BytesIO
import pathlib

location = "Babno%20Polje"
size = 13

def create_namedtuple_from_dict(obj):
    if isinstance(obj, dict):
        fields = sorted(obj.keys())
        namedtuple_type = namedtuple(
            typename='GenericObject',
            field_names=fields,
            rename=True,
        )
        field_value_pairs = OrderedDict(
            (str(field), create_namedtuple_from_dict(obj[field]))
            for field in fields
        )
        try:
            return namedtuple_type(**field_value_pairs)
        except TypeError:
            # Cannot create namedtuple instance so fallback to dict (invalid attribute names)
            return dict(**field_value_pairs)
    elif isinstance(obj, (list, set, tuple, frozenset)):
        return [create_namedtuple_from_dict(item) for item in obj]
    else:
        return obj


def img(pic):
    path = pathlib.Path.home() / ".local" / f"{pic}.b64"
    if path.exists():
        return path.read_text()

    r = requests.get(f"http://www.vreme.si/app/common/images/png/weather/{pic}.png")
    buffered = BytesIO(r.content) 
    img_base64 = base64.b64encode(buffered.getvalue()).decode()
    with open(path, mode='w') as f:
        f.write(img_base64)
    return img_base64

def tt(ts):
    return ts.split("T")[1].split("+")[0]

req = requests.get(f"http://www.vreme.si/api/1.0/location/?lang=sl&location={location}")
data = create_namedtuple_from_dict(req.json())

props = data.observation.features[0].properties
today = props.days[0]
now = today.timeline[0]

print(f"{now.t}°C")
print("---")
print(f"{props.title} ({now.wwsyn_shortText} {now.clouds_shortText}) {now.msl}hPa - {now.pa_shortText} | href=http://www.vreme.si/napoved/{location} image={img(now.clouds_icon_wwsyn_icon)} font={size}")
print(f"🐓 {tt(today.sunrise)} 🌇 {tt(today.sunset)} | font={size}")
print(f"⛳️ {now.ff_shortText} {now.ff_val}km/h | font={size}")
print(f"💧 {now.rh_shortText} {now.rh}% | font={size}")
print("---")

for c, day in enumerate(data.forecast24h.features[0].properties.days):
    print(f"{day.date} {day.timeline[0].txsyn}°C ({day.timeline[0].clouds_shortText_wwsyn_shortText}) | href=http://www.vreme.si/napoved/{location}/graf/{c} image={img(day.timeline[0].clouds_icon_wwsyn_icon)} font={size}")
