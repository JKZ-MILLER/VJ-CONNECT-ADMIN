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
  icon_key text default 'link',
  icon_url text,
  enabled boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists client_links_client_id_idx on public.client_links(client_id);

alter table public.clients enable row level security;
alter table public.client_links enable row level security;

drop policy if exists "public_read_published_clients" on public.clients;
create policy "public_read_published_clients"
on public.clients for select
using (published = true);

drop policy if exists "authenticated_insert_clients" on public.clients;
create policy "authenticated_insert_clients"
on public.clients for insert to authenticated
with check (true);

drop policy if exists "authenticated_update_clients" on public.clients;
create policy "authenticated_update_clients"
on public.clients for update to authenticated
using (true) with check (true);

drop policy if exists "authenticated_delete_clients" on public.clients;
create policy "authenticated_delete_clients"
on public.clients for delete to authenticated
using (true);

drop policy if exists "public_read_enabled_links" on public.client_links;
create policy "public_read_enabled_links"
on public.client_links for select
using (
  enabled = true and exists (
    select 1 from public.clients c
    where c.id = client_links.client_id and c.published = true
  )
);

drop policy if exists "authenticated_insert_links" on public.client_links;
create policy "authenticated_insert_links"
on public.client_links for insert to authenticated
with check (true);

drop policy if exists "authenticated_update_links" on public.client_links;
create policy "authenticated_update_links"
on public.client_links for update to authenticated
using (true) with check (true);

drop policy if exists "authenticated_delete_links" on public.client_links;
create policy "authenticated_delete_links"
on public.client_links for delete to authenticated
using (true);

insert into storage.buckets (id,name,public)
values ('client-assets','client-assets',true)
on conflict (id) do update set public=true;

drop policy if exists "public_read_client_assets" on storage.objects;
create policy "public_read_client_assets"
on storage.objects for select
using (bucket_id='client-assets');

drop policy if exists "authenticated_upload_client_assets" on storage.objects;
create policy "authenticated_upload_client_assets"
on storage.objects for insert to authenticated
with check (bucket_id='client-assets');

drop policy if exists "authenticated_update_client_assets" on storage.objects;
create policy "authenticated_update_client_assets"
on storage.objects for update to authenticated
using (bucket_id='client-assets') with check (bucket_id='client-assets');

drop policy if exists "authenticated_delete_client_assets" on storage.objects;
create policy "authenticated_delete_client_assets"
on storage.objects for delete to authenticated
using (bucket_id='client-assets');
