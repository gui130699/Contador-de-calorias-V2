# 🔧 Configuração do Supabase para Desenvolvimento

## ⚠️ **PROBLEMA IDENTIFICADO**

O erro acontece porque:

1. ✅ Conta foi criada no Supabase (`✅ Usuário criado no Supabase`)
2. ❌ Login falhou (`Invalid login credentials`)
3. 🔄 Sistema usou login local (sem sessão Supabase)
4. ❌ RLS bloqueia requisições sem sessão (erro 401)

**Motivo**: Supabase exige **confirmação de email** por padrão!

---

## ✅ **SOLUÇÃO: Desabilitar Confirmação de Email**

### **Passo 1: Acessar Configurações**

1. Acesse: https://trdqrhazbnpshhtkyklv.supabase.co
2. Faça login no Supabase
3. Clique em **Authentication** (menu lateral esquerdo)
4. Clique em **Providers** (submenu)

### **Passo 2: Configurar Email Provider**

1. Procure por **Email** na lista de providers
2. Clique em **Email** para expandir
3. Encontre a opção: **"Confirm email"**
4. **DESMARQUE** a opção "Confirm email"
5. Clique em **Save** (Salvar)

### **Passo 3: Limpar Usuário Antigo**

1. Vá em **Authentication** → **Users**
2. Encontre o usuário: `guilhermeschmitt1306@gmail.com`
3. Clique nos **3 pontinhos** (⋮) ao lado do usuário
4. Selecione **Delete user**
5. Confirme a exclusão

---

## 🧪 **TESTAR NOVAMENTE**

### **1. Limpar dados locais**

Cole no Console (F12):
```javascript
localStorage.clear();
indexedDB.deleteDatabase('NutriXDB');
location.reload();
```

### **2. Criar nova conta**

- Nome: Seu Nome
- Email: seuemail@gmail.com (pode ser o mesmo)
- Senha: 123456 (mínimo 6 caracteres)

### **3. Observar o console**

Deve aparecer:
```
✅ Usuário criado no Supabase
✅ Login Supabase bem-sucedido
✅ Sessão Supabase restaurada
```

### **4. Adicionar lançamento**

Agora deve aparecer:
```
☁️ Sincronizando dados PARA Supabase...
✅ Dados sincronizados com sucesso!
```

---

## 🎯 **Alternativa: Permitir Signup Sem Confirmação (Mais Rápido)**

Se você não encontrar a opção acima, tente:

### **Opção A: URL Settings**

1. Vá em **Authentication** → **URL Configuration**
2. Encontre: **Site URL**
3. Configure: `http://localhost:8080`
4. Encontre: **Redirect URLs**
5. Adicione: `http://localhost:8080`
6. Salve

### **Opção B: Email Templates**

1. Vá em **Authentication** → **Email Templates**
2. Selecione **Confirm signup**
3. Desabilite o template (se possível)

### **Opção C: SQL Manual (Confirmar Usuário)**

1. Vá em **SQL Editor**
2. Cole este comando:

```sql
-- Ver usuários não confirmados
SELECT id, email, email_confirmed_at, created_at 
FROM auth.users 
WHERE email = 'guilhermeschmitt1306@gmail.com';

-- Confirmar email manualmente
UPDATE auth.users 
SET email_confirmed_at = NOW(),
    confirmed_at = NOW()
WHERE email = 'guilhermeschmitt1306@gmail.com';
```

3. Execute (Run)
4. Tente fazer login novamente no app

---

## 📊 **Verificar se Funcionou**

### **No Console do App:**

```
✅ Usuário criado no Supabase
✅ Login Supabase bem-sucedido
✅ Session criada: {user, session}
☁️ Sincronizando dados PARA Supabase...
✅ Dados sincronizados com sucesso!
```

### **No Supabase Dashboard:**

1. Vá em **Authentication** → **Users**
2. Veja o usuário com:
   - ✅ Email Confirmed: Yes
   - ✅ Last Sign In: (data recente)

3. Vá em **Table Editor** → **user_data**
4. Deve ter UMA linha com seus dados:
   - `user_id`: UUID do usuário
   - `email`: seu email
   - `data`: JSON com entries e meals

---

## 🐛 **Ainda Não Funciona?**

### **Debug Checklist:**

1. **Email está confirmado?**
   ```sql
   SELECT email, email_confirmed_at FROM auth.users;
   ```
   - Se `email_confirmed_at` for NULL, confirme manualmente

2. **RLS está habilitado?**
   ```sql
   SELECT tablename, rowsecurity 
   FROM pg_tables 
   WHERE schemaname = 'public' AND tablename = 'user_data';
   ```
   - `rowsecurity` deve ser `true`

3. **Políticas RLS existem?**
   ```sql
   SELECT * FROM pg_policies WHERE tablename = 'user_data';
   ```
   - Deve ter 4 políticas (SELECT, INSERT, UPDATE, DELETE)

4. **Token JWT está válido?**
   - Cole no console:
   ```javascript
   supabase.auth.getSession().then(({data}) => console.log(data.session?.access_token));
   ```
   - Deve mostrar um token longo (JWT)

---

## 🚀 **Resumo das Etapas**

1. ✅ Desabilitar "Confirm email" em Authentication → Providers → Email
2. ✅ Deletar usuário antigo em Authentication → Users
3. ✅ Limpar localStorage e IndexedDB no navegador
4. ✅ Criar nova conta no app
5. ✅ Login deve funcionar e sincronizar

---

**Siga estes passos e me avise o resultado!** 🎯
