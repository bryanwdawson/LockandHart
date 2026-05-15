import json

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    data = json.load(f)

new_pin = {
  "id": "hokuto-sukiyaki",
  "type": "landmark",
  "title": "Hokuto — Sukiyaki at the Ginza Corridor",
  "city": "Tokyo",
  "neighborhood": "Ginza",
  "coords": [35.6712, 139.7638],
  "visited": "2026-04-19",
  "status": "confirmed",
  "facts": [
    "Taishu Sukiyaki Hokuto, Ginza Corridor Branch",
    "Yamashita Building 2F, 6-2 Ginza, Chuo-ku",
    "Kyoto-origin chain — first Tokyo location opened April 17, 2026",
    "A4–A5 Japanese black wagyu at accessible prices"
  ],
  "extra_cards": [
    {
      "title": "Two days after opening",
      "body": "Hokuto's first Tokyo location opened April 17, 2026 — the day Bryan landed. He walked in on April 19. The Ginza Corridor branch of a Kyoto institution, serving wagyu sukiyaki at prices that don't require a special occasion.\n\nThe restaurant is in the Ginza Corridor, the covered dining street that runs under the elevated rail tracks between Ginza and Yurakucho. Bryan had just come from Kabuki-za, two blocks south."
    },
    {
      "title": "How to eat sukiyaki",
      "body": "Sukiyaki is cooked at the table in a shallow iron pan. Thinly sliced wagyu goes in first, seared in a mix of soy sauce, sugar, and mirin — the sauce is called warishita. Tofu, noodles, and vegetables follow.\n\nThe Japanese way: crack a raw egg into a small bowl, beat it lightly, and dip each piece of beef as you pull it from the pan. The egg cools the meat and adds richness. You don't have to — but this is how it's done."
    }
  ],
  "tags": ["food", "wagyu", "hot-pot", "ginza"],
  "photos": ["20260419_155740.jpg"]
}

data['pins'].append(new_pin)

with open('public/private/japan/pins.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

with open('public/private/japan/pins.json', encoding='utf-8') as f:
    check = json.load(f)
ids = [p['id'] for p in check['pins']]
print(f'Total pins: {len(check["pins"])}')
print(f'hokuto-sukiyaki added: {"hokuto-sukiyaki" in ids}')
