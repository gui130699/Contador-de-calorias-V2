# 📱 Guia de Teste no Celular

## 🔍 Como Testar no Celular

### 1️⃣ Pré-requisitos
- ✅ App deve estar hospedado em **HTTPS** (GitHub Pages)
- ✅ Navegador atualizado (Chrome/Safari)
- ✅ **NÃO** estar em modo anônimo/privado

### 2️⃣ Teste de Instalação

#### Android (Chrome)
1. Acesse a URL HTTPS do app
2. Aguarde 5-10 segundos
3. Deve aparecer um popup "Adicionar à tela inicial"
4. Se não aparecer:
   - Toque nos ⋮ (três pontos)
   - Procure "Instalar app" ou "Adicionar à tela inicial"
5. **Verifique**: O botão "📱 Instalar" no header deve estar ativo

#### iOS (Safari)
1. Abra **somente no Safari** (não funciona em Chrome iOS)
2. Toque no ícone de compartilhar (⬆️)
3. Role até "Adicionar à Tela de Início"
4. Confirme

### 3️⃣ Teste de Armazenamento

#### Método 1: Interface Visual
1. Vá para a aba **"⚙️ Config"**
2. Role até "🔄 Armazenamento"
3. Toque em **"🔍 Testar Armazenamento"**
4. Leia os resultados:
   - ✅ = Funcionando
   - ⚠️ = Atenção
   - ❌ = Problema

#### Método 2: Console do Navegador

**Android Chrome:**
1. Digite na barra de endereços: `chrome://inspect`
2. Conecte o celular via USB
3. Ative "Depuração USB" nas opções do desenvolvedor
4. Inspecione a página
5. Vá na aba "Console"
6. Execute os comandos abaixo

**iOS Safari:**
1. No iPhone: Settings → Safari → Advanced → Web Inspector (ativar)
2. No Mac: Safari → Develop → [Seu iPhone] → NutriX
3. Vá na aba "Console"
4. Execute os comandos abaixo

**Comandos para testar:**
```javascript
// 1. Verificar se localStorage funciona
console.log('localStorage disponível:', typeof localStorage !== 'undefined');
localStorage.setItem('teste', 'ok');
console.log('localStorage escrita:', localStorage.getItem('teste') === 'ok');

// 2. Verificar IndexedDB
console.log('IndexedDB disponível:', typeof indexedDB !== 'undefined');

// 3. Ver estado atual
console.log('Estado atual:', window.state);
console.log('Dias com dados:', Object.keys(window.state.entries || {}).length);

// 4. Testar salvamento
await saveState(window.state);
console.log('Salvamento concluído');

// 5. Verificar Service Worker
navigator.serviceWorker.getRegistration().then(reg => {
  console.log('Service Worker:', reg ? 'Registrado' : 'Não registrado');
  if (reg) console.log('SW Status:', reg.active ? 'Ativo' : 'Inativo');
});
```

### 4️⃣ Teste de Persistência

**Teste Completo:**
1. Abra o app
2. Adicione um lançamento (ex: 100g de Arroz)
3. **Observe o indicador** no header:
   - Deve mudar para 🟡 "Salvando..."
   - Depois 🟢 "Salvo"
   - Depois 🔵 "Pronto"
4. Se não mudar para verde: **PROBLEMA!**
5. Toque em "⚙️ Config" → "💾 Salvar Agora (Forçar)"
6. **Feche completamente o app:**
   - Android: Limpe da lista de apps recentes
   - iOS: Deslize para cima e force quit
7. Aguarde 10 segundos
8. Reabra o app
9. **VERIFIQUE**: O lançamento ainda está lá?

**Resultado Esperado:**
- ✅ Lançamento permanece = Armazenamento OK
- ❌ Lançamento sumiu = Problema de persistência

### 5️⃣ Diagnóstico de Problemas

#### Dados não salvam
```javascript
// Execute no console:
console.group('🔍 DIAGNÓSTICO');

// Verificar modo privado
console.log('1. Modo Privado:', 
  !window.indexedDB ? 'SIM (PROBLEMA!)' : 'Não');

// Verificar espaço
navigator.storage.estimate().then(est => {
  const used = (est.usage / 1024 / 1024).toFixed(2);
  const quota = (est.quota / 1024 / 1024).toFixed(2);
  console.log(`2. Armazenamento: ${used}MB / ${quota}MB`);
});

// Verificar localStorage
try {
  localStorage.setItem('test', '1');
  localStorage.removeItem('test');
  console.log('3. localStorage: OK');
} catch(e) {
  console.log('3. localStorage: ERRO -', e.name);
}

// Verificar dados atuais
const data = localStorage.getItem('caloria-pwa-v5');
console.log('4. Dados salvos:', data ? 'SIM' : 'NÃO');
if (data) {
  const size = (data.length / 1024).toFixed(2);
  console.log('   Tamanho:', size, 'KB');
}

console.groupEnd();
```

#### Instalação não funciona
```javascript
// Execute no console:
console.group('🔍 DIAGNÓSTICO PWA');

// Verificar HTTPS
console.log('1. Protocolo:', location.protocol);
console.log('   Esperado: https: ou http: (localhost)');

// Verificar manifest
fetch('./manifest.webmanifest')
  .then(r => r.ok ? 'OK' : 'ERRO')
  .then(status => console.log('2. Manifest:', status));

// Verificar Service Worker
navigator.serviceWorker.getRegistrations().then(regs => {
  console.log('3. Service Workers:', regs.length);
  regs.forEach(reg => {
    console.log('   URL:', reg.scope);
    console.log('   Status:', reg.active ? 'Ativo' : 'Inativo');
  });
});

// Verificar beforeinstallprompt
window.addEventListener('beforeinstallprompt', (e) => {
  console.log('4. Install Prompt: DISPARADO');
});

console.log('4. Install Prompt: Aguardando...');

console.groupEnd();
```

### 6️⃣ Soluções Comuns

| Problema | Solução |
|----------|---------|
| Dados não salvam | 1. Desative modo privado<br>2. Use "Salvar Agora (Forçar)"<br>3. Limpe cache e tente novamente |
| Botão instalar inativo | 1. Use HTTPS (GitHub Pages)<br>2. Aguarde 10 segundos<br>3. Recarregue a página |
| App não abre offline | 1. Abra online primeiro<br>2. Navegue por todas as abas<br>3. Feche e reabra |
| Lançamentos somem | 1. Verifique indicador (🟢 Salvo)<br>2. Force salvamento manual<br>3. Teste armazenamento |

### 7️⃣ Logs Importantes

**O que procurar no console:**
- ✅ `✅ IndexedDB inicializado`
- ✅ `💾 Estado salvo no localStorage`
- ✅ `✅ Salvo no IndexedDB`
- ✅ `✅ Dados salvos com sucesso (2/2 métodos)`

**Sinais de problema:**
- ❌ `❌ Erro ao salvar no localStorage`
- ❌ `QuotaExceededError`
- ❌ `❌❌ FALHA CRÍTICA: Dados não foram salvos!`
- ⚠️ `⚠️ IndexedDB não inicializado`

### 8️⃣ Comandos Úteis

```javascript
// Forçar limpeza total
localStorage.clear();
location.reload();

// Ver todos os dados
console.log(JSON.parse(localStorage.getItem('caloria-pwa-v5')));

// Tamanho dos dados
const size = new Blob([localStorage.getItem('caloria-pwa-v5')]).size;
console.log(`Tamanho: ${(size/1024).toFixed(2)} KB`);

// Exportar dados (backup)
const backup = localStorage.getItem('caloria-pwa-v5');
console.log('COPIE E SALVE ESTE TEXTO:');
console.log(backup);

// Importar dados (restaurar)
const dados = '...'; // Cole o backup aqui
localStorage.setItem('caloria-pwa-v5', dados);
location.reload();
```

---

## 🆘 Suporte

Se nada funcionar:
1. Tire screenshots dos resultados do console
2. Anote qual celular/navegador está usando
3. Descreva exatamente o que acontece
4. Reporte o problema com os detalhes acima

**Lembre-se:**
- ⚠️ Sempre use **HTTPS** no celular
- ⚠️ Nunca use **modo anônimo/privado**
- ⚠️ Dê permissões necessárias ao navegador
