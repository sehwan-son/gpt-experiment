# gpt-experiment

논문 구현 재현, 새 GPU 기능 검증, 그리고 그 과정의 기록을 한 저장소 안에서 관리하기 위한 실험 레포입니다.

이 레포는 "채팅으로 작업 지시 -> Codex가 실행 -> 결과와 기록을 레포에 남김" 흐름을 기본 전제로 설계했습니다.

## 목적

- 논문에 공개된 코드나 방법을 재현하고 결과를 검증
- CUDA, PyTorch, Triton, FlashAttention 같은 GPU 관련 새 기능 실험
- 작업 단위별 계획, 실행 로그, 결과, blocker를 파일로 축적

## 디렉터리 구조

- `experiments/papers/`: 논문 재현용 코드와 메모
- `experiments/gpu/`: GPU 기능, 커널, 라이브러리 검증용 코드와 메모
- `tasks/active/`: 현재 진행 중인 작업 기록
- `tasks/completed/`: 완료된 작업 기록
- `templates/`: task/experiment 템플릿
- `logs/`: 전체 작업 이력
- `artifacts/`: 대용량 산출물 위치 안내
- `scripts/`: task 생성, 종료, 환경 스냅샷용 스크립트
- `docs/`: 운영 문서

## 기본 워크플로

1. 새 작업이 들어오면 `./scripts/new_task.sh "<title>" <paper|gpu|general> [slug]` 로 task를 엽니다.
2. 구현/실험 코드는 `experiments/papers/...` 또는 `experiments/gpu/...` 아래에 둡니다.
3. 핵심 명령, 실패 원인, 결정 사항은 task 폴더의 `notes.md`에 누적합니다.
4. 환경 정보가 중요하면 `./scripts/capture_env.sh <output.md>` 로 스냅샷을 남깁니다.
5. 결과 요약은 task 폴더의 `result.md`에 남깁니다.
6. 작업이 끝나면 `./scripts/close_task.sh <task-id>` 로 완료 처리합니다.

자세한 운영 규칙은 [docs/workflow.md](/Users/sonsehwan/Documents/gpt-experiment/docs/workflow.md) 와 [AGENTS.md](/Users/sonsehwan/Documents/gpt-experiment/AGENTS.md) 에 있습니다.

## 빠른 시작

```bash
./scripts/new_task.sh "flashattention 3 benchmark on local gpu" gpu
./scripts/new_task.sh "reproduce figure 2 of rotary positional embedding paper" paper
./scripts/new_task.sh "로컬 GPU에서 CUDA 그래프 동작 확인" gpu cuda-graphs-check
```

한글 제목만 써도 task는 생성되지만, 실험 경로 이름을 깔끔하게 유지하려면 세 번째 인자로 ASCII slug를 같이 주는 편이 좋습니다.

환경 스냅샷 예시:

```bash
./scripts/capture_env.sh tasks/active/<task-id>/env.md
```

완료 처리 예시:

```bash
./scripts/close_task.sh <task-id>
```

## 채팅 지시 예시

- "`FlashAttention-3`를 이 환경에서 빌드하고 benchmark까지 돌린 뒤 기록 남겨줘"
- "이 논문의 Figure 2를 재현 가능한지 확인하고 blocker를 task에 정리해줘"
- "CUDA의 새 기능이 현재 GPU에서 실제로 동작하는지 작은 repro 코드로 테스트해줘"

## GitHub remote 연결

로컬 저장소는 초기화되어 있습니다. GitHub remote는 네트워크 권한이 있을 때 아래 방식으로 연결하면 됩니다.

```bash
gh repo create <repo-name> --source=. --private --push
```

또는 수동으로 remote를 추가할 수 있습니다.
