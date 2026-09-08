-- VJ CONNECT — banco base
create extension if not exists pgcrypto;

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  bio text default '',
  logo_url text,
  banner_url text,
  theme jsonb not null default '{}'::jsonb,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.client_links (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.clients(id) on delete cascade,
  position integer not null default 0,
  label text not null,
  url text not null,
  icon_key text,
  icon_url text,
  enabled boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists client_links_client_id_idx on public.client_links(client_id);

alter table public.clients enable row level security;
alter table public.client_links enable row level security;

create policy "public_can_read_published_clients"
on public.clients for select
using (published = true);

create policy "public_can_read_enabled_links"
on public.client_links for select
using (
  enabled = true
  and exists (
    select 1 from public.clients c
    where c.id = client_links.client_id and c.published = true
  )
);

-- Escrita administrativa será liberada via Supabase Auth + políticas do usuário admin
-- na etapa de conexão do projeto.
