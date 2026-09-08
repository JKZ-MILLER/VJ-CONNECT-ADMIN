# VJ CONNECT — FULL

## O que existe
- `admin/index.html`: painel/template mestre com criação, edição, links, logos, banner, cores, degradês e preview.
- `client/index.html`: página pública independente do cliente.
- `assets/`: arquivos estáticos.
- `supabase/schema.sql`: estrutura do banco.
- `supabase/CONFIGURAR.txt`: roteiro de conexão.

## Teste imediato
1. Extraia o ZIP.
2. Entre em `admin`.
3. Dê dois cliques em `index.html`.
4. Entre no modo DEMO.
5. Crie um cliente.
6. Personalize e clique em CRIAR PÁGINA.
7. Abra `client/index.html` para visualizar a página pública.

## Fluxo de produção
Você (admin) -> cria cliente -> personaliza -> salva no Supabase -> sistema gera slug/URL -> copia link -> envia ao cliente/NFC.

Cada cliente terá seus próprios dados, links e identidade visual. O cliente final acessa apenas a página pública.
