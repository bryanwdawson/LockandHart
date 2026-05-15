import json

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)

pins = data['pins']

# Find hibiya-dog-park (duplicate to remove)
hibiya = next((p for p in pins if p['id'] == 'hibiya-dog-park'), None)
print(f'hibiya-dog-park found: {hibiya is not None}')

# Find chirori-dog-park (keep this one)
chirori = next((p for p in pins if p['id'] == 'chirori-dog-park'), None)
print(f'chirori-dog-park found: {chirori is not None}')
if chirori:
    print(f'  visited: {chirori.get("visited")}')
    print(f'  photos: {chirori.get("photos", [])}')

# Remove hibiya-dog-park
data['pins'] = [p for p in pins if p['id'] != 'hibiya-dog-park']
print(f'Pins after removal: {len(data["pins"])}')

# Add photo to chirori-dog-park and update visited
chirori = next(p for p in data['pins'] if p['id'] == 'chirori-dog-park')
if '20260419_162124.jpg' not in chirori.get('photos', []):
    chirori.setdefault('photos', []).insert(0, '20260419_162124.jpg')
    print(f'Added 162124 to chirori-dog-park photos')
# Update visited to include 2026-04-19
visited = chirori.get('visited', '')
if '2026-04-19' not in visited:
    chirori['visited'] = '2026-04-19, ' + visited if visited else '2026-04-19'
    print(f'Updated visited: {chirori["visited"]}')

# Save
with open('public/private/japan/pins.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# Verify
with open('public/private/japan/pins.json', encoding='utf-8') as f:
    check = json.load(f)
print(f'Final pin count: {len(check["pins"])}')
ids = [p['id'] for p in check['pins']]
print(f'hibiya-dog-park in list: {"hibiya-dog-park" in ids}')
print(f'chirori-dog-park photos: {next(p for p in check["pins"] if p["id"] == "chirori-dog-park").get("photos")}')
