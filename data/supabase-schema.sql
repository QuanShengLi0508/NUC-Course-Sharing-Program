-- Supabase SQL Schema for NUC Course Hub
-- Run this in Supabase SQL Editor (https://supabase.com/dashboard)

-- 1. 贡献表
create table contributions (
  id bigint generated always as identity primary key,
  contributor_name text default '匿名',
  student_id text default '',
  course_name text not null,
  title text not null,
  link text default '',
  note text default '',
  is_anonymous boolean default false,
  created_at timestamptz default now()
);

-- 2. 评论表
create table comments (
  id bigint generated always as identity primary key,
  commenter_name text default '匿名',
  student_id text default '',
  body text not null,
  is_anonymous boolean default false,
  created_at timestamptz default now()
);

-- 3. 课程评价表
create table course_reviews (
  id bigint generated always as identity primary key,
  course_name text not null,
  difficulty text not null default '中等',
  tips text not null,
  created_at timestamptz default now()
);

-- 4. 课程级评论表
create table course_comments (
  id bigint generated always as identity primary key,
  course_name text not null,
  body text not null,
  commenter_name text default '匿名',
  created_at timestamptz default now()
);

-- Enable Row Level Security
alter table contributions enable row level security;
alter table comments enable row level security;
alter table course_reviews enable row level security;
alter table course_comments enable row level security;

-- Allow anonymous read
create policy "Anyone can read contributions" on contributions for select using (true);
create policy "Anyone can read comments" on comments for select using (true);
create policy "Anyone can read course_reviews" on course_reviews for select using (true);
create policy "Anyone can read course_comments" on course_comments for select using (true);

-- Allow anonymous insert
create policy "Anyone can insert contributions" on contributions for insert with check (true);
create policy "Anyone can insert comments" on comments for insert with check (true);
create policy "Anyone can insert course_reviews" on course_reviews for insert with check (true);
create policy "Anyone can insert course_comments" on course_comments for insert with check (true);
