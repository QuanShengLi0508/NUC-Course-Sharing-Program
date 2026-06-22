// Supabase configuration for NUC Course Hub
// Replace these with your actual Supabase project credentials
const SUPABASE_URL = "https://YOUR_PROJECT_ID.supabase.co";
const SUPABASE_ANON_KEY = "YOUR_ANON_KEY";

const supabaseHeaders = {
  apikey: SUPABASE_ANON_KEY,
  Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
  "Content-Type": "application/json",
  Prefer: "return=representation",
};

export async function supabaseInsert(table, data) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}`, {
    method: "POST",
    headers: supabaseHeaders,
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`Insert failed: ${res.status}`);
  return res.json();
}

export async function supabaseSelect(table, { order = "created_at.desc", limit = 20, filter = "" } = {}) {
  const params = new URLSearchParams({ order, limit: String(limit) });
  const url = filter
    ? `${SUPABASE_URL}/rest/v1/${table}?${filter}&${params}`
    : `${SUPABASE_URL}/rest/v1/${table}?${params}`;
  const res = await fetch(url, {
    headers: { apikey: SUPABASE_ANON_KEY, Authorization: `Bearer ${SUPABASE_ANON_KEY}` },
  });
  if (!res.ok) throw new Error(`Select failed: ${res.status}`);
  return res.json();
}

export function isConfigured() {
  return !SUPABASE_URL.includes("YOUR_PROJECT_ID");
}
