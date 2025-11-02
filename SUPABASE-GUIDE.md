# 🚀 Guia de Integração Supabase - NutriX

## 📋 Visão Geral

O NutriX agora possui integração completa com Supabase para:
- ✅ Autenticação de usuários na nuvem
- ✅ Sincronização automática de dados
- ✅ Backup em tempo real
- ✅ Acesso de múltiplos dispositivos
- ✅ Alimentos customizados no banco de dados

## 🎯 Configuração do Supabase

### 1️⃣ Criar Projeto no Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Faça login ou crie uma conta
3. Clique em **"New Project"**
4. Preencha:
   - **Name:** NutriX
   - **Database Password:** (senha segura)
   - **Region:** (escolha mais próxima)
5. Aguarde a criação do projeto (~2 minutos)

### 2️⃣ Obter Credenciais

No dashboard do projeto:
1. Vá em **Settings** → **API**
2. Copie:
   - **URL:** `https://SEU-PROJETO.supabase.co`
   - **anon public key:** Token longo começando com `eyJ...`

### 3️⃣ Criar Tabelas no Banco

1. No Supabase Dashboard, clique em **SQL Editor**
2. Clique em **"New query"**
3. Cole todo o conteúdo do arquivo `supabase-schema.sql`
4. Clique em **"Run"** (ou Ctrl+Enter)
5. Aguarde confirmação: ✅ Success

**Tabelas criadas:**
- `user_data` - Dados completos do usuário
- `custom_foods` - Alimentos personalizados
- `sync_log` - Log de sincronizações (opcional)

### 4️⃣ Configurar Autenticação

1. No Supabase Dashboard, vá em **Authentication** → **Providers**
2. Habilite **Email** (já deve estar habilitado)
3. Configure opções:
   - ✅ **Enable Email Confirmations** (recomendado)
   - ✅ **Enable Email Change Confirmations**
   - ⚠️ **Disable Email Confirmations** (para testes rápidos)

4. (Opcional) Customizar templates de email:
   - Vá em **Authentication** → **Email Templates**
   - Edite templates de:
     - Confirmação de conta
     - Reset de senha
     - Mudança de email

### 5️⃣ Configurar Políticas RLS

As políticas já foram criadas pelo script SQL, mas você pode verificar:

1. Vá em **Authentication** → **Policies**
2. Verifique se há políticas para:
   - `user_data` (4 políticas)
   - `custom_foods` (4 políticas)
   - `sync_log` (2 políticas)

Cada tabela deve ter:
- ✅ SELECT (view)
- ✅ INSERT (create)
- ✅ UPDATE (edit)
- ✅ DELETE (remove)

## 🔐 Configuração no App

### Opção 1: Já Configurado ✅

O app já está configurado com suas credenciais:
```javascript
const SUPABASE_URL = 'https://trdqrhazbnpshhtkyklv.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGci...';
```

### Opção 2: Usar Suas Próprias Credenciais

Se quiser usar outro projeto Supabase:

1. Abra `index.html`
2. Procure por `/* === CONFIGURAÇÃO DO SUPABASE === */`
3. Substitua:
```javascript
const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
const SUPABASE_ANON_KEY = 'SUA-CHAVE-PUBLICA-AQUI';
```

## 🔄 Como Funciona

### Fluxo de Cadastro

```
Usuário → Preenche formulário
    ↓
App → Supabase.auth.signUp()
    ↓
Supabase → Cria usuário no banco
    ↓
Email confirmação (se habilitado)
    ↓
Usuário → Faz login
```

### Fluxo de Login

```
Usuário → Email + Senha
    ↓
App → Supabase.auth.signInWithPassword()
    ↓
Supabase → Valida credenciais
    ↓
Retorna: session + user data
    ↓
App → Sincroniza dados
    ↓
Carrega estado do usuário
```

### Fluxo de Sincronização

```
Usuário adiciona lançamento
    ↓
saveState() chamado
    ↓
Salva localStorage (rápido)
    ↓
syncToSupabase() (background)
    ↓
Supabase → Atualiza user_data
    ↓
Se alimento custom → sync custom_foods
```

### Modo Offline

```
Internet cai
    ↓
App detecta (navigator.onLine)
    ↓
Indicador muda para "Offline"
    ↓
Dados salvos apenas localmente
    ↓
Quando voltar online:
    ↓
syncPendingData() automático
    ↓
Envia tudo para Supabase
```

## 📊 Estrutura de Dados

### user_data

```json
{
  "user_id": "uuid-do-usuario",
  "email": "user@email.com",
  "data": {
    "entries": {
      "2025-11-01": [
        {
          "id": "entry-123",
          "foodName": "Arroz branco",
          "qty": 100,
          "kcal": 130,
          ...
        }
      ]
    },
    "savedMeals": {},
    "customFoods": [],
    "goals": {},
    "overrides": {}
  },
  "updated_at": "2025-11-01T10:00:00Z"
}
```

### custom_foods

```json
{
  "id": "food_1730462400000",
  "user_id": "uuid-do-usuario",
  "name": "Bolo de Cenoura Caseiro",
  "unit_base": "g",
  "kcal_100": 350,
  "prot_100": 5.5,
  "carb_100": 48,
  "fat_100": 15,
  "fiber_100": 2.5,
  "category": "Doces",
  "created_at": "2025-11-01T10:00:00Z"
}
```

## 🧪 Testando a Integração

### 1. Teste de Cadastro

1. Abra o app
2. Clique em "Cadastrar"
3. Preencha todos os campos
4. Clique em "Criar Conta"
5. **Verifique:**
   - ✅ Mensagem de sucesso
   - ✅ Redirecionado para login
   - ✅ No Supabase Dashboard → Authentication → Users
   - ✅ Novo usuário aparece na lista

### 2. Teste de Login

1. Faça login com email e senha
2. **Verifique:**
   - ✅ Mensagem "Login bem-sucedido"
   - ✅ Redirecionado para app
   - ✅ Nome aparece no header
   - ✅ Console mostra: `✅ Login Supabase bem-sucedido`

### 3. Teste de Sincronização

1. Adicione um lançamento
2. **Verifique no console:**
   - ✅ `💾 Dados do usuário salvos localmente`
   - ✅ `☁️ Sincronizando dados para Supabase...`
   - ✅ `✅ Dados do usuário sincronizados`

3. **Verifique no Supabase:**
   - Table Editor → `user_data`
   - Deve ter 1 linha com seu email
   - Clique para ver o JSON em `data`
   - Deve conter seu lançamento

### 4. Teste de Alimento Customizado

1. Crie um alimento personalizado
2. **Verifique no console:**
   - ✅ `🍎 Sincronizando alimentos customizados...`
   - ✅ `✅ Alimentos customizados sincronizados`

3. **Verifique no Supabase:**
   - Table Editor → `custom_foods`
   - Deve ter 1 linha com seu alimento

### 5. Teste Multi-Dispositivo

1. **Dispositivo A:**
   - Faça login
   - Adicione lançamentos
   - Aguarde sincronização

2. **Dispositivo B:**
   - Faça login com mesma conta
   - **Deve carregar:** todos os dados do dispositivo A

3. **Console deve mostrar:**
   ```
   📥 Sincronizando dados do Supabase...
   ✅ Dados encontrados no servidor
   ```

### 6. Teste Offline → Online

1. **Com internet:**
   - Faça login
   - Adicione lançamento
   - Veja sincronização

2. **Desative internet:**
   - Indicador muda para "Offline" (vermelho)
   - Adicione mais lançamentos
   - Dados salvos localmente

3. **Reative internet:**
   - Indicador volta para "Online" (verde)
   - Console: `🔄 Sincronizando dados pendentes...`
   - Todos os dados enviados ao Supabase

## 🔍 Monitoramento

### Via Console do Navegador

```javascript
// Ver usuário atual
console.log(currentUser);

// Ver estado completo
console.log(state);

// Forçar sincronização
await syncToSupabase();

// Buscar dados do servidor
await syncFromSupabase();

// Ver status Supabase
console.log(supabase);
```

### Via Supabase Dashboard

1. **Table Editor:**
   - Ver dados salvos
   - Editar manualmente (cuidado!)
   - Exportar para CSV/JSON

2. **Authentication → Users:**
   - Ver usuários cadastrados
   - Forçar logout
   - Deletar usuário

3. **Database → Logs:**
   - Ver queries executadas
   - Monitorar performance
   - Debug de erros

4. **API → Logs:**
   - Ver requisições
   - Status codes
   - Tempo de resposta

## 🛡️ Segurança

### Row Level Security (RLS)

Cada usuário só vê **seus próprios dados**:

```sql
-- Política de SELECT
CREATE POLICY "Users can view their own data" 
  ON user_data FOR SELECT 
  USING (auth.uid() = user_id);
```

Impossível:
- ❌ Ver dados de outro usuário
- ❌ Modificar dados de outro usuário
- ❌ Deletar dados de outro usuário

### Tokens de Acesso

- **anon key:** Seguro para uso público no frontend
- **service_role key:** ⚠️ NUNCA expor no cliente!
- **JWT:** Token de sessão com expiração automática

### Boas Práticas

✅ **FAZER:**
- Usar HTTPS em produção
- Validar dados no cliente e servidor
- Implementar rate limiting
- Monitorar logs regularmente
- Fazer backups periódicos

❌ **EVITAR:**
- Expor service_role key
- Desabilitar RLS em produção
- Armazenar senhas em plain text
- Ignorar erros de sincronização

## 📝 Troubleshooting

### "Failed to fetch" ao cadastrar

**Problema:** Supabase não está acessível

**Soluções:**
1. Verificar se URL está correta
2. Verificar se projeto está ativo no Supabase
3. Verificar conexão com internet
4. Verificar CORS (não deve ser problema com Supabase)

### "Email already registered"

**Problema:** Email já existe no banco

**Soluções:**
1. Fazer login ao invés de cadastrar
2. Ou deletar usuário no Dashboard
3. Ou usar reset de senha (se implementado)

### Dados não sincronizam

**Problema:** Sincronização falhou

**Debug:**
```javascript
// Console do navegador
console.log('Online?', isOnline);
console.log('Supabase?', supabase);
console.log('User?', currentUser);

// Tentar sincronizar manualmente
await syncToSupabase();
```

**Soluções:**
1. Verificar se está online
2. Verificar se fez login
3. Verificar console para erros
4. Verificar políticas RLS no Supabase
5. Verificar se tabelas existem

### "Row Level Security Policy Violation"

**Problema:** Política RLS bloqueando acesso

**Soluções:**
1. Verificar se executou o script SQL completo
2. Verificar se políticas estão habilitadas
3. Verificar se `auth.uid()` está correto
4. Reexecutar criação de políticas

### Performance lenta

**Problema:** Sincronização demorando

**Soluções:**
1. Verificar tamanho dos dados (JSON muito grande?)
2. Adicionar índices nas tabelas
3. Limpar dados antigos (mais de 90 dias)
4. Usar sincronização incremental (futura)

## 🚀 Melhorias Futuras

### Curto Prazo
- [ ] Sincronização incremental (só mudanças)
- [ ] Resolução de conflitos
- [ ] Indicador de progresso de sync
- [ ] Retry automático em caso de falha

### Médio Prazo
- [ ] Compartilhamento de refeições entre usuários
- [ ] Grupos/famílias
- [ ] Backup manual (export/import)
- [ ] Histórico de versões

### Longo Prazo
- [ ] Real-time sync (WebSockets)
- [ ] Notificações push
- [ ] API REST pública
- [ ] App mobile nativo

## 📚 Recursos Adicionais

- [Documentação Supabase](https://supabase.com/docs)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Supabase Database](https://supabase.com/docs/guides/database)
- [RLS Policies](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase JS Client](https://supabase.com/docs/reference/javascript/introduction)

## 🆘 Suporte

Se tiver problemas:
1. Verifique este guia completo
2. Consulte logs do console (F12)
3. Verifique Dashboard do Supabase
4. Teste com modo demo (não usa Supabase)
5. Crie issue com detalhes do erro

---

**NutriX + Supabase** = Sincronização Perfeita na Nuvem! ☁️
