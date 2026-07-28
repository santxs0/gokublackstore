#!/bin/bash
# Script para buscar URLs reais das imagens na wiki Blox Fruits via API

ITEMS=(
    "sanguine_art:Sanguine_Art"
    "godhuman:Godhuman"
    "dragon_talon:Dragon_Talon"
    "electric_claw:Electric_Claw"
    "sharkman_karate:Sharkman_Karate"
    "cdk:Cursed_Dual_Katana"
    "yama:Yama"
    "tushita:Tushita"
    "ttk:True_Triple_Katana"
    "sashi:Sashi"
    "oroshi:Oroshi"
    "shizu:Shizu"
    "mini_yoru:Mini_Yoru"
    "dragon_heart:Dragonheart"
    "fox_lamp:Fox_Lamp"
    "foice_sagrada:Holy_Scythe"
    "shark_anchor:Shark_Anchor"
    "yoru:Yoru"
    "dark_coat:Dark_Coat"
    "dark_fragment:Dark_Fragment"
    "kitsune_mask:Kitsune_Mask"
    "kitsune_ribbon:Kitsune_Ribbon"
    "kitsune_title:Kitsune_Title"
    "kitsune_aura:Kitsune_Aura"
    "dino_hood:Dino_Hood"
    "dragon_egg:Dragon_Egg"
    "belly:Belly"
    "fragment:Fragment"
    "haki:Legendary_Haki"
    "dragon_storm:Dragon_Storm"
    "soul_guitar:Soul_Guitar"
    "kabucha:Kabucha"
    "acidum_rifle:Acidum_Rifle"
    "serpent_bow:Serpent_Bow"
    "draco:Draco"
    "cyborg:Cyborg"
    "ghoul:Ghoul"
    "draco_v4:Draco_V4"
    "blue_gear:Blue_Gear"
    "mirror_fractal:Mirror_Fractal"
    "rip_indra:Rip_Indra"
    "leviathan_heart:Leviathan_Heart"
    "frozen_hydra:Frozen_Hydra"
    "leviathan_crown:Leviathan_Crown"
    "leviathan_shield:Leviathan_Shield"
    "leviathan_boat:Leviathan_Boat"
)

cd "$(dirname "$0")"

echo "{" > imagens.json
first=1
ok=0
err=0

for entry in "${ITEMS[@]}"; do
    id="${entry%%:*}"
    name="${entry##*:}"

    response=$(curl -s -A "Mozilla/5.0" \
        "https://blox-fruits.fandom.com/api.php?action=query&titles=${name}&prop=pageimages&format=json&pithumbsize=300")

    # Extrai URL do source (com sed, evita dependência de jq)
    img_url=$(echo "$response" | grep -oE '"source":"https://static[^"]+"' | head -1 | sed 's/"source":"//;s/"$//')

    if [ -n "$img_url" ]; then
        if [ $first -eq 0 ]; then echo "," >> imagens.json; fi
        echo "  \"$id\": \"$img_url\"" >> imagens.json
        first=0
        ok=$((ok+1))
        echo "OK  $id"
    else
        err=$((err+1))
        echo "ERR $id ($name)"
    fi
    sleep 0.2
done
echo "}" >> imagens.json

echo ""
echo "=== Resultado: $ok OK, $err erros de ${#ITEMS[@]} ==="
