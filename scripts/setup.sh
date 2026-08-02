#!/usr/bin/env bash
# One-command environment setup for the translate-explain-pdf skill.
# Idempotent: safe to run multiple times, skips work that's already done.
#
# Usage:
#   bash scripts/setup.sh

set -e

echo "== translate-explain-pdf: environment setup =="

# --- 1. Python packages ---
if python3 -c "import weasyprint, trafilatura" 2>/dev/null; then
    echo "[ok] weasyprint + trafilatura already installed"
else
    echo "[..] installing weasyprint + trafilatura"
    pip install weasyprint trafilatura --break-system-packages
fi

# --- 2. Arabic fonts (Debian/Ubuntu only) ---
if command -v apt-get >/dev/null 2>&1; then
    if fc-list | grep -qi "amiri"; then
        echo "[ok] Arabic fonts already installed"
    else
        echo "[..] installing Arabic fonts (fonts-hosny-amiri, fonts-sil-scheherazade, fonts-kacst)"
        apt-get update -qq
        apt-get install -y fonts-hosny-amiri fonts-sil-scheherazade fonts-kacst
    fi
else
    echo "[!!] apt-get not found -- please install Arabic-capable fonts manually"
    echo "     (e.g. Amiri, Scheherazade, or any font with Arabic glyph coverage)"
fi

# --- 3. Verify everything works end-to-end ---
echo "[..] running a render smoke test"
python3 - <<'PY'
from weasyprint import HTML
import tempfile, os

html = """<!DOCTYPE html><html dir="rtl" lang="ar"><body>
<p style="font-family:'Amiri',sans-serif;">اختبار — لو النص ده ظاهر صح، الإعداد تمام.</p>
</body></html>"""

out = os.path.join(tempfile.gettempdir(), "setup_smoke_test.pdf")
HTML(string=html).write_pdf(out)
print(f"[ok] smoke test PDF written to {out}")
PY

echo "== setup complete =="
