-- Script SQL para criar tabelas no Supabase para o NutriX

-- =====================================================
-- TABELA: user_data
-- Armazena todos os dados do usuário (entries, meals, etc)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_data (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_user_data_user_id ON user_data(user_id);
CREATE INDEX IF NOT EXISTS idx_user_data_email ON user_data(email);
CREATE INDEX IF NOT EXISTS idx_user_data_updated_at ON user_data(updated_at);

-- RLS (Row Level Security) - Usuário só vê seus próprios dados
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own data" 
  ON user_data FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own data" 
  ON user_data FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own data" 
  ON user_data FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own data" 
  ON user_data FOR DELETE 
  USING (auth.uid() = user_id);

-- =====================================================
-- TABELA: custom_foods
-- Armazena alimentos personalizados criados pelos usuários
-- =====================================================
CREATE TABLE IF NOT EXISTS custom_foods (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  unit_base TEXT NOT NULL DEFAULT 'g',
  kcal_100 NUMERIC(10, 2) NOT NULL DEFAULT 0,
  prot_100 NUMERIC(10, 2) NOT NULL DEFAULT 0,
  carb_100 NUMERIC(10, 2) NOT NULL DEFAULT 0,
  fat_100 NUMERIC(10, 2) NOT NULL DEFAULT 0,
  fiber_100 NUMERIC(10, 2) NOT NULL DEFAULT 0,
  category TEXT NOT NULL DEFAULT 'Personalizado',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_custom_foods_user_id ON custom_foods(user_id);
CREATE INDEX IF NOT EXISTS idx_custom_foods_name ON custom_foods(name);
CREATE INDEX IF NOT EXISTS idx_custom_foods_category ON custom_foods(category);

-- RLS
ALTER TABLE custom_foods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own custom foods" 
  ON custom_foods FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own custom foods" 
  ON custom_foods FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own custom foods" 
  ON custom_foods FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own custom foods" 
  ON custom_foods FOR DELETE 
  USING (auth.uid() = user_id);

-- =====================================================
-- TABELA: sync_log (opcional - para debug)
-- Registra todas as sincronizações para auditoria
-- =====================================================
CREATE TABLE IF NOT EXISTS sync_log (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  action TEXT NOT NULL, -- 'sync_to', 'sync_from', 'login', 'logout'
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_sync_log_user_id ON sync_log(user_id);
CREATE INDEX IF NOT EXISTS idx_sync_log_created_at ON sync_log(created_at);

-- RLS
ALTER TABLE sync_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own sync log" 
  ON sync_log FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own sync log" 
  ON sync_log FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- FUNÇÕES E TRIGGERS
-- =====================================================

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para user_data
DROP TRIGGER IF EXISTS update_user_data_updated_at ON user_data;
CREATE TRIGGER update_user_data_updated_at
  BEFORE UPDATE ON user_data
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger para custom_foods
DROP TRIGGER IF EXISTS update_custom_foods_updated_at ON custom_foods;
CREATE TRIGGER update_custom_foods_updated_at
  BEFORE UPDATE ON custom_foods
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VIEWS ÚTEIS (opcional)
-- =====================================================

-- View com estatísticas de usuários
CREATE OR REPLACE VIEW user_stats AS
SELECT 
  u.id as user_id,
  u.email,
  u.created_at as user_created_at,
  ud.updated_at as last_sync,
  COUNT(DISTINCT cf.id) as custom_foods_count,
  (ud.data->>'entries')::jsonb IS NOT NULL as has_entries
FROM auth.users u
LEFT JOIN user_data ud ON u.id = ud.user_id
LEFT JOIN custom_foods cf ON u.id = cf.user_id
GROUP BY u.id, u.email, u.created_at, ud.updated_at, ud.data;

-- =====================================================
-- DADOS DE EXEMPLO (opcional - para testes)
-- =====================================================

-- Não inserir dados de exemplo em produção
-- Descomente apenas para ambiente de desenvolvimento

/*
-- Exemplo de alimento customizado
INSERT INTO custom_foods (
  id,
  user_id,
  name,
  unit_base,
  kcal_100,
  prot_100,
  carb_100,
  fat_100,
  fiber_100,
  category
) VALUES (
  'custom_' || gen_random_uuid(),
  auth.uid(), -- substitua pelo UUID do usuário de teste
  'Bolo de Cenoura Caseiro',
  'g',
  350,
  5.5,
  48,
  15,
  2.5,
  'Doces'
);
*/

-- =====================================================
-- COMENTÁRIOS NAS TABELAS (documentação)
-- =====================================================

COMMENT ON TABLE user_data IS 'Armazena todos os dados do usuário do NutriX em formato JSON';
COMMENT ON COLUMN user_data.user_id IS 'Referência ao usuário autenticado do Supabase';
COMMENT ON COLUMN user_data.data IS 'JSON com entries, savedMeals, goals, etc';
COMMENT ON COLUMN user_data.updated_at IS 'Timestamp da última atualização (sincronização)';

COMMENT ON TABLE custom_foods IS 'Alimentos personalizados criados pelos usuários';
COMMENT ON COLUMN custom_foods.id IS 'ID gerado pelo app (formato: food_timestamp)';
COMMENT ON COLUMN custom_foods.kcal_100 IS 'Calorias por 100g';
COMMENT ON COLUMN custom_foods.prot_100 IS 'Proteínas em gramas por 100g';
COMMENT ON COLUMN custom_foods.carb_100 IS 'Carboidratos em gramas por 100g';
COMMENT ON COLUMN custom_foods.fat_100 IS 'Gorduras em gramas por 100g';
COMMENT ON COLUMN custom_foods.fiber_100 IS 'Fibras em gramas por 100g';

COMMENT ON TABLE sync_log IS 'Log de sincronizações para auditoria e debug';

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se as tabelas foram criadas
SELECT 
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_name IN ('user_data', 'custom_foods', 'sync_log')
ORDER BY table_name;

-- Verificar políticas RLS
SELECT 
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('user_data', 'custom_foods', 'sync_log')
ORDER BY tablename, policyname;

-- =====================================================
-- NOTAS IMPORTANTES
-- =====================================================

/*
INSTRUÇÕES PARA USO:

1. Acesse o Supabase Dashboard (https://supabase.com)
2. Vá em seu projeto: https://trdqrhazbnpshhtkyklv.supabase.co
3. Clique em "SQL Editor" no menu lateral
4. Cole este script SQL completo
5. Clique em "Run" para executar
6. Verifique se as tabelas foram criadas em "Table Editor"

SEGURANÇA:
- Row Level Security (RLS) está HABILITADO
- Usuários só podem acessar seus próprios dados
- Todas as tabelas têm políticas de segurança
- Dados são deletados automaticamente quando usuário é removido (CASCADE)

SINCRONIZAÇÃO:
- user_data: sincroniza todo o estado do app (entries, meals, goals, etc)
- custom_foods: sincroniza apenas alimentos personalizados
- sync_log: registro opcional para debug

PERFORMANCE:
- Índices criados em colunas frequentemente consultadas
- updated_at atualizado automaticamente via trigger
- JSONB permite consultas eficientes em dados estruturados

MANUTENÇÃO:
- Backup automático do Supabase
- Logs de auditoria via sync_log
- View user_stats para monitoramento

PRÓXIMOS PASSOS:
1. Executar este script no SQL Editor
2. Habilitar autenticação de email no Supabase Auth
3. Configurar templates de email (opcional)
4. Testar cadastro e login no app
5. Verificar sincronização de dados
*/
