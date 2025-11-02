# 🚀 Deploy no GitHub Pages

## 📋 Passos para Publicar

### 1. **Criar Repositório no GitHub**
```bash
git init
git add .
git commit -m "Initial commit - NutriX PWA"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/nutrix.git
git push -u origin main
```

### 2. **Ativar GitHub Pages**
1. Vá em **Settings** → **Pages**
2. Em **Source**, selecione: `Branch: main` e `/ (root)`
3. Clique em **Save**
4. Aguarde 1-2 minutos

### 3. **Acessar o App**
- URL: `https://SEU-USUARIO.github.io/nutrix/`

---

## ✅ Checklist PWA para Produção

- [x] `.nojekyll` criado (desativa Jekyll no GitHub Pages)
- [x] Service Worker com detecção automática de base path
- [x] Manifest com paths absolutos
- [x] HTTPS automático (GitHub Pages)
- [x] Ícones 192x192 e 512x512

---

## 🔧 Troubleshooting

### ❌ PWA não instala no GitHub Pages

**Problema:** `beforeinstallprompt` não dispara

**Solução:**
1. Abra DevTools (F12)
2. Vá em **Application** → **Manifest**
3. Verifique se há erros
4. Vá em **Service Workers**
5. Verifique se está registrado
6. Se necessário, clique em **Unregister** e recarregue

### ❌ Service Worker não registra

**Problema:** Erro 404 no `sw.js`

**Solução:**
1. Verifique se `sw.js` está na raiz do repositório
2. Limpe o cache: DevTools → Application → Clear storage
3. Recarregue com Ctrl+Shift+R

### ❌ Manifest não carrega

**Problema:** Erro de CORS ou 404

**Solução:**
1. Verifique se `manifest.webmanifest` está na raiz
2. Certifique-se que `.nojekyll` existe
3. Aguarde alguns minutos após o deploy

---

## 📱 Testar Instalação

### Desktop (Chrome/Edge):
1. Acesse a URL do GitHub Pages
2. Aguarde 5 segundos
3. Clique no ícone de instalação na barra de endereço
4. Ou: Menu (⋮) → "Instalar NutriX"

### Mobile (Android):
1. Acesse a URL no Chrome
2. Toque em Menu (⋮)
3. Toque em "Adicionar à tela inicial"
4. Confirme a instalação

### Mobile (iOS/Safari):
1. Acesse a URL no Safari
2. Toque no botão "Compartilhar" (□↑)
3. Role para baixo
4. Toque em "Adicionar à Tela Inicial"
5. Toque em "Adicionar"

---

## 🔄 Atualizar o App

Após fazer mudanças:

```bash
git add .
git commit -m "Update: descrição das mudanças"
git push
```

Aguarde 1-2 minutos e o GitHub Pages será atualizado automaticamente.

---

## 💡 Dicas

1. **Teste localmente primeiro:** `python -m http.server 8080`
2. **Use HTTPS sempre:** GitHub Pages fornece automaticamente
3. **Atualize o CACHE_NAME** no `sw.js` após mudanças importantes
4. **Monitore o Console:** DevTools → Console para ver logs

---

## 📊 Verificar Status do Deploy

1. Vá em **Actions** no GitHub
2. Veja o status do workflow "pages build and deployment"
3. ✅ = Deploy completo
4. ❌ = Erro no deploy (verifique os logs)

---

## 🌐 Domínio Customizado (Opcional)

Se quiser usar seu próprio domínio:

1. **Settings** → **Pages** → **Custom domain**
2. Digite seu domínio (ex: `nutrix.com.br`)
3. Adicione registro DNS:
   - Tipo: `CNAME`
   - Nome: `@` ou `www`
   - Valor: `SEU-USUARIO.github.io`
4. Aguarde propagação DNS (até 24h)

---

✅ **Tudo configurado!** Seu PWA está pronto para produção no GitHub Pages! 🎉
