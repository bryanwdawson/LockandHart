import json

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)

pins = {p['id']: p for p in data['pins']}

# Check current state
w = pins['wagyu-restaurant']
print('Current title:', w.get('title'))
print('Current facts:', list(w.get('facts', {}).keys()) if isinstance(w.get('facts'), dict) else w.get('facts'))
print('Current cards:', len(w.get('extra_cards', [])))
for c in w.get('extra_cards', []):
    print('  -', c.get('title'))

# Build extra_cards
pins['wagyu-restaurant']['extra_cards'] = [
    {
        "title": "The team joke",
        "body": "All week, Clair had been picking the restaurants. High-end Japanese places with perfect meat and delicate fish. Nobody complained — the food was always exceptional. But one running joke in the group: someone on the team just wanted a wagyu burger.\n\nMentioned it multiple times a day. Didn't happen.\n\nAfter everyone went their separate ways — some to the airport, some to other hotels — the group chat lit up with wagyu burger photos. Bryan was still in Tokyo. He hadn't had one either.\n\nTonight was the night."
    },
    {
        "title": "An hour in line",
        "body": "Google Maps. Highly rated. Sign out front promoting its rankings. And a line.\n\nBryan got in it. Caught up on texts, went through photos, stood there alone for about an hour. Not many parties of one.\n\nWhen he finally reached the front, the host wouldn't seat him. Told him to get back in line. Bryan asked why — he was next. The host moved past him to the family of four behind him and said it would be a few minutes.\n\nHe had no idea what was happening. He was starving. It was late. He asked again, clearly: he'd been waiting in line, when would he be seated? The host said he needed to wait.\n\nThe family behind him — tourists, Middle East or South Asia — heard the whole thing. When the host came back out, they spoke up. He's been waiting. He's in front of us.\n\nThe host had thought Bryan cut the line. Once it was sorted, Bryan was seated."
    },
    {
        "title": "The menu, the story, the flame",
        "body": "The menu told the story before the food arrived. The history of the cows. The specific breed, what makes wagyu different — the fat marbling, the grading, the way the cattle are raised. The owner's search for the right source.\n\nThis is what people rave about Japanese food. The level of care. Making the best possible version of the thing, not just the thing. A burger is a burger. A wagyu burger at a place like this is the result of someone's life's work.\n\nThey brought it out and put a flame to it. The fat crisped at the edge. Bryan was starving. He's also pretty sure it was the best burger he's ever had.\n\nHe called Kel. Got some sleep. Sunrise hike in the morning."
    }
]

with open('public/private/japan/pins.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    check = json.load(f)
pins_check = {p['id']: p for p in check['pins']}
print('wagyu-restaurant cards after build:', len(pins_check['wagyu-restaurant']['extra_cards']))
print('JSON valid, total pins:', len(check['pins']))
