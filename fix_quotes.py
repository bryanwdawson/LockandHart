with open('public/private/japan/pins.json', 'rb') as f:
    raw = f.read()

# The mojibake em-dash (â€") originally encoded as 9 bytes:
# c3 a2 e2 82 ac e2 80 9d
# After previous fix replaced e2 80 9d -> 22, it became:
# c3 a2 e2 82 ac 22
# Replace that pattern back to a real em-dash: e2 80 94
em_dash_broken = b'\xc3\xa2\xe2\x82\xac\x22'
em_dash_real   = b'\xe2\x80\x94'

count_em = raw.count(em_dash_broken)
print(f'Em-dash patterns to fix: {count_em}')
fixed = raw.replace(em_dash_broken, em_dash_real)

# Also replace any remaining curly left/right quotes used as JSON delimiters
count_left  = fixed.count(b'\xe2\x80\x9c')
count_right = fixed.count(b'\xe2\x80\x9d')
print(f'Remaining curly left quotes: {count_left}, curly right quotes: {count_right}')
fixed = fixed.replace(b'\xe2\x80\x9c', b'\x22').replace(b'\xe2\x80\x9d', b'\x22')

with open('public/private/japan/pins.json', 'wb') as f:
    f.write(fixed)

import json
with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)
print(f'JSON valid — {len(data["pins"])} pins loaded')
