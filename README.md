# VJ CONNECT PRO

Sistema separado em:
- `public/index.html`: landing page comercial da VJ CONNECT
- `admin/index.html`: painel privado do administrador
- `client/index.html`: página pública de cada cliente

## Supabase
1. Crie um projeto no Supabase.
2. Abra `supabase/schema.sql` (incluído neste projeto) e execute no SQL Editor.
3. Copie `admin/config.example.js` para `admin/config.js`.
4. Preencha a URL e a chave ANON do projeto.
5. No Supabase Auth, crie seu usuário administrador.
6. Aplique a URL do `admin/index.html` nas configurações de URL do Supabase.

O navegador nunca recebe a service_role key. O isolamento entre clientes é feito por RLS.
