# Script para buscar URLs reais das imagens na wiki Blox Fruits
$items = @(
    # Estilos de Luta
    @{id="sanguine_art"; name="Sanguine_Art"},
    @{id="godhuman"; name="Godhuman"},
    @{id="dragon_talon"; name="Dragon_Talon"},
    @{id="electric_claw"; name="Electric_Claw"},
    @{id="sharkman_karate"; name="Sharkman_Karate"},
    # Espadas
    @{id="cdk"; name="Cursed_Dual_Katana"},
    @{id="yama"; name="Yama"},
    @{id="tushita"; name="Tushita"},
    @{id="ttk"; name="True_Triple_Katana"},
    @{id="sashi"; name="Sashi"},
    @{id="oroshi"; name="Oroshi"},
    @{id="shizu"; name="Shizu"},
    @{id="mini_yoru"; name="Mini_Yoru"},
    @{id="dragon_heart"; name="Dragonheart"},
    @{id="fox_lamp"; name="Fox_Lamp"},
    @{id="foice_sagrada"; name="Holy_Scythe"},
    @{id="shark_anchor"; name="Shark_Anchor"},
    @{id="yoru"; name="Yoru"},
    # Itens
    @{id="dark_coat"; name="Dark_Coat"},
    @{id="dark_fragment"; name="Dark_Fragment"},
    @{id="kitsune_mask"; name="Kitsune_Mask"},
    @{id="kitsune_ribbon"; name="Kitsune_Ribbon"},
    @{id="kitsune_title"; name="Kitsune_Title"},
    @{id="kitsune_aura"; name="Kitsune_Aura"},
    @{id="dino_hood"; name="Dino_Hood"},
    @{id="dragon_egg"; name="Dragon_Egg"},
    @{id="belly"; name="Belly"},
    @{id="fragment"; name="Fragment"},
    @{id="haki"; name="Legendary_Haki"},
    # Armas
    @{id="dragon_storm"; name="Dragon_Storm"},
    @{id="soul_guitar"; name="Soul_Guitar"},
    @{id="kabucha"; name="Kabucha"},
    @{id="acidum_rifle"; name="Acidum_Rifle"},
    @{id="serpent_bow"; name="Serpent_Bow"},
    # Raças
    @{id="draco"; name="Draco"},
    @{id="cyborg"; name="Cyborg"},
    @{id="ghoul"; name="Ghoul"},
    @{id="draco_v4"; name="Draco_V4"},
    @{id="blue_gear"; name="Blue_Gear"},
    @{id="mirror_fractal"; name="Mirror_Fractal"},
    @{id="rip_indra"; name="Rip_Indra"},
    # Leviathan
    @{id="leviathan_heart"; name="Leviathan_Heart"},
    @{id="frozen_hydra"; name="Frozen_Hydra"},
    @{id="leviathan_crown"; name="Leviathan_Crown"},
    @{id="leviathan_shield"; name="Leviathan_Shield"},
    @{id="leviathan_boat"; name="Leviathan_Boat"}
)

$result = @{}
foreach ($item in $items) {
    $title = $item.name
    $url = "https://blox-fruits.fandom.com/api.php?action=query&titles=$title&prop=pageimages&format=json&pithumbsize=300"
    try {
        $response = Invoke-RestMethod -Uri $url -UserAgent "Mozilla/5.0" -TimeoutSec 10
        $pages = $response.query.pages
        $pageId = ($pages.PSObject.Properties.Name)[0]
        $page = $pages.$pageId
        if ($page.thumbnail) {
            $imgUrl = $page.thumbnail.source
            $result[$item.id] = $imgUrl
            Write-Host "OK  $($item.id) -> $imgUrl"
        } else {
            Write-Host "ERR $($item.id) - sem thumbnail"
        }
    } catch {
        Write-Host "ERR $($item.id) - $_"
    }
    Start-Sleep -Milliseconds 200
}

# Salvar em JSON
$result | ConvertTo-Json -Depth 3 | Out-File -FilePath "$PSScriptRoot\imagens.json" -Encoding UTF8
Write-Host "`nTotal encontrado: $($result.Count)/$($items.Count)"
