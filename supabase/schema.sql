
create extension if not exists pgcrypto;

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  bio text default '',
  logo_url text default '',
  banner_url text default '',
  theme jsonb not null default '{"bg":"#f5efe4","card":"#151515","accent":"#d8b45d","text":"#171717","radius":16}'::jsonb,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.client_links (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.clients(id) on delete cascade,
  position integer not null default 0,
  label text not null,
  url text not null,
  icon_key text not null default 'link',
  icon_url text default '',
  enabled boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.clients enable row level security;
alter table public.client_links enable row level security;

-- Public: only published client data is readable.
drop policy if exists "public_read_published_clients" on public.clients;
create policy "public_read_published_clients"
on public.clients for select
to anon, authenticated
using (published = true);

drop policy if exists "public_read_published_links" on public.client_links;
create policy "public_read_published_links"
on public.client_links for select
to anon, authenticated
using (
  enabled = true and exists (
    select 1 from public.clients c
    where c.id = client_id and c.published = true
  )
);

-- Admin: only authenticated users can manage the data.
-- For a production deployment, replace this with an allow-list of admin user IDs.
drop policy if exists "authenticated_manage_clients" on public.clients;
create policy "authenticated_manage_clients"
on public.clients for all
to authenticated
using (true)
with check (true);

drop policy if exists "authenticated_manage_links" on public.client_links;
create policy "authenticated_manage_links"
on public.client_links for all
to authenticated
using (true)
with check (true);

create index if not exists client_links_client_position_idx
on public.client_links(client_id, position);
create index if not exists clients_slug_idx on public.clients(slug);

-- Storage buckets
insert into storage.buckets (id, name, public)
values ('vj-client-assets','vj-client-assets',true)
on conflict (id) do nothing;

drop policy if exists "public_read_client_assets" on storage.objects;
create policy "public_read_client_assets"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'vj-client-assets');

drop policy if exists "authenticated_upload_client_assets" on storage.objects;
create policy "authenticated_upload_client_assets"
on storage.objects for insert
to authenticated
with check (bucket_id = 'vj-client-assets');

drop policy if exists "authenticated_update_client_assets" on storage.objects;
create policy "authenticated_update_client_assets"
on storage.objects for update
to authenticated
using (bucket_id = 'vj-client-assets')
with check (bucket_id = 'vj-client-assets');
