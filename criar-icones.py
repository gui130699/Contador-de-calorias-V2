from PIL import Image, ImageDraw, ImageFilter
import os

# Criar pasta icons se não existir
os.makedirs('icons', exist_ok=True)

def criar_icone(tamanho):
    # Criar imagem em alta resolução (2x) para melhor qualidade
    escala = 2
    tamanho_alta_res = tamanho * escala
    img = Image.new('RGBA', (tamanho_alta_res, tamanho_alta_res), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, 'RGBA')
    
    # Fundo com gradiente radial suave
    centro = tamanho_alta_res // 2
    for i in range(centro, 0, -2):
        distancia = i / centro
        # Gradiente de preto puro para cinza escuro azulado
        r = int(11 + (30 - 11) * (1 - distancia))
        g = int(18 + (41 - 18) * (1 - distancia))
        b = int(32 + (66 - 32) * (1 - distancia))
        alpha = 255
        draw.ellipse(
            [(centro - i, centro - i), (centro + i, centro + i)],
            fill=(r, g, b, alpha)
        )
    
    # Prato principal com sombra
    raio_prato = int(tamanho_alta_res * 0.36)
    
    # Sombra do prato (blur)
    sombra_offset = int(tamanho_alta_res * 0.01)
    draw.ellipse(
        [(centro - raio_prato + sombra_offset, centro - raio_prato + sombra_offset), 
         (centro + raio_prato + sombra_offset, centro + raio_prato + sombra_offset)],
        fill=(0, 0, 0, 80)
    )
    
    # Prato base (cinza escuro)
    draw.ellipse(
        [(centro - raio_prato, centro - raio_prato), 
         (centro + raio_prato, centro + raio_prato)],
        fill=(30, 41, 59, 255),  # Cinza escuro
        outline=(51, 65, 85, 255),  # Borda cinza clara
        width=int(tamanho_alta_res * 0.02)
    )
    
    # Fatias coloridas (macronutrientes) com anti-aliasing melhorado
    # Verde (vegetais/proteína)
    draw.pieslice(
        [(centro - raio_prato, centro - raio_prato), 
         (centro + raio_prato, centro + raio_prato)],
        start=0, end=120,
        fill=(16, 185, 129, 255),  # Verde vibrante
        outline=(5, 150, 105, 255),
        width=int(tamanho_alta_res * 0.012)
    )
    
    # Laranja (carboidratos)
    draw.pieslice(
        [(centro - raio_prato, centro - raio_prato), 
         (centro + raio_prato, centro + raio_prato)],
        start=120, end=240,
        fill=(245, 158, 11, 255),  # Laranja
        outline=(217, 119, 6, 255),
        width=int(tamanho_alta_res * 0.012)
    )
    
    # Vermelho (proteínas/gorduras)
    draw.pieslice(
        [(centro - raio_prato, centro - raio_prato), 
         (centro + raio_prato, centro + raio_prato)],
        start=240, end=360,
        fill=(239, 68, 68, 255),  # Vermelho
        outline=(220, 38, 38, 255),
        width=int(tamanho_alta_res * 0.012)
    )
    
    # Círculo central (centro do prato)
    raio_centro = int(tamanho_alta_res * 0.09)
    draw.ellipse(
        [(centro - raio_centro, centro - raio_centro), 
         (centro + raio_centro, centro + raio_centro)],
        fill=(30, 41, 59, 255),
        outline=(71, 85, 105, 255),
        width=int(tamanho_alta_res * 0.012)
    )
    
    # Garfo (esquerda) com mais detalhes
    garfo_x = centro - int(tamanho_alta_res * 0.26)
    garfo_y = centro - int(tamanho_alta_res * 0.08)
    largura_talher = int(tamanho_alta_res * 0.018)
    
    # Cabo do garfo com gradiente
    for i in range(10):
        offset = i * int(tamanho_alta_res * 0.015) / 10
        cor_gradiente = 148 + int((180 - 148) * i / 10)
        draw.rectangle(
            [(garfo_x - largura_talher, garfo_y + offset), 
             (garfo_x + largura_talher, garfo_y + int(tamanho_alta_res * 0.16))],
            fill=(cor_gradiente, cor_gradiente + 15, cor_gradiente + 35, 255)
        )
    
    # Dentes do garfo (4 dentes para mais realismo)
    for i in range(-1, 3):
        x_pos = garfo_x + (i - 0.5) * largura_talher * 1.8
        draw.rectangle(
            [(x_pos - largura_talher//2, garfo_y - int(tamanho_alta_res * 0.09)), 
             (x_pos + largura_talher//2, garfo_y)],
            fill=(148, 163, 184, 255)
        )
    
    # Faca (direita) com mais detalhes
    faca_x = centro + int(tamanho_alta_res * 0.26)
    faca_y = centro - int(tamanho_alta_res * 0.08)
    
    # Cabo da faca com gradiente
    for i in range(10):
        offset = i * int(tamanho_alta_res * 0.015) / 10
        cor_gradiente = 148 + int((180 - 148) * i / 10)
        draw.rectangle(
            [(faca_x - largura_talher, faca_y + offset), 
             (faca_x + largura_talher, faca_y + int(tamanho_alta_res * 0.16))],
            fill=(cor_gradiente, cor_gradiente + 15, cor_gradiente + 35, 255)
        )
    
    # Lâmina da faca (mais realista)
    draw.polygon(
        [(faca_x, faca_y - int(tamanho_alta_res * 0.11)),
         (faca_x - largura_talher * 2.5, faca_y - int(tamanho_alta_res * 0.015)),
         (faca_x + largura_talher * 2.5, faca_y - int(tamanho_alta_res * 0.015))],
        fill=(203, 213, 225, 255)
    )
    
    # Aplicar anti-aliasing e reduzir para tamanho final
    img = img.resize((tamanho, tamanho), Image.Resampling.LANCZOS)
    
    # Aplicar leve sharpen para aumentar nitidez
    img = img.filter(ImageFilter.SHARPEN)
    
    # Salvar com máxima qualidade
    img.save(f'icons/icon-{tamanho}.png', 'PNG', optimize=False, compress_level=1)
    print(f'✅ Ícone {tamanho}x{tamanho} criado em alta qualidade!')

# Criar os dois tamanhos
criar_icone(192)
criar_icone(512)

print('\n🎨 Ícones criados com ALTA NITIDEZ!')
print('📁 Salvos em: icons/icon-192.png e icons/icon-512.png')
