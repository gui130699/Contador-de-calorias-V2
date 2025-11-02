# 🍽️ NutriX

**Controle elegante de calorias e macros - Nutrição Inteligente**

NutriX é um Progressive Web App (PWA) moderno para rastreamento de calorias e macronutrientes, desenvolvido com foco em simplicidade, design elegante e funcionalidade offline.

## ✨ Características

- � **Sistema de Autenticação** - Login seguro com múltiplos usuários
- 👥 **Múltiplos Usuários** - Cada usuário com seus próprios dados isolados
- 🎯 **Modo Demo** - Acesso rápido sem cadastro para testes
- �📱 **Progressive Web App** - Instale como aplicativo nativo no seu dispositivo
- 🎨 **Interface Moderna** - Design glassmorphism com gradientes e animações suaves
- 📊 **Dashboard Intuitivo** - Visualize seus macros com círculos de progresso animados
- 🍎 **140+ Alimentos** - Base de dados pré-carregada com alimentos brasileiros
- 💾 **Offline First** - Funciona sem conexão com internet
- 📅 **Rastreamento Diário** - Acompanhe suas refeições por data
- 🥗 **Refeições Personalizadas** - Crie e salve suas refeições favoritas
- ⚙️ **Metas Customizáveis** - Configure suas metas de calorias e macros
- 🎯 **Indicadores Visuais** - Veja quando atingir 100% das suas metas
- 🎨 **Dashboard Personalizável** - Escolha quais macros visualizar

## 🚀 Tecnologias

- HTML5
- CSS3 (Tailwind CSS)
- JavaScript (Vanilla)
- Service Worker (para funcionalidade offline)
- LocalStorage + IndexedDB (persistência local)
- **Supabase** (backend, autenticação e banco de dados na nuvem)
  - Autenticação de usuários
  - PostgreSQL com Row Level Security
  - Sincronização automática
  - Real-time ready

## 📦 Estrutura do Projeto

```
PWA/
├── index.html              # Aplicação principal
├── manifest.webmanifest    # Manifesto do PWA
├── sw.js                   # Service Worker
├── icons/                  # Ícones do aplicativo
│   ├── icon-192.png
│   └── icon-512.png
├── criar-icones.py         # Script para gerar ícones
└── README.md               # Este arquivo
```

## 🎯 Funcionalidades

### 🔐 Autenticação
- Login seguro com email e senha
- Cadastro de novos usuários
- Modo demonstração (sem cadastro)
- Dados isolados por usuário
- Logout com salvamento automático
- Informações da conta na aba Config

📖 **[Guia Completo de Autenticação](./AUTH-GUIDE.md)**  
☁️ **[Guia de Integração Supabase](./SUPABASE-GUIDE.md)**

### Dashboard
- Visualização de calorias e macros do dia
- Círculos de progresso com porcentagem
- Indicador ✓ quando meta é atingida
- Personalização de quais macros exibir

### Lançamentos
- Busca rápida de alimentos
- Cálculo automático de macros
- Seleção de tipo de refeição
- Quantidade personalizável

### Refeições
- Salvar combinações de alimentos
- Reutilizar refeições em diferentes dias
- Visualizar histórico de refeições

### Alimentos
- 140+ alimentos pré-cadastrados
- Adicionar alimentos personalizados
- Busca por nome
- Informações nutricionais completas

### Configurações
- Definir metas de calorias
- Configurar metas de proteínas, carboidratos, gorduras e fibras
- Ajustes salvos automaticamente

### Relatórios
- Visualizar dados por período
- Análise de consumo

## 🛠️ Como Usar

1. **Abra o arquivo** `index.html` em um navegador moderno
2. **Ou sirva com um servidor local:**
   ```bash
   python -m http.server 8000
   ```
3. **Acesse:** `http://localhost:8000`
4. **Instale o PWA:** Clique no botão "📱 Instalar" no header

## 🎨 Gerando Ícones

Os ícones já estão incluídos na pasta `icons/`, mas se precisar regerar:

```bash
python criar-icones.py
```

Isso criará:
- `icons/icon-192.png` (192x192px)
- `icons/icon-512.png` (512x512px)

## 📱 Instalação como App

### ⚠️ IMPORTANTE: Requisitos
Para instalar como PWA, você precisa:
- ✅ Acessar via **HTTPS** (ou localhost)
- ✅ Usar um navegador compatível (Chrome, Edge, Safari)
- ❌ **NÃO funciona** com http:// ou file:// no celular

### 🌐 Como Hospedar (GitHub Pages - RECOMENDADO)
1. Suba os arquivos para um repositório GitHub
2. Vá em Settings → Pages
3. Ative o GitHub Pages
4. Seu app estará em: `https://seu-usuario.github.io/nutrix`
5. **Agora sim** poderá instalar no celular! 📱

### Desktop (Chrome/Edge)
1. Clique no ícone de instalação na barra de endereços
2. Ou use o botão "📱 Instalar" no aplicativo

### Mobile (Android)
**Via Chrome:**
1. Acesse a URL HTTPS do seu app
2. Aguarde alguns segundos
3. Aparecerá um popup "Adicionar NutriX à tela inicial"
4. Ou toque nos três pontos (⋮) → "Instalar app"

**Via menu:**
1. Abra no Chrome
2. Toque nos três pontos (⋮)
3. Selecione "Adicionar à tela inicial"
4. Confirme a instalação

### Mobile (iOS)
1. Abra no **Safari** (não funciona em outros navegadores)
2. Toque no ícone de **compartilhar** (quadrado com seta)
3. Role para baixo e selecione "**Adicionar à Tela de Início**"
4. Dê um nome e confirme

### 🔍 Troubleshooting

**Botão "Instalar" aparece desabilitado?**
- ✅ Verifique se está usando HTTPS (ou localhost)
- ✅ **NO CELULAR**: Só funciona com HTTPS! Use GitHub Pages
- ✅ Aguarde alguns segundos após carregar a página
- ✅ Recarregue a página (F5 ou pull-to-refresh)
- ✅ Limpe o cache do navegador
- ✅ No console, veja se há erros relacionados ao Service Worker

**Dados não são salvos no celular?**
- ✅ **TESTE PRIMEIRO**: Vá em Configurações → Testar Armazenamento
- ✅ Não use **modo anônimo/privado** (Safari Private, Chrome Incognito)
- ✅ Verifique se tem espaço disponível no dispositivo
- ✅ No iOS Safari, ative "Permitir rastreamento entre sites" nas configurações
- ✅ **Use o botão "Salvar Agora (Forçar)"** após adicionar lançamentos
- ✅ Olhe o indicador de salvamento no header (deve ficar verde)
- ✅ Abra o console do navegador (Safari iOS: Settings → Safari → Advanced → Web Inspector)

**Sistema Dual de Armazenamento:**
O app usa **2 métodos** para garantir que seus dados não sejam perdidos:
1. **LocalStorage** (rápido, mas tem limites)
2. **IndexedDB** (robusto, suporta mais dados)

Se um falhar, o outro mantém seus dados seguros! 💾

**Indicador de Status:**
- 🟡 **Salvando...** - Dados sendo gravados
- 🟢 **Salvo** - Sucesso! Dados seguros
- 🔵 **Pronto** - Aguardando novos dados
- 🔴 **Erro** - Problema ao salvar (veja o console)

## 🗂️ Dados

Todos os dados são armazenados localmente usando **sistema dual**:

### LocalStorage (Primary)
- **Estado da aplicação:** `caloria-pwa-v5`
- **Preferências do dashboard:** `dashboardPrefs`
- **Tipos de refeições:** `mealTypes`

### IndexedDB (Backup Automático)
- **Banco:** `NutriXDB`
- **Object Store:** `appState`
- Sincronização automática a cada salvamento

### Auto-Save Agressivo
O app salva seus dados automaticamente:
- ✅ A cada **20 segundos** (background)
- ✅ Ao **adicionar/remover** lançamentos
- ✅ Ao **minimizar** o app
- ✅ Ao **trocar de aba** no navegador
- ✅ Antes de **fechar** a janela/app
- ✅ Ao detectar **pause** (mobile)

## 🔐 Privacidade

- ✅ Nenhum dado é enviado para servidores externos
- ✅ Todos os dados ficam no seu dispositivo
- ✅ Não há rastreamento ou analytics
- ✅ Funciona 100% offline

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para:
- Reportar bugs
- Sugerir novas funcionalidades
- Adicionar mais alimentos à base de dados
- Melhorar a interface

## 📄 Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

## 🎯 Roadmap

- [ ] Gráficos de evolução
- [ ] Exportar/importar dados
- [ ] Sincronização entre dispositivos
- [ ] Modo escuro/claro
- [ ] Scanner de códigos de barras
- [ ] Integração com APIs de alimentos

## 👨‍💻 Desenvolvimento

Desenvolvido com ❤️ usando tecnologias web modernas.

---

**NutriX** - Nutrição Inteligente ao seu alcance 🍽️
