# 🔐 Sistema de Autenticação - NutriX

## 📋 Visão Geral

O NutriX agora possui um sistema completo de autenticação que permite:
- ✅ Cadastro de múltiplos usuários
- ✅ Login seguro
- ✅ Dados isolados por usuário
- ✅ Modo demonstração (sem cadastro)
- ✅ Logout seguro com salvamento automático

## 🎯 Características

### 🔒 Segurança Local
- Todos os dados são armazenados **localmente** no dispositivo
- Nenhuma informação é enviada para servidores externos
- Senhas são codificadas (Base64) antes de serem armazenadas
- Cada usuário tem seus próprios dados isolados

### 👤 Múltiplos Usuários
- Cadastre quantos usuários quiser no mesmo dispositivo
- Cada usuário tem:
  - Seus próprios lançamentos
  - Suas próprias refeições salvas
  - Suas próprias metas nutricionais
  - Seus próprios alimentos customizados

### 🎯 Modo Demonstração
- Acesso rápido sem cadastro
- Ideal para testar o aplicativo
- Dados não são salvos permanentemente
- Perfeito para demonstrações

## 🚀 Como Usar

### 1️⃣ Primeira Vez (Cadastro)

1. Abra o aplicativo
2. Clique na aba **"Cadastrar"**
3. Preencha:
   - 👤 Nome Completo
   - 📧 Email (será usado para login)
   - 🔒 Senha (mínimo 6 caracteres)
   - 🔒 Confirmar Senha
4. Clique em **"Criar Conta"**
5. Após o cadastro, faça login com seu email e senha

### 2️⃣ Login

1. Na tela inicial, clique na aba **"Entrar"**
2. Digite seu email ou usuário
3. Digite sua senha
4. Clique em **"Entrar"**

### 3️⃣ Modo Demo

1. Na tela de login, clique em **"🎯 Entrar como Demo"**
2. Acesso imediato sem cadastro
3. Explore todas as funcionalidades

### 4️⃣ Logout

**Opção 1:** Botão no header
- Clique no ícone **🚪** no canto superior direito

**Opção 2:** Configurações
- Vá em **⚙️ Config**
- Role até "👤 Sua Conta"
- Clique em **"🚪 Sair da Conta"**

## 📊 Informações da Conta

Na aba **"⚙️ Config"**, você encontra:
- 👤 Nome do usuário
- 📧 Email cadastrado
- 📅 Data de cadastro
- 🏷️ Badge de status (Ativo/Demo)
- 🚪 Botão de logout

## 🔐 Dados Armazenados

### LocalStorage Keys

| Key | Descrição |
|-----|-----------|
| `nutrix-users` | Lista de todos os usuários cadastrados |
| `nutrix-current-user` | Usuário atualmente logado |
| `nutrix-data-{userId}` | Dados específicos de cada usuário |

### Estrutura de Usuário

```javascript
{
  id: "user_1234567890",
  name: "João Silva",
  email: "joao@email.com",
  password: "encoded_password",
  createdAt: "2025-11-01T10:30:00.000Z",
  isDemo: false
}
```

### Estrutura de Dados do Usuário

```javascript
{
  entries: {},      // Lançamentos por data
  savedMeals: {},   // Refeições salvas
  customFoods: [],  // Alimentos customizados
  goals: {},        // Metas nutricionais
  overrides: {},    // Configurações personalizadas
  selectedDate: ""  // Data selecionada
}
```

## 🛡️ Segurança

### ⚠️ IMPORTANTE

Este sistema de autenticação é projetado para uso **local** e **pessoal**:
- ✅ Perfeito para dispositivos pessoais
- ✅ Múltiplos usuários na mesma família
- ✅ Dados privados no dispositivo
- ❌ **NÃO** é seguro para produção web
- ❌ **NÃO** sincroniza entre dispositivos
- ❌ **NÃO** possui recuperação de senha

### 🔒 Codificação de Senha

A senha é codificada usando **Base64**:
```javascript
// Salvar
encoded = btoa(password)

// Verificar
original = atob(encoded)
```

> **NOTA:** Base64 NÃO é criptografia! É apenas codificação reversível. Para um app de produção, use bcrypt, scrypt ou argon2.

## 🔄 Fluxo de Autenticação

```
┌─────────────────┐
│  Abrir App      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Verificar Login │
└────┬───────┬────┘
     │       │
 Sim │       │ Não
     │       │
     ▼       ▼
┌─────┐  ┌──────────┐
│ App │  │  Login   │
│     │  │  Screen  │
└─────┘  └──────────┘
```

## 🎨 Interface

### Tela de Login
- 🍽️ Logo animado
- 📧 Campo de email/usuário
- 🔒 Campo de senha
- 🔵 Botão "Entrar"
- 🎯 Link para modo demo

### Tela de Cadastro
- 👤 Campo de nome
- 📧 Campo de email
- 🔒 Campo de senha
- 🔒 Campo de confirmar senha
- 🔵 Botão "Criar Conta"

### Validações
- ✅ Todos os campos obrigatórios
- ✅ Senha mínima de 6 caracteres
- ✅ Senhas devem coincidir
- ✅ Email não pode estar duplicado
- ✅ Mensagens de erro claras

## 🔧 Funções Principais

### `initAuth()`
Inicializa o sistema de autenticação ao carregar o app.

### `login(username, password)`
Realiza o login de um usuário.

### `signup(name, email, password, passwordConfirm)`
Cadastra um novo usuário.

### `loginAsDemo()`
Faz login no modo demonstração.

### `logout()`
Desloga o usuário atual e salva os dados.

### `loadUserData()`
Carrega os dados específicos do usuário logado.

### `saveUserData()`
Salva os dados do usuário no localStorage.

### `updateUserGreeting()`
Atualiza a saudação no header com o nome do usuário.

### `updateProfileInfo()`
Atualiza as informações do perfil na aba Config.

## 🎯 Casos de Uso

### Família Compartilhando um Tablet
```
1. Pai cadastra conta
2. Mãe cadastra conta
3. Cada um faz login com suas credenciais
4. Dados ficam separados
```

### Nutricionista com Pacientes
```
1. Cada paciente tem uma conta
2. Nutricionista pode demonstrar no mesmo dispositivo
3. Dados de cada paciente ficam isolados
```

### Uso Pessoal
```
1. Cadastra uma conta
2. Fica sempre logado
3. Dados sempre disponíveis
```

### Demonstração/Testes
```
1. Clica em "Entrar como Demo"
2. Testa todas as funcionalidades
3. Sai e dados são descartados
```

## 🐛 Troubleshooting

### "Email já está cadastrado"
- Use um email diferente
- Ou faça login com o email existente

### "Email ou senha incorretos"
- Verifique se digitou corretamente
- Email não é case-sensitive
- Senha É case-sensitive

### "As senhas não coincidem"
- Digite a mesma senha nos dois campos
- Verifique caps lock

### Esqueci minha senha
Atualmente não há recuperação de senha. Opções:
1. Use o console do navegador para ver/resetar
2. Crie uma nova conta
3. Use modo demo

### Console para resetar senha
```javascript
// Ver todos os usuários
const users = JSON.parse(localStorage.getItem('nutrix-users'));
console.log(users);

// Resetar senha de um usuário
users[0].password = btoa('novasenha123');
localStorage.setItem('nutrix-users', JSON.stringify(users));
```

### Deletar todos os usuários
```javascript
localStorage.removeItem('nutrix-users');
localStorage.removeItem('nutrix-current-user');
location.reload();
```

## 📈 Melhorias Futuras

### Segurança
- [ ] Implementar hash de senha real (bcrypt)
- [ ] Adicionar salt único por usuário
- [ ] Rate limiting para tentativas de login
- [ ] Sessão com timeout automático

### Funcionalidades
- [ ] Recuperação de senha por email
- [ ] Autenticação de dois fatores (2FA)
- [ ] Sincronização entre dispositivos
- [ ] Backup e restauração de dados
- [ ] Exportar dados do usuário

### UX
- [ ] Foto de perfil
- [ ] Temas personalizados por usuário
- [ ] Configurações de privacidade
- [ ] Histórico de logins
- [ ] Estatísticas da conta

## 🔄 Migração de Dados Antigos

Se você já usava o NutriX antes da autenticação:

```javascript
// 1. Seus dados antigos ainda estão em:
const oldData = localStorage.getItem('caloria-pwa-v5');

// 2. Faça login ou crie uma conta

// 3. Seus dados serão migrados automaticamente
// Ou manualmente no console:
const data = JSON.parse(localStorage.getItem('caloria-pwa-v5'));
const userId = JSON.parse(localStorage.getItem('nutrix-current-user')).id;
localStorage.setItem(`nutrix-data-${userId}`, localStorage.getItem('caloria-pwa-v5'));
```

## 📝 Notas Importantes

1. **Dados Locais**: Tudo fica no seu dispositivo
2. **Sem Servidor**: Não há backend ou banco de dados remoto
3. **Privacidade**: Zero tracking, zero analytics
4. **Portabilidade**: Para mover dados entre dispositivos, use export/import (futuro)
5. **Backup**: Faça backup dos dados importantes regularmente

## 🆘 Suporte

Se tiver problemas:
1. Abra o console do navegador (F12)
2. Procure por erros em vermelho
3. Verifique se localStorage está habilitado
4. Não use modo privado/anônimo
5. Reporte bugs com detalhes do erro

---

**NutriX** - Nutrição Inteligente com Múltiplos Usuários 🍽️
