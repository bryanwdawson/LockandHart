import json, sys
with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)
for p in data['pins']:
    if p['id'] == 'nssol-kaiseki':
        out = []
        out.append('visited: ' + str(p.get('visited', '')))
        out.append('hero: ' + str(p.get('hero', '')))
        out.append('photos:')
        for ph in p.get('photos', []):
            out.append('  ' + ph)
        sys.stdout.buffer.write('\n'.join(out).encode('utf-8'))
