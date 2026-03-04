# 02. 기술 스택 및 빌드/실행 흐름

## 언어/런타임

- 백엔드: **Clojure** (deps.edn 기반)
- 프론트엔드: **ClojureScript + React + Node.js(pnpm)**
- 렌더 엔진: **Rust + Emscripten(WebAssembly)**
- 플러그인/보조 툴: **TypeScript/Node.js**

## 패키지/의존성 관리

- Clojure 파트는 `deps.edn` 사용
- JS/TS 파트는 `pnpm` 사용
- 루트 및 하위 프로젝트별 `package.json`이 존재하며, 스크립트가 분리되어 있음

## 대표 개발 흐름

### 1) 로컬 개발환경 준비

- 보통 `manage.sh`를 이용해 Docker 기반 개발 환경을 올린 뒤 작업
- `docker/devenv` 설정으로 팀 공통 환경 차이를 줄일 수 있음

### 2) 프론트엔드 개발

- `frontend/package.json`의 watch/build/test 스크립트 사용
- `shadow-cljs` 기반 컴파일 + JS 번들/자산 빌드 스크립트가 결합됨

### 3) 백엔드 개발

- `backend/deps.edn`의 alias(`:dev`, `:test`, `:build`) 중심으로 실행
- DB, 캐시, 스토리지 등 외부 의존 자원을 개발 컨테이너와 함께 사용

### 4) 번들/배포 산출물

- 루트 `manage.sh`에서 frontend/backend/mcp/exporter 번들 빌드를 지원
- 각 산출물은 라이선스 파일과 버전 파일을 포함하도록 구성됨

## 빠른 진입 팁

- 첫 탐색은 `README.md` → `manage.sh` → 각 하위 프로젝트 `package.json`/`deps.edn` 순서 권장
- 기능 수정 시 `common/` 영향 범위를 먼저 체크하면 회귀를 줄일 수 있음
