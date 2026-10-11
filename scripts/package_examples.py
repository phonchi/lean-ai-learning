"""只打包教材專案原始檔，排除工具鏈、cache 與驗證紀錄。"""
from pathlib import Path
import hashlib
import json
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "lean-examples"
REQUIRED = ["lean-toolchain", "lakefile.toml", "lake-manifest.json", "Course.lean", "README.md"]
for name in REQUIRED:
    if not (SOURCE / name).is_file():
        raise SystemExit(f"尚未建立必要的 Lean 專案檔案：{name}")
files = sorted(p for p in SOURCE.rglob("*") if p.is_file() and not any(part in {".lake", ".git", "__pycache__", ".venv"} for part in p.relative_to(SOURCE).parts) and p.suffix not in {".olean", ".ilean", ".log", ".pyc"})
output = ROOT / "public" / "downloads"
output.mkdir(parents=True, exist_ok=True)
archive = output / "lean-ai-examples.zip"
with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as z:
    for file in files:
        info = zipfile.ZipInfo("lean-ai-examples/" + file.relative_to(SOURCE).as_posix(), (2026, 10, 11, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = 0o644 << 16
        z.writestr(info, file.read_bytes())
manifest = {"archive": archive.name, "sha256": hashlib.sha256(archive.read_bytes()).hexdigest(), "file_count": len(files), "files": [p.relative_to(SOURCE).as_posix() for p in files]}
(output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
print(f"已打包 {len(files)} 個 Lean 專案檔案：{archive.relative_to(ROOT)}")
