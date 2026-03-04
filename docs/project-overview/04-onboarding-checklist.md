# 04. 개발 시작 체크리스트

## 0) 문서 우선순위

1. 루트 `README.md`
2. `docs/technical-guide/developer/*`
3. 프로젝트별 README (`mcp/README.md`, `plugins/README.md`, `library/README.md`, `render-wasm/README.md`)

## 1) 환경 확인

- Node.js / corepack / pnpm
- Docker & Docker Compose
- Clojure CLI
- (필요 시) Rust/Emscripten

## 2) 진입 순서 추천

1. `manage.sh`로 개발 환경 기동 구조 파악
2. `frontend`와 `backend`를 각각 단독 빌드/테스트 해보기
3. 변경 대상이 `common`에 닿는지 먼저 확인
4. 부가 영역(`plugins`, `mcp`, `render-wasm`, `library`)은 기능 요구에 따라 개별 진입

## 3) 작업 전 확인 항목

- 변경 범위가 단일 앱인지(예: frontend만) 다중 서브시스템인지
- Docker 기반 실행이 필요한지, 로컬 단독 실행이 가능한지
- 린트/포맷/테스트 명령을 어느 레벨(루트/서브프로젝트)에서 실행할지

## 4) 리뷰 포인트

- 설계 변경이면 `docs/technical-guide/developer` 하위 문서도 함께 업데이트
- 저장소가 모노레포 성격이므로, 커밋 메시지에 영향 영역(frontend/backend/common 등)을 명시
