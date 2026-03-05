# 01. 저장소 구조 요약

## 루트 기준 핵심 디렉터리

- `backend/`: Clojure 기반 백엔드 서비스 (API, 인증, 스토리지, 마이그레이션, 비동기 작업 등)
- `frontend/`: ClojureScript + React 기반 프론트엔드 애플리케이션
- `common/`: 백엔드/프론트엔드가 공유하는 공통 로직
- `render-wasm/`: Rust + Emscripten 기반 WASM 렌더 엔진
- `exporter/`: 외부 렌더링/내보내기 관련 서비스
- `mcp/`: Penjar MCP 서버 및 관련 플러그인/도구
- `plugins/`: 플러그인 런타임, 샘플 플러그인, 타입/스타일 라이브러리
- `library/`: Penjar 파일 생성/내보내기를 위한 npm 라이브러리
- `docker/`: 로컬 개발환경/이미지/배포 실행 관련 Docker 설정
- `docs/`: 사용자/기술 문서(현재 문서 포함)

## 루트 핵심 파일

- `README.md`: 프로젝트 소개, 커뮤니티/리소스 링크, 기여 안내
- `manage.sh`: 개발 컨테이너 실행, 번들 빌드 등 루트 오케스트레이션 스크립트
- `package.json`: 루트 공통 스크립트(lint/fmt) 및 공통 JS 도구 정의

## 구조 이해 포인트

1. 개발의 중심 축은 `frontend + backend + common` 입니다.
2. `render-wasm`, `mcp`, `plugins`, `library`는 독립적 개발/배포 흐름이 가능한 확장 서브프로젝트입니다.
3. 대부분의 실전 로컬 개발은 `manage.sh` 또는 `docker/devenv` 기반으로 시작하는 편이 안전합니다.
