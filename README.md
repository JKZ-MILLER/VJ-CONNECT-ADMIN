# VJ CONNECT — FULL SUPABASE

Versão conectada ao projeto Supabase fornecido.

## Subir no GitHub
O `index.html` está na raiz para o GitHub Pages abrir o painel.

## Supabase
Execute `supabase/schema.sql` no SQL Editor e crie seu usuário em Authentication -> Users.

## Vercel
Importe este repositório. A versão atual usa:
- painel: `/admin/`
- página pública: `/client/?slug=nome-do-cliente`

Após a criação de cada cliente, o painel mostra e copia a URL pública.

## Segurança
A publishable key é usada no navegador. Nunca coloque a service_role key no código.
Para o ambiente de produção, vamos restringir INSERT/UPDATE/DELETE das tabelas ao usuário administrador via RLS/Auth.

## Fluxo
Admin -> criar cliente -> salvar no Supabase -> slug individual -> URL pública -> NFC aponta para essa URL.
