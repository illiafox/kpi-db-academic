#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${PG_CONTAINER:-shop-postgres}"
DB="${PG_DB:-shopdb}"
USER="${PG_USER:-shop}"

DIR="${1:-queries}"

if [[ ! -d "$DIR" ]]; then
  echo "Directory not found: $DIR" >&2
  exit 1
fi

mapfile -t files < <(find "$DIR" -maxdepth 1 -type f -name '*.sql' | sort)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No .sql files found in $DIR" >&2
  exit 1
fi

for f in "${files[@]}"; do
  echo "==> Running $(basename "$f")"
  docker exec -i "$CONTAINER" psql -U "$USER" -d "$DB" -v ON_ERROR_STOP=1 < "$f"
done

echo "Done. Ran ${#files[@]} queries."
