#!/usr/bin/env bash
# GitHub 연동 테스트: 원격 저장소 읽기/쓰기 및 저장소 파일 확인
set -u
cd "$(dirname "$0")/.."

pass=0; fail=0
check() {
  local name="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "PASS  $name"; pass=$((pass+1))
  else echo "FAIL  $name"; fail=$((fail+1)); fi
}

check "origin 원격 저장소가 GitHub를 가리킴" bash -c 'git remote get-url origin | grep -q "github.com/chaosss81/webhosting"'
check "원격 저장소 접근 (ls-remote)"         git ls-remote --exit-code origin HEAD
check "main 브랜치 fetch"                    git fetch origin main
check "로컬과 원격 main 이력 연결"            git merge-base --is-ancestor origin/main HEAD
for f in index.html hello.html; do
  check "$f 존재 및 <html> 포함"             grep -qi "<html" "$f"
done
check "push 권한 확인 (dry-run)"             git push --dry-run origin HEAD

echo "----"; echo "통과: $pass, 실패: $fail"
[ "$fail" -eq 0 ]
