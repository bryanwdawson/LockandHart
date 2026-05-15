import json

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)

pins = {p['id']: p for p in data['pins']}

# --- yakitori-tokyo: 3 new cards ---
pins['yakitori-tokyo']['extra_cards'] = [
    {
        "title": "Clair's list",
        "body": "Clair had been planning her restaurants for weeks before the trip. Google Map pins, notes, ratings — she was the walking Yelp. Every evening was her pick. Some had long waits. Bryan hated just standing in line, but they talked and joked, and her places were always worth it.\n\nThis one was a specialty yakitori place she'd had circled. Organ cuts, cartilage, things that aren't on tourist menus. She knew exactly what to order."
    },
    {
        "title": "What you actually eat at a real yakitori restaurant",
        "body": "Yakitori means 'grilled chicken' — but at a place like this, that's barely the point. The menu goes deep.\n\nKnee cartilage: chewy, almost crunchy, charred at the edges. Tsunagi: the connecting tissue between the heart and the liver — earthy, rich, nothing like a standard skewer. Momotare: thigh with house tare sauce. Quail eggs, grilled whole on skewers.\n\nThe Japanese philosophy about offcuts is the opposite of most cuisines: the unusual parts are prized, not discarded. Bryan passed on the chicken hearts — stomach's limit — but everything else went down."
    },
    {
        "title": "After the government rooms",
        "body": "The afternoon had been the Cabinet Office meeting. Japan's government district. David led, Bryan and Clair supported. Big rooms, formal interpretation, topics that mattered.\n\nBy 8 PM they were at a yakitori counter, passing skewers. Nobody needed to talk about the meeting. The food did the transition."
    }
]

# --- suimei-shabu: add signed menu card ---
pins['suimei-shabu']['extra_cards'].append({
    "title": "The signed menu",
    "body": "Darren's last night. He was flying out the next morning. Six people, six countries, one menu passed around the table.\n\nDavid wrote 'best dinner ever!' Clair drew a bald-head doodle of Bryan and added 'this is the best thing EVER' in her best annoying-little-sister energy. Darren drew something that gets blurred for the kids' version. Alessandro wrote something in Italian — translation still pending. Vette drew a wagyu burger.\n\nBryan signed his name.\n\nThe menu came home. It's in the scrapbook."
})

# --- zojoji-tokyo-tower: add Buddha's Footprints card ---
pins['zojoji-tokyo-tower']['extra_cards'].append({
    "title": "The Footprints",
    "body": "Set into the stone at Zojoji: the Bussokuseki — the Buddha's Footprints. Carved into rock, larger than life, the outline of where the Buddha stood.\n\nBryan stepped onto it. Lined up his feet with the carved prints.\n\nHe prayed for God to direct his steps — all day, and all trip.\n\nA few hours later he was at the Ministry of Defense."
})

with open('public/private/japan/pins.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# Verify
with open('public/private/japan/pins.json', encoding='utf-8') as f:
    check = json.load(f)
pins_check = {p['id']: p for p in check['pins']}
print('yakitori-tokyo cards:', len(pins_check['yakitori-tokyo']['extra_cards']))
print('suimei-shabu cards:', len(pins_check['suimei-shabu']['extra_cards']))
print('zojoji-tokyo-tower cards:', len(pins_check['zojoji-tokyo-tower']['extra_cards']))
print('JSON valid, total pins:', len(check['pins']))
