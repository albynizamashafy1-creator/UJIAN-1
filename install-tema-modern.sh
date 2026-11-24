#!/usr/bin/env bash
# =====================================================================
# TEMA MODERN UNTUK MOODLE (Boost) - tanpa plugin tambahan
# Mengubah: warna, font, sudut membulat, bayangan lembut, halaman login,
# navbar kaca (blur), kartu kursus, tombol gradien, tampilan soal & timer ujian.
#
# Cara pakai (dari folder yang sama dengan compose.yaml):
#   chmod +x install-tema-modern.sh && ./install-tema-modern.sh
# Warna utama bisa diganti dengan: WARNA=#0ea5e9 ./install-tema-modern.sh
# =====================================================================
set -euo pipefail

CONTAINER="${CONTAINER:-ujian-app}"
WARNA="${WARNA:-#4f46e5}"
CFG="php /opt/bitnami/moodle/admin/cli/cfg.php"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# ---------- 1. Variabel (Raw initial SCSS) ----------
cat > "$TMP/pre.scss" <<EOF
\$primary: ${WARNA};
\$body-bg: #f5f7fb;
\$body-color: #1e293b;
\$font-family-sans-serif: -apple-system, BlinkMacSystemFont, "Segoe UI", Inter, Roboto, "Helvetica Neue", Arial, sans-serif;
\$border-radius: .75rem;
\$border-radius-lg: 1rem;
\$border-radius-sm: .5rem;
\$card-border-radius: 1rem;
\$btn-border-radius: .75rem;
\$input-border-radius: .75rem;
\$input-border-color: #e2e8f0;
\$navbar-light-color: #334155;
EOF

# ---------- 2. Aturan tampilan (Raw SCSS) ----------
cat > "$TMP/main.scss" <<'EOF'
/* ===== Umum ===== */
body { -webkit-font-smoothing: antialiased; letter-spacing: -0.005em; }
h1, h2, h3, h4, .h1, .h2, .h3, .h4 { font-weight: 700; letter-spacing: -0.02em; }
a { transition: color .15s ease; }

/* ===== Navbar kaca ===== */
.navbar.fixed-top {
  background: rgba(255,255,255,.85) !important;
  backdrop-filter: saturate(180%) blur(14px);
  -webkit-backdrop-filter: saturate(180%) blur(14px);
  border-bottom: 0;
  box-shadow: 0 1px 0 rgba(15,23,42,.06), 0 8px 24px -12px rgba(15,23,42,.12);
}

/* ===== Kartu ===== */
.card {
  border: 1px solid rgba(15,23,42,.06);
  box-shadow: 0 1px 2px rgba(15,23,42,.05), 0 8px 24px -16px rgba(15,23,42,.15);
  transition: transform .2s ease, box-shadow .2s ease;
}
.dashboard-card:hover, .course-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 36px -14px rgba(79,70,229,.30);
}

/* ===== Tombol ===== */
.btn { font-weight: 600; padding: .55rem 1.15rem; transition: all .18s ease; }
.btn-primary {
  background-image: linear-gradient(135deg, #6366f1, #4f46e5);
  border: 0;
  box-shadow: 0 6px 16px -6px rgba(79,70,229,.55);
}
.btn-primary:hover, .btn-primary:focus {
  filter: brightness(1.08);
  transform: translateY(-1px);
  box-shadow: 0 10px 22px -8px rgba(79,70,229,.6);
}
.btn-secondary { background: #eef2ff; border-color: transparent; color: #3730a3; }
.btn-secondary:hover { background: #e0e7ff; color: #312e81; }

/* ===== Form ===== */
.form-control, .custom-select, .form-select {
  padding: .6rem .95rem;
  border-color: #e2e8f0;
  background-color: #fff;
  transition: border-color .15s ease, box-shadow .15s ease;
}
.form-control:focus, .custom-select:focus {
  border-color: #818cf8;
  box-shadow: 0 0 0 4px rgba(99,102,241,.15);
}

/* ===== Drawer / blok samping ===== */
.drawer { border: 0; box-shadow: 0 0 40px -18px rgba(15,23,42,.25); }
.activity-item, .course-content .section { border-radius: 1rem; }

/* ===== Halaman login ===== */
body#page-login-index {
  background: linear-gradient(135deg, #eef2ff 0%, #f5f3ff 45%, #ecfeff 100%);
  background-attachment: fixed;
}
#page-login-index .login-container, #page-login-index .card {
  border: 0;
  border-radius: 1.5rem;
  box-shadow: 0 30px 60px -20px rgba(79,70,229,.30);
}
#page-login-index .login-container { padding: 1rem 1.25rem; background: #fff; }
#page-login-index .btn-login, #page-login-index #loginbtn { width: 100%; padding: .75rem; font-size: 1.05rem; }
#page-login-index h1, #page-login-index .login-heading { font-weight: 800; }

/* ===== Ujian (Quiz) ===== */
.que {
  background: #fff;
  border: 0;
  border-radius: 1.1rem;
  box-shadow: 0 1px 2px rgba(15,23,42,.05), 0 12px 32px -18px rgba(15,23,42,.2);
  overflow: hidden;
  margin-bottom: 1.5rem;
}
.que .info {
  background: linear-gradient(180deg, #eef2ff, #f8faff);
  border: 0;
  border-radius: 0;
}
.que .info .no .qno { font-size: 1.6rem; font-weight: 800; color: #4338ca; }
.que .content { padding: 1.25rem 1.5rem; }
.que .qtext { font-size: 1.1rem; line-height: 1.75; color: #0f172a; }
.que .answer > div {
  padding: .6rem .9rem;
  margin-bottom: .4rem;
  border: 1px solid #e2e8f0;
  border-radius: .75rem;
  transition: all .15s ease;
}
.que .answer > div:hover { background: #f5f7ff; border-color: #c7d2fe; }
.que .answer input[type=radio]:checked ~ *, .que .answer input[type=checkbox]:checked ~ * { font-weight: 600; }

/* Navigasi nomor soal */
.qnbutton {
  border-radius: .65rem !important;
  border: 1px solid #e2e8f0 !important;
  font-weight: 600;
  transition: transform .12s ease;
}
.qnbutton:hover { transform: translateY(-2px); }
.qnbutton.thispage { box-shadow: 0 0 0 3px rgba(99,102,241,.35); }
.qnbutton.answersaved, .qnbutton.complete { background: #e0e7ff !important; border-color: #a5b4fc !important; }

/* Timer ujian */
#quiz-timer {
  border: 0;
  border-radius: 1rem;
  background: #0f172a;
  color: #fff;
  padding: .6rem 1rem;
  box-shadow: 0 10px 24px -10px rgba(15,23,42,.5);
}
#quiz-time-left { font-weight: 800; font-variant-numeric: tabular-nums; letter-spacing: .02em; }

/* ===== Tabel & badge ===== */
.generaltable { border-radius: 1rem; overflow: hidden; }
.generaltable thead th { background: #f1f5f9; border-bottom: 0; }
.badge { border-radius: 999px; padding: .35em .7em; font-weight: 600; }
EOF

# ---------- 3. Terapkan ke Moodle ----------
echo ">> Menerapkan tema ke container $CONTAINER ..."
docker cp "$TMP/pre.scss"  "$CONTAINER:/tmp/pre.scss"
docker cp "$TMP/main.scss" "$CONTAINER:/tmp/main.scss"

docker exec -u daemon "$CONTAINER" sh -c "
  $CFG --component=theme_boost --name=brandcolor --set='${WARNA}' &&
  $CFG --component=theme_boost --name=scsspre --set=\"\$(cat /tmp/pre.scss)\" &&
  $CFG --component=theme_boost --name=scss    --set=\"\$(cat /tmp/main.scss)\" &&
  php /opt/bitnami/moodle/admin/cli/purge_caches.php
"
docker exec "$CONTAINER" rm -f /tmp/pre.scss /tmp/main.scss

echo ">> Selesai. Tekan Ctrl+Shift+R di browser untuk memuat ulang tampilan."
