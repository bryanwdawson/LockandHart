import json, sys
with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)
targets = ['jni-office', 'yakitori-tokyo', 'zojoji-tokyo-tower', 'suimei-shabu', 'nssol-kaiseki']
out = []
for p in data['pins']:
    if p['id'] in targets:
        out.append('=== ' + p['id'] + ' ===')
        out.append('title: ' + str(p.get('title','')))
        facts = p.get('facts', [])
        if isinstance(facts, list):
            out.append('facts: ' + str(facts))
        else:
            out.append('facts (dict): ' + str(list(facts.keys())))
        cards = p.get('extra_cards', [])
        out.append('extra_cards (' + str(len(cards)) + '):')
        for c in cards:
            body_preview = (c.get('body','') or '')[:80]
            out.append('  - ' + str(c.get('title','')) + ' | ' + body_preview)
        out.append('')
sys.stdout.buffer.write('\n'.join(out).encode('utf-8'))
